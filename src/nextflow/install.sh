#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'Nextflow'"

VERSION="${VERSION:-"latest"}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
NEXTFLOW_DIR="/usr/local/bin"

# 1. Determine the appropriate non-root user context
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" > /dev/null 2>&1; then
    USERNAME=root
fi

# 2. Package manager auto-detection
if command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
elif command -v zypper >/dev/null 2>&1; then
    PACKAGE_MANAGER="zypper"
elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
else
    PACKAGE_MANAGER="unknown"
fi

# 3. Provision system baseline dependencies + Resilient Java 17 to 26 Selection
echo "Installing Nextflow runtime and system dependencies..."
case "${PACKAGE_MANAGER}" in
    apt)
        apt-get update
        apt-get install -y --no-install-recommends curl ca-certificates zip unzip sed
        
        if apt-get install -y --no-install-recommends openjdk-21-jre-headless 2>/dev/null; then
            echo "Successfully deployed OpenJDK 21"
        elif apt-get install -y --no-install-recommends openjdk-17-jre-headless 2>/dev/null; then
            echo "Successfully deployed OpenJDK 17"
        else
            echo "Falling back to system default-jre-headless..."
            apt-get install -y --no-install-recommends default-jre-headless
        fi
        ;;
    dnf|yum)
        ${PACKAGE_MANAGER} install -y curl ca-certificates zip unzip sed
        
        # Resilient multi-tier cascade for modern Fedora/RHEL targets
        if ${PACKAGE_MANAGER} install -y java-21-openjdk-headless 2>/dev/null; then
            echo "Successfully deployed OpenJDK 21"
        elif ${PACKAGE_MANAGER} install -y java-17-openjdk-headless 2>/dev/null; then
            echo "Successfully deployed OpenJDK 17"
        elif ${PACKAGE_MANAGER} install -y java-latest-openjdk-headless 2>/dev/null; then
            echo "Successfully deployed Latest OpenJDK Release"
        else
            echo "Falling back to generic java-openjdk..."
            ${PACKAGE_MANAGER} install -y java-openjdk
        fi
        ;;
    zypper)
        zypper refresh
        zypper install -y curl ca-certificates zip unzip sed
        
        # Resilient multi-tier cascade for openSUSE Leap/Tumbleweed targets
        if zypper install -y java-21-openjdk 2>/dev/null; then
            echo "Successfully deployed OpenJDK 21"
        elif zypper install -y java-17-openjdk 2>/dev/null; then
            echo "Successfully deployed OpenJDK 17"
        else
            echo "Falling back to generic headless java dependency..."
            zypper install -y java-openjdk
        fi
        ;;
    pacman)
        pacman -Sy --noconfirm curl ca-certificates zip unzip sed jre-openjdk-headless
        ;;
    *)
        if ! command -v java >/dev/null 2>&1; then
            echo "Error: Java Runtime Environment (JRE) is missing and package manager could not be determined." >&2
            exit 1
        fi
        ;;
esac

# 4. Create Nextflow specialized access group
if ! getent group nextflow > /dev/null 2>&1; then
    groupadd -r nextflow
fi

if [ "${USERNAME}" != "root" ]; then
    usermod -a -G nextflow "${USERNAME}"
fi

# 5. Secure binary download and version pinning setup
echo "Downloading Nextflow installer..."
mkdir -p "${NEXTFLOW_DIR}"
cd "${NEXTFLOW_DIR}"

if [ "${VERSION}" != "latest" ] && [ -n "${VERSION}" ]; then
    echo "Targeting explicit Nextflow version artifact: ${VERSION}"
    export NXF_VER="${VERSION}"
fi

curl -sSL https://get.nextflow.io | bash

chmod 0755 nextflow
chown "${USERNAME}:nextflow" nextflow

# 6. Pre-cache Nextflow core engine runtime dependencies
echo "Initializing Nextflow runtime structures..."
export NXF_HOME="/tmp/.nextflow-cache"
mkdir -p "${NXF_HOME}"
chmod 777 "${NXF_HOME}"

./nextflow info

# Synchronize runtime cache location targets to user home profile directories
if [ "${USERNAME}" != "root" ] && [ -n "${_REMOTE_USER_HOME}" ]; then
    USER_NXF_HOME="${_REMOTE_USER_HOME}/.nextflow"
    mkdir -p "${USER_NXF_HOME}"
    cp -r "${NXF_HOME}"/* "${USER_NXF_HOME}/" || true
    chown -R "${USERNAME}:${USERNAME}" "${USER_NXF_HOME}"
fi

rm -rf "${NXF_HOME}"
echo "Nextflow installation completed successfully!"