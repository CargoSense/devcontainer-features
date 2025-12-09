#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" psql --version
check "which psql" bash -c "which psql | grep /usr/bin/psql"

# Report result
reportResults
