#!/usr/bin/env sh

set -e

NODE_VERSION="${VERSION:-"24"}"

curl_installed=""

if ! type curl >/dev/null 2>&1; then
  apt update --yes
  apt install --no-install-recommends --yes curl ca-certificates

  curl_installed="true"
fi

curl -fsSL https://deb.nodesource.com/setup_"${NODE_VERSION}".x | bash -

apt update --yes
apt install --no-install-recommends --yes nodejs

if [ -n "${curl_installed}" ]; then
  apt purge curl --autoremove --yes
fi
