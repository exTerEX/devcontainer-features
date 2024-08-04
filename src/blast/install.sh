#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'BLAST+'"

VERSION="${VERSION:-latest}"

# Install curl if not in system
if ! which curl > /dev/null; then
    CURLINSTALLED="true"
    apt update && apt -y install --no-install-recommends curl ca-certificates
fi

# Move into temporary files directory
cd /tmp

# Check which architecture
ARCHITECTURE="x64" # TODO: Has to be either "x64" or "aarch64"

# Fetch the latest release, then binaries
# TODO: Confirm checksum from provided .md5 files
if [ ${VERSION} = "latest" ]; then
    VERSION=$(curl --silent https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION)

    curl -JLO https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-${VERSION}+-${ARCHITECTURE}-linux.tar.gz
else
    curl -JLO https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${VERSION}/ncbi-blast-${VERSION}+-${ARCHITECTURE}-linux.tar.gz
fi

SOURCE=ncbi-blast-${VERSION}+

# Unzip binaries
tar -xzf ${SOURCE}-${ARCHITECTURE}-linux.tar.gz && rm ${SOURCE}-${ARCHITECTURE}-linux.tar.gz && cd ${SOURCE}

# Install BLAST+
mv -v bin/* /usr/local/bin

# Remove curl and dependencies if installed by script
if [ ! -Z ${CURLINSTALLED+x} ]; then
    apt remove -y curl ca-certificates && apt autoremove -y
fi

# Remove unzip and dependencies if installed by script
if [ ! -Z ${UNZIPINSTALLED+x} ]; then
    apt remove -y unzip && apt autoremove -y
fi

# Remove temporary files
cd /tmp && rm -rf ${SOURCE}