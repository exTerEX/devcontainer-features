#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'datasets-cli'"

# Move into temporary files directory
cd /tmp

# Fetch binaries
curl -JLO https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets

# Install datasets-cli
mv -v datasets /usr/local/bin
chmod +x /usr/local/bin/datasets
