!/bin/bash

# Run tests for ninja-build using this command
# #> devcontainer features test --features ninja-build --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Definition specific tests
check "version" ninja  --version

# Check paths in settings
check "which ninja" bash -c "which ninja | grep /usr/local/bin/ninja"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults