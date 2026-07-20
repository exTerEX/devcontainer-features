#!/usr/bin/env bash

source dev-container-features-test-lib

# Assert that the pinned version matches what was requested
check "nf-core matches pinned version 3.5.2" bash -c "nf-core --version 2>&1 | grep '3.5.2'"

reportResults