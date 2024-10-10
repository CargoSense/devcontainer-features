#!/usr/bin/env sh

set -e

GOOGLE_CLOUD_CLI_VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

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

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

apt-get update --yes

if [ "${GOOGLE_CLOUD_CLI_VERSION}" = "latest" ]; then
  apt-get install --no-install-recommends --yes postgresql-client
else
  apt-get install --no-install-recommends --yes google-cloud-cli=${GOOGLE_CLOUD_CLI_VERSION}
fi

if  [ -n "${curl_installed}" ]; then
  apt purge curl --autoremove --yes
fi

if [ -n "${gpg_installed}" ]; then
  apt purge gpg --autoremove --yes
fi
