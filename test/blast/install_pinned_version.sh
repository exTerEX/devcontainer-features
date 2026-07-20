#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

TARGET_VERSION="2.16.0"
CORE_TOOLS=("blastn" "tblastx" "blastp" "blastx" "psiblast" "rpstblastn")

echo "Verifying pinned installation of BLAST+ version ${TARGET_VERSION}..."

for tool in "${CORE_TOOLS[@]}"; do
    check "${tool} version matches ${TARGET_VERSION}" bash -c "${tool} -version | grep -q '${TARGET_VERSION}'"
done

reportResults