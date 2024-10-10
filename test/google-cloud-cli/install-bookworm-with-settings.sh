#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "version" bash -c "gcloud --version | grep 371.0.0-0"
check "which gcloud" bash -c "which gcloud | grep /usr/bin/gcloud"

# Report result
reportResults
