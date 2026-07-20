#!/usr/bin/env bash
set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Assert binary presence and verify baseline executable behavior
check "NCBI datasets is in path" command -v datasets
check "NCBI datasets execution check" datasets --version

# Report result
reportResults