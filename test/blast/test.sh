#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

# Array of all core binaries deployed by the BLAST+ feature
BLAST_BINARIES=(
    "blastn" "tblastx" "blastp" "blastx" "psiblast" "rpstblastn"
    "blastdb_aliastool" "blastdbcheck" "blastdbcmd" "blast_formatter"
    "blast_formatter_vdb" "blastn_vdb" "blast_vdb_cmd" "deltablast"
    "dustmasker" "makeblastdb" "makembindex" "makeprofiledb"
    "rpsblast" "tblastn" "tblastn_vdb" "windowmasker"
)

echo "Verifying BLAST+ binary installations in /usr/local/bin..."

for binary in "${BLAST_BINARIES[@]}"; do
    # 1. Verify file exists precisely in target destination and is executable
    check "Executable path: /usr/local/bin/${binary}" [ -x "/usr/local/bin/${binary}" ]
    
    # 2. Basic execution check for primary alignment tools (Quotes removed here)
    if [[ "$binary" =~ ^(blastn|blastp|blastx|tblastx|psiblast|rpstblastn)$ ]]; then
        check "${binary} execution check" ${binary} -version
    fi
done

reportResults