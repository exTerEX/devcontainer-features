#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

TARGET_VERSION="1.24"

echo "Verifying pinned installation of HTSlib version ${TARGET_VERSION}..."

# Grepping directly for the version number prevents the parenthesis from breaking the match
check "tabix version matches ${TARGET_VERSION}" bash -c "/usr/local/bin/tabix --version 2>&1 | grep -q '${TARGET_VERSION}'"

reportResults
