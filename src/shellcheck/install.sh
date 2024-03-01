#!/usr/bin/env bash

set -e

SHELLCHECK_VERSION="${VERSION:-"os-provided"}"
SHELLCHECK_INSTALL_PATH="${INSTALLPATH:-"/usr/local/bin"}"
SHELLCHECK_REPOSITORY="https://github.com/koalaman/shellcheck"

DIRNAME=$(dirname -- "${0}")
SCRIPT_DIR=$(cd -- "${DIRNAME}" > /dev/null 2>&1 && pwd)

# shellcheck source=./src/shellcheck/shared.lib.sh
. "${SCRIPT_DIR}"/shared.lib.sh

if type shellcheck > /dev/null 2>&1; then
  echo "Detected existing system install: $(shellcheck --version)"
  clean_up
  exit 0
fi

check_packages curl ca-certificates xz-utils

if [[ "${SHELLCHECK_VERSION}" = "os-provided" ]]; then
  check_packages shellcheck
  exit 0
fi

if [[ "${SHELLCHECK_VERSION}" = "latest" ]]; then
  SHELLCHECK_VERSION=$(set -e; latest_release_version "${SHELLCHECK_REPOSITORY}")
fi

machine="$(uname -m)"
case "${machine}" in
  aarch64)
    arch="aarch64"
    ;;
  arm*)
    arch="armv6"
    ;;
  x86_64)
    arch="x86_64"
    ;;
  *)
    echo "Could not determine arch from machine hardware name '${machine}'" >&2
    exit 1
    ;;
esac

# https://github.com/koalaman/shellcheck/releases/download/v0.9.0/shellcheck-v0.9.0.linux.aarch64.tar.xz
url="${SHELLCHECK_REPOSITORY}/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.${arch}.tar.xz"

echo "Downloading ${url} with curl..."

# curl -L "${url}" | tar xvf -C "${SHELLCHECK_INSTALL_PATH}" shellcheck
curl -L "${url}" | tar --strip-components=1 -Jxvf - -C "${SHELLCHECK_INSTALL_PATH}" "shellcheck-v${SHELLCHECK_VERSION}/shellcheck"

echo "Done!"
