#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

SAMTOOLS_BINARIES=(
    "samtools"
    "plot-bamstats"
    "ace2sam"
    "maq2sam-long"
    "maq2sam-short"
    "wgsim"
)

echo "Verifying SAMtools binary installations in /usr/local/bin..."

for binary in "${SAMTOOLS_BINARIES[@]}"; do
    # 1. Verify file exists in target destination and is executable
    check "Executable path: /usr/local/bin/${binary}" [ -x "/usr/local/bin/${binary}" ]

    # 2. Execution check for the primary engine
    if [ "$binary" = "samtools" ]; then
        check "${binary} execution check" samtools --version
    fi
done

reportResults
