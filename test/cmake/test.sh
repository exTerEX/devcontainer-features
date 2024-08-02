#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'CMake' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "color": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in the
# Feature's 'devcontainer-feature.json'.
# For the 'color' feature, that means the default favorite color is 'red'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
#    devcontainer features test    \ 
#               --features color   \
#               --remote-user root \
#               --skip-scenarios   \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#               /path/to/this/repo

set -e

# Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Definition specific tests
check "version" cmake  --version

# Check that tools can execute
check "cmake" cmake  --version
check "ccmake" ccmake  --version
check "cpack" cpack  --version
check "ctest" ctest  --version

# Check paths in settings
check "which cmake" bash -c "which cmake | grep /usr/local/bin/cmake"
check "which ccmake" bash -c "which ccmake | grep /usr/local/bin/ccmake"
check "which cpack" bash -c "which cpack | grep /usr/local/bin/cpack"
check "which ctest" bash -c "which ctest | grep /usr/local/bin/ctest"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults