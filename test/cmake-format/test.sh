#!/bin/bash

# Run tests for cmake-format using this command
# #> devcontainer features test --features cmake-format --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Check paths in settings
check "which cmake-format" bash -c "which cmake-format | grep /usr/bin/cmake-format"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults