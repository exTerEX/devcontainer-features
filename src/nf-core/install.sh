#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'nf-core tools'"

# Read from the unique option variable to avoid system keyword collision
TARGET_VERSION="${TOOLVERSION:-"latest"}"

# 1. Package manager auto-detection
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

# 2. Provision system baseline dependencies (Python, Git, curl)
echo "Installing nf-core system dependencies..."
case "${PACKAGE_MANAGER}" in
    apt)
        apt-get update
        apt-get install -y --no-install-recommends python3 python3-venv python3-pip git curl ca-certificates
        ;;
    dnf|yum)
        ${PACKAGE_MANAGER} install -y python3 python3-pip git curl ca-certificates
        ;;
    zypper)
        zypper refresh
        zypper install -y python3 python3-pip git curl ca-certificates
        ;;
    pacman)
        pacman -Sy --noconfirm python python-pip git curl ca-certificates
        ;;
    *)
        if ! command -v python3 >/dev/null 2>&1; then
            echo "Error: Python 3 is missing and package manager could not be determined." >&2
            exit 1
        fi
        ;;
esac

if ! command -v python3 >/dev/null 2>&1 && command -v python >/dev/null 2>&1; then
    ln -s "$(command -v python)" /usr/local/bin/python3
fi

# 3. Create an isolated Python Virtual Environment
VENV_DIR="/opt/nf-core-env"
echo "Creating isolated virtual environment for nf-core at ${VENV_DIR}..."
python3 -m venv "${VENV_DIR}"
"${VENV_DIR}/bin/pip" install --no-cache-dir --upgrade pip

# 4. Install nf-core and handle version pinning safely
if [ "${TARGET_VERSION}" = "latest" ] || [ -z "${TARGET_VERSION}" ]; then
    echo "Installing latest nf-core release..."
    "${VENV_DIR}/bin/pip" install --no-cache-dir nf-core
else
    echo "Targeting explicit nf-core version: ${TARGET_VERSION}"
    "${VENV_DIR}/bin/pip" install --no-cache-dir "nf-core==${TARGET_VERSION}"
fi

# 5. Expose the binary globally
echo "Symlinking nf-core binary to /usr/local/bin..."
ln -sf "${VENV_DIR}/bin/nf-core" /usr/local/bin/nf-core

echo "nf-core tools installation completed successfully!"
