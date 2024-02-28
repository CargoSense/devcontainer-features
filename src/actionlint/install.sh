#!/usr/bin/env sh

set -e

ACTIONLINT_VERSION="${VERSION:-"latest"}"
INSTALL_PATH="${INSTALLPATH:-"/usr/local/bin"}"

if [ "$(id -u)" -ne 0 ]; then
  echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

curl_installed=""

if ! [ type curl >/dev/null 2>&1 ]; then
  apt update --yes
  apt install --no-install-recommends --yes curl ca-certificates

  curl_installed="true"
fi

curl -sSL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash | \
  /bin/bash -s -- "${ACTIONLINT_VERSION}" "${INSTALL_PATH}"

if ! [ -z $curl_installed ]; then
  apt purge curl --autoremove --yes
fi
