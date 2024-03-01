#!/usr/bin/env bash

set -e

ACTIONLINT_VERSION="${VERSION:-"latest"}"
ACTIONLINT_INSTALL_PATH="${INSTALLPATH:-"/usr/local/bin"}"
ACTIONLINT_REPOSITORY="https://github.com/rhysd/actionlint"

DIRNAME=$(dirname -- "${0}")
SCRIPT_DIR=$(cd -- "${DIRNAME}" > /dev/null 2>&1 && pwd)

# shellcheck source=./src/actionlint/shared.lib.sh
. "${SCRIPT_DIR}"/shared.lib.sh

if type actionlint > /dev/null 2>&1; then
  echo "Detected existing system install: $(actionlint --version)"
  clean_up
  exit 0
fi

check_packages curl ca-certificates

if [[ "${ACTIONLINT_VERSION}" = "latest" ]]; then
  ACTIONLINT_VERSION=$(latest_release_version "${ACTIONLINT_REPOSITORY}")
fi

machine="$(uname -m)"
case "${machine}" in
  x86_64)
    arch="amd64"
    ;;
  i?86)
    arch="386"
    ;;
  aarch64|arm64)
    arch="arm64"
    ;;
  arm*)
    arch="armv6"
    ;;
  *)
    echo "Could not determine arch from machine hardware name '${machine}'" >&2
    exit 1
    ;;
esac

# https://github.com/rhysd/actionlint/releases/download/v1.0.0/actionlint_1.0.0_linux_386.tar.gz
url="${ACTIONLINT_REPOSITORY}/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_${arch}.tar.gz"

echo "Downloading ${url} with curl..."

curl -L "${url}" | tar xvz -C "${ACTIONLINT_INSTALL_PATH}" actionlint

echo "Done!"
