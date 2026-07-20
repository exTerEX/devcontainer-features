#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.' >&2
    exit 1
fi

echo "Activating feature 'BCFtools'"

VERSION="${VERSION:-latest}"

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

# 2. Install permanent runtime libraries to support BCFtools execution
echo "Installing BCFtools shared runtime dependencies..."
case "${PACKAGE_MANAGER}" in
    apt)
        apt-get update && apt-get install -y --no-install-recommends \
            zlib1g libncursesw6 libbz2-1.0 liblzma5 libcurl4
        ;;
    dnf|yum)
        ${PACKAGE_MANAGER} install -y zlib ncurses-libs bzip2-libs xz-libs libcurl
        ;;
    zypper)
        zypper refresh && zypper install -y libz1 libncurses6 libbz2-1 liblzma5 libcurl4
        ;;
    pacman)
        pacman -Sy --noconfirm zlib ncurses bzip2 xz curl
        ;;
    *)
        echo "Warning: Unknown package manager. Skipping shared library validation." >&2
        ;;
esac

# 3. Handle temporary build tools and compilation headers
GCC_INSTALLED=false
MAKE_INSTALLED=false
CURL_INSTALLED=false
TAR_INSTALLED=false
BZIP2_INSTALLED=false
HEADERS_INSTALLED=false

install_build_pkg() {
    case "${PACKAGE_MANAGER}" in
        apt)
            apt-get install -y --no-install-recommends $1
            ;;
        dnf|yum)
            ${PACKAGE_MANAGER} install -y $1
            ;;
        zypper)
            zypper --non-interactive install -y --no-recommends $1
            ;;
        pacman)
            pacman -S --noconfirm $1
            ;;
    esac
}

if ! command -v gcc >/dev/null 2>&1; then GCC_INSTALLED=true; install_build_pkg "gcc"; fi
if ! command -v make >/dev/null 2>&1; then MAKE_INSTALLED=true; install_build_pkg "make"; fi
if ! command -v curl >/dev/null 2>&1; then CURL_INSTALLED=true; install_build_pkg "curl ca-certificates"; fi
if ! command -v tar >/dev/null 2>&1; then TAR_INSTALLED=true; install_build_pkg "tar"; fi
if ! command -v bzip2 >/dev/null 2>&1; then BZIP2_INSTALLED=true; install_build_pkg "bzip2"; fi

# Install development headers needed for compilation
echo "Installing temporary development headers..."
HEADERS_INSTALLED=true

case "${PACKAGE_MANAGER}" in
    apt)
        install_build_pkg "zlib1g-dev libncurses-dev libbz2-dev liblzma-dev libcurl4-openssl-dev"
        ;;
    dnf|yum)
        install_build_pkg "zlib-devel ncurses-devel bzip2-devel xz-devel libcurl-devel"
        ;;
    zypper)
        install_build_pkg "zlib-devel ncurses-devel libbz2-devel xz-devel libcurl-devel"
        ;;
    pacman)
        HEADERS_INSTALLED=false
        ;;
esac

# Move into temporary directory
cd /tmp

# 4. Resolve latest version and URLs if requested (Points to the bcftools repository)
if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -sIL -o /dev/null -w '%{url_effective}' "https://github.com/samtools/bcftools/releases/latest" | grep -oE "[^/]+$")
fi

echo "Downloading BCFtools version ${VERSION}..."
URL="https://github.com/samtools/bcftools/releases/download/${VERSION}/bcftools-${VERSION}.tar.bz2"
SOURCE="bcftools-${VERSION}"
TARBALL="${SOURCE}.tar.bz2"

curl -sSLf -o "${TARBALL}" "${URL}"

echo "Extracting source codebase..."
tar -xjf "${TARBALL}"
cd "${SOURCE}"

# 5. Compile and deploy
echo "Configuring and compiling BCFtools natively..."
./configure --prefix=/usr/local
make
echo "Deploying binaries to /usr/local/bin..."
make install

# Clean up build directory footprint
cd /tmp
rm -rf "${SOURCE}" "${TARBALL}"

# 6. Clean up temporary tools and headers to minimize image footprint
echo "Scrubbing temporary compilation layers..."
if [ "${HEADERS_INSTALLED}" = "true" ]; then
    case "${PACKAGE_MANAGER}" in
        apt) apt-get purge -y zlib1g-dev libncurses-dev libbz2-dev liblzma-dev libcurl4-openssl-dev ;;
        dnf|yum) ${PACKAGE_MANAGER} remove -y zlib-devel ncurses-devel bzip2-devel xz-devel libcurl-devel ;;
        zypper) zypper --non-interactive remove zlib-devel ncurses-devel libbz2-devel xz-devel libcurl-devel ;;
    esac
fi

purge_pkg() {
    case "${PACKAGE_MANAGER}" in
        apt) apt-get purge -y $1 ;;
        dnf|yum) ${PACKAGE_MANAGER} remove -y $1 ;;
        zypper) zypper --non-interactive remove $1 ;;
        pacman) pacman -Rns --noconfirm $1 ;;
    esac
}

if [ "${GCC_INSTALLED}" = "true" ]; then purge_pkg "gcc"; fi
if [ "${MAKE_INSTALLED}" = "true" ]; then purge_pkg "make"; fi
if [ "${CURL_INSTALLED}" = "true" ]; then purge_pkg "curl ca-certificates"; fi
if [ "${TAR_INSTALLED}" = "true" ]; then purge_pkg "tar"; fi
if [ "${BZIP2_INSTALLED}" = "true" ]; then purge_pkg "bzip2"; fi

if [ "${PACKAGE_MANAGER}" = "apt" ]; then
    apt-get autoremove -y && apt-get clean
fi

echo "BCFtools installation completed successfully!"
