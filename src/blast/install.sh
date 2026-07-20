#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'BLAST+'"

VERSION="${VERSION:-latest}"

# 1. Dynamic architecture detection
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64|amd64)
        ARCHITECTURE="x64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="aarch64"
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

# 3. Install permanent runtime dependencies (OpenMP is mandatory, Legacy Network is optional)
echo "Installing BLAST+ shared runtime dependencies..."
case "${PACKAGE_MANAGER}" in
    apt)
        apt-get update && apt-get install -y --no-install-recommends libgomp1
        if apt-cache show libnsl2 >/dev/null 2>&1; then
            apt-get install -y --no-install-recommends libnsl2 || true
        elif apt-cache show libnsl1 >/dev/null 2>&1; then
            apt-get install -y --no-install-recommends libnsl1 || true
        fi
        ;;
    dnf|yum)
        ${PACKAGE_MANAGER} install -y libgomp
        ${PACKAGE_MANAGER} install -y libnsl || true
        ;;
    zypper)
        zypper refresh && zypper install -y libgomp1
        # Fallback sequence to handle deprecation in openSUSE Leap 16+
        zypper install -y libnsl1 || zypper install -y libnsl2 || true
        ;;
    pacman)
        pacman -Sy --noconfirm gcc-libs
        pacman -S --noconfirm libnsl || true
        ;;
    *)
        echo "Warning: Unknown package manager. Skipping shared library validation." >&2
        ;;
esac

# 4. Ensure baseline setup utilities exist temporarily
CURL_INSTALLED=false
TAR_INSTALLED=false

if ! command -v curl >/dev/null 2>&1; then
    echo "curl missing. Installing..."
    case "${PACKAGE_MANAGER}" in
        apt)
            apt-get install -y --no-install-recommends curl ca-certificates
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

if ! command -v tar >/dev/null 2>&1 || ! command -v gzip >/dev/null 2>&1; then
    echo "Archive utilities missing. Installing tar/gzip..."
    case "${PACKAGE_MANAGER}" in
        apt)
            apt-get install -y --no-install-recommends tar gzip
            ;;
        dnf|yum|zypper|pacman)
            ${PACKAGE_MANAGER} install -y tar gzip
            ;;
    esac
    TAR_INSTALLED=true
fi

# Move into temporary files directory
cd /tmp

# 5. Resolve exact download path URLs
if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -sSL https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION | tr -d '\r\n ')
    URL="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-${VERSION}+-${ARCHITECTURE}-linux.tar.gz"
else
    URL="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${VERSION}/ncbi-blast-${VERSION}+-${ARCHITECTURE}-linux.tar.gz"
fi

SOURCE="ncbi-blast-${VERSION}+"
TARBALL="${SOURCE}-${ARCHITECTURE}-linux.tar.gz"

echo "Downloading BLAST+ version ${VERSION} for ${ARCHITECTURE}..."
curl -sSLf -o "${TARBALL}" "${URL}"

echo "Extracting binaries..."
tar -xzf "${TARBALL}"
cd "${SOURCE}"

# Install BLAST+ binaries globally
echo "Deploying binaries to /usr/local/bin..."
mv bin/* /usr/local/bin/

# Clean up working extraction footprint
cd /tmp
rm -rf "${SOURCE}" "${TARBALL}"

# 6. Clean up temporary setup packages if they were installed by this feature hook
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

echo "BLAST+ installation completed successfully!"
