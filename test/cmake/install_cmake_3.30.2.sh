#!/bin/bash

# Run tests for cmake using this command
# #> devcontainer features test --features cmake --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature specific tests
check "cmake version 3.30.2 installed as default" bash -c "cmake --version | grep 3.30.2"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults