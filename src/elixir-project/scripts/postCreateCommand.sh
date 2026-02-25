#!/usr/bin/env bash

set -e

FEATURE_SCRIPTS_PATH="/opt/cargosense/elixir-project"

rm -rf "${FEATURE_SCRIPTS_PATH}"
rmdir --ignore-fail-on-non-empty "$(dirname "${FEATURE_SCRIPTS_PATH}")"
