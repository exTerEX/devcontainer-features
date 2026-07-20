#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

HTSLIB_BINARIES=(
    "bgzip"
    "tabix"
    "htsfile"
)

echo "Verifying HTSlib binary installations in /usr/local/bin..."

for binary in "${HTSLIB_BINARIES[@]}"; do
    # 1. Verify file exists in target destination and is executable
    check "Executable path: /usr/local/bin/${binary}" [ -x "/usr/local/bin/${binary}" ]

    # 2. Execution check for the primary utility engine
    if [ "$binary" = "tabix" ]; then
        check "${binary} execution check" tabix --version
    fi
done

reportResults
