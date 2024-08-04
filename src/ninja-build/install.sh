#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'Ninja'"

VERSION="${VERSION:-latest}"

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
wget -O ${SOURCE} - https://github.com/ninja-build/ninja/releases/download/v${VERSION#v}/ninja-linux.zip

# Unzip binaries
unzip ${SOURCE} && rm ${SOURCE}

# Install CMake
sudo mv -v ninja /usr/local/bin
