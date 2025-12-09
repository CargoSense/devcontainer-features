#!/usr/bin/env sh

set -e

POSTGRESQL_VERSION="${VERSION:-"os-provided"}"
VERSION_CODENAME="$(sed -nr 's/VERSION_CODENAME=(.+)/\1/p' /etc/os-release)"

if [ "$(id -u)" -ne 0 ]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

if [ "${POSTGRESQL_VERSION}" = "os-provided" ]; then
  apt update --yes
  apt install --no-install-recommends --yes libpq-dev postgresql-client

  exit 0
fi

curl_installed=""
gpg_installed=""

if ! type curl >/dev/null 2>&1; then
  apt update --yes
  apt install --no-install-recommends --yes curl ca-certificates

  curl_installed="true"
fi

if ! type gpg >/dev/null 2>&1; then
  apt update --yes
  apt install --no-install-recommends --yes gpg

  gpg_installed="true"
fi

install -d /usr/share/postgresql-common/pgdg
curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list

apt update --yes
apt install --no-install-recommends --yes libpq-dev postgresql-client-"${POSTGRESQL_VERSION}"

if [ -n "${curl_installed}" ]; then
  apt purge curl --autoremove --yes
fi

if [ -n "${gpg_installed}" ]; then
  apt purge gpg --autoremove --yes
fi
