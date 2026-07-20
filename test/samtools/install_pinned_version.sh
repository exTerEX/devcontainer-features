#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

TARGET_VERSION="1.24"

echo "Verifying pinned installation of SAMtools version ${TARGET_VERSION}..."

# Use the absolute path to ensure the binary is found in non-interactive Debian environments
check "samtools version matches ${TARGET_VERSION}" bash -c "/usr/local/bin/samtools --version | grep -q 'samtools ${TARGET_VERSION}'"

reportResults
