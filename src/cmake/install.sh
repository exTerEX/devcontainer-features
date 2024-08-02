#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'CMake'"

VERSION="${VERSION:-latest}"

# Fetch the latest release
if [ ${VERSION} = "latest" ]; then
    VERSION=$(curl --silent -I https://github.com/Kitware/CMake/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')
fi

# Define internal variables
SOURCE=v${VERSION#v}.tar.gz
SOURCEDIR=cmake-${VERSION#v}

# Move into temporary files directory
cd /tmp

# Check which architecture
ARCHITECTURE=linux-$(uname -m)

# TODO: Check if architecture is supported

# Fetch binaries
wget -O ${SOURCE} - https://github.com/Kitware/CMake/releases/download/v${VERSION#v}/${SOURCEDIR}-${ARCHITECTURE}.tar.gz

# Fetch public PGP signature
wget -O ${SOURCE}-SHA-256.asc - https://github.com/Kitware/CMake/releases/download/v${VERSION#v}/${SOURCEDIR}-SHA-256.txt.asc

# TODO: Add signature check

# Unzip binaries
tar -xzf ${SOURCE} && rm ${SOURCE} && cd ${SOURCEDIR}-${ARCHITECTURE}

# Not necessary to include cmake-gui
rm bin/cmake-gui
rm man/man1/cmake-gui.1
rm -rf share/applications

# Install CMake
sudo mv -v bin/* /usr/local/bin
sudo mkdir /usr/local/share/man/cmake && sudo mv -v man/* /usr/local/share/man/cmake
sudo mv -v share/* /usr/local/share/

# Remove temporary files
cd /tmp && rm -rf ${SOURCEDIR}-${ARCHITECTURE}
