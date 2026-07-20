#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

# Assert pathing layout compliance and execution
check "nf-core binary is in path" command -v nf-core
check "nf-core execution check" nf-core --version

reportResults