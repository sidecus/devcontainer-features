#!/bin/bash

# This test file will be executed against one of the scenarios devcontainer.json test that
# includes the 'magicmirror' feature with "huggingface_mirror" option.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
# TODO[sidecus]: Workaround for the test case since /env/environment is not loaded in test case scenarios
# Should consider using containerEnv if this is solved: https://github.com/devcontainers/spec/issues/164
# check "test HF mirror" bash -c "test \"${HF_ENDPOINT}\" = \"https://dummy-hf-mirror.com\""
check "test HF mirror" bash -c "cat /etc/environment | grep 'https://dummy-hf-mirror.com'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
