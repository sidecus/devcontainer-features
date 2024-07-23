#!/bin/bash

# This test file will be executed against one of the scenarios devcontainer.json test that
# includes the 'magicmirror' feature with "huggingface_mirror" option.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "test HF mirror" bash -c "test \"${HF_ENDPOINT}\" = \"https://dummy-hf-mirror.com\""

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
