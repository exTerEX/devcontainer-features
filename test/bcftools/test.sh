#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

BCFTOOLS_BINARIES=(
    "bcftools"
    "plot-vcfstats"
)

echo "Verifying BCFtools binary installations in /usr/local/bin..."

for binary in "${BCFTOOLS_BINARIES[@]}"; do
    # 1. Verify file exists in target destination and is executable
    check "Executable path: /usr/local/bin/${binary}" [ -x "/usr/local/bin/${binary}" ]

    # 2. Execution check for the primary engine
    if [ "$binary" = "bcftools" ]; then
        check "${binary} execution check" bcftools --version
    fi
done

reportResults
