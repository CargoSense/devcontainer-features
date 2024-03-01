#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" actionlint --version
check "which actionlint" bash -c "which actionlint | grep /usr/local/bin/actionlint"

# Report result
reportResults
