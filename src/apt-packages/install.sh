#!/usr/bin/env sh

set -e

apt update

# shellcheck disable=SC2154
apt install --no-install-recommends --yes "${PACKAGES}"

rm -rf /var/lib/apt/lists /var/cache/apt/archives
