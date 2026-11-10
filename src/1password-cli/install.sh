#!/usr/bin/env sh

# Installs op from 1Password's apt repository, following
# https://developer.1password.com/docs/cli/get-started/ (Debian/Ubuntu),
# including the debsig policy that verifies the package signature.

set -e

if [ "$(id -u)" -ne 0 ]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

curl_installed=""
gpg_installed=""

if ! type curl >/dev/null 2>&1; then
  apt-get update --yes
  apt-get install --no-install-recommends --yes curl ca-certificates

  curl_installed="true"
fi

if ! type gpg >/dev/null 2>&1; then
  apt-get update --yes
  apt-get install --no-install-recommends --yes gpg

  gpg_installed="true"
fi

arch="$(dpkg --print-architecture)"
key_url="https://downloads.1password.com/linux/keys/1password.asc"

curl -fsSL "${key_url}" | gpg --dearmor --yes --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=${arch} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/${arch} stable main" \
  > /etc/apt/sources.list.d/1password.list

mkdir -p /etc/debsig/policies/AC2D62742012EA22 /usr/share/debsig/keyrings/AC2D62742012EA22
curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol \
  > /etc/debsig/policies/AC2D62742012EA22/1password.pol
curl -fsSL "${key_url}" | gpg --dearmor --yes --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

apt-get update --yes
apt-get install --no-install-recommends --yes 1password-cli

if [ -n "${curl_installed}" ]; then
  apt purge curl --autoremove --yes
fi

if [ -n "${gpg_installed}" ]; then
  apt purge gpg --autoremove --yes
fi

rm -rf /var/lib/apt/lists/*

op --version
