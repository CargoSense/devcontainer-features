#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "environment" bash -c "env | grep ERL_AFLAGS"
check "gitignore" grep -xF .bash_history .gitignore

# Report result
reportResults
