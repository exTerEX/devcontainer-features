#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'nf-test'"

VERSION="${VERSION:-"latest"}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
NFTEST_DIR="/opt/nf-test"

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

# 3. Provision system baseline dependencies + Resilient Java Selection Cascade
echo "Installing nf-test runtime and system dependencies..."
case "${PACKAGE_MANAGER}" in
    apt)
        apt-get update
        apt-get install -y --no-install-recommends curl ca-certificates zip unzip sed
        
        # Handle the historical 'which' vs 'debianutils' package split safely
        if ! command -v which >/dev/null 2>&1; then
            if apt-get install -y --no-install-recommends which 2>/dev/null; then
                echo "Successfully installed 'which' via dedicated package."
            else
                echo "'which' package unavailable. Falling back to 'debianutils'..."
                apt-get install -y --no-install-recommends debianutils
            fi
        fi
        
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
        ${PACKAGE_MANAGER} install -y curl ca-certificates zip unzip sed which
        
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
        zypper install -y curl ca-certificates zip unzip sed which
        
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
        pacman -Sy --noconfirm curl ca-certificates zip unzip sed which jre-openjdk-headless
        ;;
    *)
        if ! command -v java >/dev/null 2>&1; then
            echo "Error: Java Runtime Environment (JRE) is missing and package manager could not be determined." >&2
            exit 1
        fi
        ;;
esac

# 4. Create specialized access security groups
if ! getent group nftest > /dev/null 2>&1; then
    groupadd -r nftest
fi

if [ "${USERNAME}" != "root" ]; then
    usermod -a -G nftest "${USERNAME}"
fi

# 5. Secure target binary paths and versioning hooks
echo "Installing nf-test framework..."
mkdir -p "${NFTEST_DIR}/bin"
chown -R "${USERNAME}:nftest" "${NFTEST_DIR}"
chmod -R g+r+w "${NFTEST_DIR}"

cd "${NFTEST_DIR}/bin"

if [ "${VERSION}" != "latest" ] && [ -n "${VERSION}" ]; then
    echo "Targeting explicit version pin parameter: ${VERSION}"
    curl -fsSL https://code.askimed.com/install/nf-test | bash -s "${VERSION}"
else
    echo "Resolving latest stable nf-test package..."
    curl -fsSL https://code.askimed.com/install/nf-test | bash
fi

# Expose the binary globally to standard system PATH layouts
ln -sf "${NFTEST_DIR}/bin/nf-test" /usr/local/bin/nf-test

find "${NFTEST_DIR}" -type d -print0 | xargs -n 1 -0 chmod g+s

# 6. Synchronize initial internal configuration states to user profile homes
if [ "${USERNAME}" != "root" ] && [ -n "${_REMOTE_USER_HOME}" ]; then
    if [ -d "$HOME/.nf-test" ]; then
        mkdir -p "${_REMOTE_USER_HOME}/.nf-test"
        cp -R "$HOME/.nf-test"/* "${_REMOTE_USER_HOME}/.nf-test/" || true
        chown -R "${USERNAME}:${USERNAME}" "${_REMOTE_USER_HOME}/.nf-test"
    fi
fi

echo "nf-test installation completed successfully!"