!/bin/bash

# Run tests for ninja-build using this command
# #> devcontainer features test --features ninja-build --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature specific tests
check "ninja version 1.10.1 installed as default" bash -c "ninja --version | grep 1.10.1"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults