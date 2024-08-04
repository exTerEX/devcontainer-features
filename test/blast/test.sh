#!/bin/bash

# Run tests for cmake using this command
# #> devcontainer features test --features blast --base-image mcr.microsoft.com/devcontainers/base:debian

set -e

# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature specific tests
check "blastn version" blastn -version
check "tblastx version" tblastx -version
check "blastp version" blastp -version
check "blastx version" blastx -version
check "psiblast version" psiblast -version
check "rpstblastn version" rpstblastn -version

# File position validation
check "which blastdb_aliastool" bash -c "which blastdb_aliastool | grep /usr/local/bin/blastdb_aliastool"
check "which blastdbcheck" bash -c "which blastdbcheck | grep /usr/local/bin/blastdbcheck"
check "which blastdbcmd" bash -c "which blastdbcmd | grep /usr/local/bin/blastdbcmd"
check "which blast_formatter" bash -c "which blast_formatter | grep /usr/local/bin/blast_formatter"
check "which blast_formatter_vdb" bash -c "which blast_formatter_vdb | grep /usr/local/bin/blast_formatter_vdb"
check "which blastn" bash -c "which blastn | grep /usr/local/bin/blastn"
check "which blastn_vdb" bash -c "which blastn_vdb | grep /usr/local/bin/blastn_vdb"
check "which blast_vdb_cmd" bash -c "which blast_vdb_cmd | grep /usr/local/bin/blast_vdb_cmd"
check "which cleanup-blastdb-volumes.py" bash -c "which cleanup-blastdb-volumes.py | grep /usr/local/bin/cleanup-blastdb-volumes.py"
check "which deltablast" bash -c "which deltablast | grep /usr/local/bin/deltablast"
check "which dustmasker" bash -c "which dustmasker | grep /usr/local/bin/dustmasker"
check "which legacy_blast.pl" bash -c "which legacy_blast.pl | grep /usr/local/bin/legacy_blast.pl"
check "which makeblastdb" bash -c "which makeblastdb | grep /usr/local/bin/makeblastdb"
check "which makembindex" bash -c "which makembindex | grep /usr/local/bin/makembindex"
check "which makeprofiledb" bash -c "which makeprofiledb | grep /usr/local/bin/makeprofiledb"
check "which psiblast" bash -c "which psiblast | grep /usr/local/bin/psiblast"
check "which rpsblast" bash -c "which rpsblast | grep /usr/local/bin/rpsblast"
check "which tblastn" bash -c "which tblastn | grep /usr/local/bin/tblastn"
check "which tblastn_vdb" bash -c "which tblastn_vdb | grep /usr/local/bin/tblastn_vdb"
check "which tblastx" bash -c "which tblastx | grep /usr/local/bin/tblastx"
check "which update_blastdb.pl" bash -c "which update_blastdb.pl | grep /usr/local/bin/update_blastdb.pl"
check "which windowmasker" bash -c "which windowmasker | grep /usr/local/bin/windowmasker"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults