#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

TARGET_VERSION="1.24"

echo "Verifying pinned installation of BCFtools version ${TARGET_VERSION}..."

# Use the absolute path to ensure the binary is found in non-interactive Debian environments
check "bcftools version matches ${TARGET_VERSION}" bash -c "/usr/local/bin/bcftools --version | grep -q 'bcftools ${TARGET_VERSION}'"

reportResults
