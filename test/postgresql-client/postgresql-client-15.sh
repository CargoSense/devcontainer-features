#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" bash -c "psql --version | grep -E 'psql \(PostgreSQL\) 15\..+'"

# Report result
reportResults
