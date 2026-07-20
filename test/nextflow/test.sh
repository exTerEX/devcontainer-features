#!/usr/bin/env bash
set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Assert pathing layout compliance and proper application initialization hooks
check "Nextflow binary is in path" command -v nextflow
check "Nextflow execution and environment self-test" nextflow info

# Report result
reportResults