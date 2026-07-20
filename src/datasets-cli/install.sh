#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'datasets-cli'"

# 1. Dynamic architecture detection
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64|amd64)
        ARCHITECTURE="linux-amd64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="linux-arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

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

# 3. Ensure baseline download utilities exist temporarily
CURL_INSTALLED=false

if ! command -v curl >/dev/null 2>&1; then
    echo "curl missing. Installing..."
    case "${PACKAGE_MANAGER}" in
        apt)
            apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
            ;;
        dnf|yum|zypper|pacman)
            ${PACKAGE_MANAGER} install -y curl ca-certificates
            ;;
        *)
            echo "Error: curl is required but package manager could not be resolved." >&2
            exit 1
            ;;
    esac
    CURL_INSTALLED=true
fi

# Move into temporary files directory
cd /tmp

# 4. Fetch the appropriate standalone binary
URL="https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/${ARCHITECTURE}/datasets"
echo "Downloading NCBI Datasets CLI for ${ARCHITECTURE}..."
curl -sSLf -O "${URL}"

# 5. Install binary globally
echo "Deploying binary to /usr/local/bin..."
chmod +x datasets
mv datasets /usr/local/bin/

# 6. Clean up temporary setup packages if they were newly installed by this hook
if [ "${CURL_INSTALLED}" = "true" ]; then
    echo "Removing temporary curl installation..."
    case "${PACKAGE_MANAGER}" in
        apt)
            apt-get purge -y curl && apt-get autoremove -y
            ;;
        dnf|yum|zypper)
            ${PACKAGE_MANAGER} remove -y curl
            ;;
        pacman)
            pacman -Rns --noconfirm curl
            ;;
    esac
fi

echo "NCBI Datasets CLI installation completed successfully!"