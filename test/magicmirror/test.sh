#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'magicmirror' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "magicmirror": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in 
# the Feature's 'devcontainer-feature.json'.
# For the 'magicmirror' feature, that means the default values are as below:
# UBUNTU_MIRROR=""
# PYPI_MIRROR=""
# APK_MIRROR=""

#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features hello   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /path/to/this/repo

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]
check "test no ubuntu mirror" bash -c "! (test -e /etc/apt/sources.list.bak) && ! (cat /etc/apt/sources.list | grep 'mirrors.bfsu.edu.cn')"
check "test no pypi mirror" bash -c "! (test -e /etc/pip.conf) || ! (cat /etc/pip.conf | grep 'mirrors.bfsu.edu.cn')"
check "test no apk mirror" bash -c "! (test -e /etc/apk/repositories) || ! (cat /etc/apk/repositories | grep 'mirrors.tuna.tsinghua.edu.cn')"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults