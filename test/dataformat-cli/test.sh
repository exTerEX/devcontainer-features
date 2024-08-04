#!/bin/bash

# Run tests for dataformat-cli using this command
# #> devcontainer features test --features dataformat-cli --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Check paths in settings
check "which NCBI dataformat" bash -c "which dataformat | grep /usr/local/bin/dataformat"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults