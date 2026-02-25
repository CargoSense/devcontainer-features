#!/usr/bin/env bash

set -e

FEATURE_SCRIPTS_PATH="/opt/cargosense/elixir-project"

mkdir -p "${FEATURE_SCRIPTS_PATH}"

cp "${PWD}"/scripts/*.sh "${FEATURE_SCRIPTS_PATH}"
chmod +x "${FEATURE_SCRIPTS_PATH}"/*.sh
