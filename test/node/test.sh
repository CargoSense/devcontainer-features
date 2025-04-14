#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" node --version
check "which node" bash -c "which node | grep /usr/bin/node"

# Report result
reportResults
