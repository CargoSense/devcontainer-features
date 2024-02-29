#!/usr/bin/env bash

set -e

SHELLCHECK_VERSION="${VERSION:-"os-provided"}"
INSTALL_PATH="${INSTALLPATH:-"/usr/local/bin"}"

if [[ "$(id -u)" -ne 0 ]]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi


if [[ "${SHELLCHECK_VERSION}" = "os-provided" ]]; then
  apt update --yes
  apt install --no-install-recommends --yes shellcheck

  exit 0
fi

curl_installed=""

if ! type curl >/dev/null 2>&1; then
  apt update --yes
  apt install --no-install-recommends --yes curl ca-certificates

  curl_installed="true"
fi

if [[ "${SHELLCHECK_VERSION}" = "latest" ]]; then
  SHELLCHECK_VERSION="$(curl -s --head https://github.com/koalaman/shellcheck/releases/latest | sed -nr 's/location:.*\/v(.+)/\1/ip' | tr -d '\r')"
fi

machine="$(uname -m)"
case "${machine}" in
  aarch64) arch="aarch64" ;;
  arm*) arch="armv6" ;;
  x86_64) arch="x86_64" ;;
  *)
    echo "Could not determine arch from machine hardware name '${machine}'" >&2
    exit 1
  ;;
esac

# https://github.com/koalaman/shellcheck/releases/download/v0.9.0/shellcheck-v0.9.0.linux.aarch64.tar.xz
url="https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.${arch}.tar.xz"

curl -sSL "${url}" | tar --strip-components=1 -Jxvf - -C "${INSTALL_PATH}" "shellcheck-v${SHELLCHECK_VERSION}/shellcheck"

if [[ -n "${curl_installed}" ]]; then
  apt purge curl --autoremove --yes
fi
