#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" op --version
check "which op" bash -c "which op | grep /usr/bin/op"

# Report result
reportResults
