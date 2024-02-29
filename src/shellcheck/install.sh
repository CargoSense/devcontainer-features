#!/usr/bin/env sh

set -e

if [ "$(id -u)" -ne 0 ]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

apt update --yes
apt install --no-install-recommends --yes shellcheck
