#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" bash -c "actionlint --version | grep 1.6.20"
check "which actionlint" bash -c "which actionlint | grep /usr/bin/actionlint"

# Report result
reportResults
