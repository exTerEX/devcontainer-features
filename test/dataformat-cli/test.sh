#!/usr/bin/env bash
set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Assert binary presence and verify baseline executable behavior
check "NCBI dataformat is in path" command -v dataformat
check "NCBI dataformat execution check" dataformat version

# Report result
reportResults