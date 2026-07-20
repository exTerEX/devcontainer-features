#!/usr/bin/env bash

source dev-container-features-test-lib

# Create a localized mock nextflow binary to satisfy nf-test's startup validation checks
MOCK_BIN_DIR=$(mktemp -d)
cat << 'EOF' > "${MOCK_BIN_DIR}/nextflow"
#!/usr/bin/env bash
echo "nextflow version 26.0.0"
EOF
chmod +x "${MOCK_BIN_DIR}/nextflow"
export PATH="${MOCK_BIN_DIR}:${PATH}"

# Run assertions
check "nf-test binary is in path" command -v nf-test
check "nf-test matches pinned version 0.9.2" bash -c "nf-test version | grep '0.9.2'"

reportResults