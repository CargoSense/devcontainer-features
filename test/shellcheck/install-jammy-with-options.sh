#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" bash -c "shellcheck --version | grep 0.8.0"
check "which shellcheck" bash -c "which shellcheck | grep /usr/bin/shellcheck"

# Report result
reportResults
