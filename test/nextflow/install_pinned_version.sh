#!/usr/bin/env bash
set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Assert pathing layout compliance
check "Nextflow binary is in path" command -v nextflow

# Assert that the pinned version matches what was requested in scenarios.json
check "Nextflow matches pinned version 24.04.4" bash -c "nextflow -version | grep '24.04.4'"

# Report result
reportResults