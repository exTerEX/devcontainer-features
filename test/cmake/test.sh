#!/bin/bash

# Run tests for cmake using this command
# #> devcontainer features test --features cmake --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature specific tests
check "version" cmake  --version

# Definition specific tests
check "cmake" cmake  --version
check "ccmake" ccmake  --version
check "cpack" cpack  --version
check "ctest" ctest  --version

# File position validation
check "which cmake" bash -c "which cmake | grep /usr/local/bin/cmake"
check "which ccmake" bash -c "which ccmake | grep /usr/local/bin/ccmake"
check "which cpack" bash -c "which cpack | grep /usr/local/bin/cpack"
check "which ctest" bash -c "which ctest | grep /usr/local/bin/ctest"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults