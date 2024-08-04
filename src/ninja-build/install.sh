#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'Ninja'"

VERSION="${VERSION:-latest}"

# Install curl if not in system
if ! which curl > /dev/null; then
    CURLINSTALLED="true"
    apt update && apt -y install --no-install-recommends curl ca-certificates
fi

# Fetch the latest release
if [ ${VERSION} = "latest" ]; then
    VERSION=$(curl --silent -I https://github.com/ninja-build/ninja/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
fi

# Define internal variables
SOURCE=ninja-v${VERSION#v}.zip

# Move into temporary files directory
cd /tmp

# TODO: Check if architecture is supported
SOURCEDIR=ninja-linux.zip # ninja-linux-aarch64.zip if ARM64

# Fetch binaries
curl -JLo ${SOURCE} https://github.com/ninja-build/ninja/releases/download/v${VERSION#v}/ninja-linux.zip

# Install unzip if not in system
if ! which unzip > /dev/null; then
    UNZIPINSTALLED="true"
    apt update && apt install -y --no-install-recommends unzip
fi

# Unzip binaries
unzip ${SOURCE} && rm ${SOURCE}

# Install ninja-build
mv -v ninja /usr/local/bin

# Remove curl and dependencies if installed by script
if [ ! -Z ${CURLINSTALLED+x} ]; then
    apt remove -y curl ca-certificates && apt autoremove -y
fi

# Remove unzip and dependencies if installed by script
if [ ! -Z ${UNZIPINSTALLED+x} ]; then
    apt remove -y unzip && apt autoremove -y
fi