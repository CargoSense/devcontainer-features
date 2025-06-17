#!/usr/bin/env bash

set -e

read -ar packages <<< "${PACKAGES:-""}"

apt update
apt install --no-install-recommends --yes "${packages[@]}"

rm -rf /var/lib/apt/lists /var/cache/apt/archives
