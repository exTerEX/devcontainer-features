#!/bin/bash

# Run tests for datasets-cli using this command
# #> devcontainer features test --features datasets-cli --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Definition specific tests
check "version" datasets  --version

# Check paths in settings
check "which NCBI datasets" bash -c "which datasets | grep /usr/local/bin/datasets"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults