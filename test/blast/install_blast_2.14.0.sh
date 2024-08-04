#!/bin/bash

# Run tests for cmake using this command
# #> devcontainer features test --features blast --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature specific tests
check "blastn version 2.14.0 installed as default" bash -c "blastn -version | grep 2.14.0"
check "tblastx version 2.14.0 installed as default" bash -c "tblastx -version | grep 2.14.0"
check "blastp version 2.14.0 installed as default" bash -c "blastp -version | grep 2.14.0"
check "blastx version 2.14.0 installed as default" bash -c "blastx -version | grep 2.14.0"
check "psiblast version 2.14.0 installed as default" bash -c "psiblast -version | grep 2.14.0"
check "rpstblastn version 2.14.0 installed as default" bash -c "rpstblastn -version | grep 2.14.0"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults