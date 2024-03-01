#!/usr/bin/env bash

if [[ "$(id -u)" -ne 0 ]]; then
  printf 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
# shellcheck disable=SC2154
if [[ "${ID}" = "debian" ]] || [[ "${ID_LIKE}" = "debian" ]]; then
  ADJUSTED_ID="debian"
elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
  ADJUSTED_ID="rhel"
  # shellcheck disable=SC2034
  VERSION_CODENAME="${ID}${VERSION_ID}"
else
  echo "Linux distro ${ID} not supported."
  exit 1
fi

if type apt-get > /dev/null 2>&1; then
  INSTALL_CMD="apt-get"
elif type microdnf > /dev/null 2>&1; then
  INSTALL_CMD="microdnf"
elif type dnf > /dev/null 2>&1; then
  INSTALL_CMD="dnf"
elif type yum > /dev/null 2>&1; then
  INSTALL_CMD="yum"
else
  echo "Unable to find a supported package manager."
  exit 1
fi

clean_up() {
  case ${ADJUSTED_ID} in
    debian)
      rm -rf /var/lib/apt/lists/*
      ;;
    rhel)
      rm -rf /var/cache/dnf/*
      rm -rf /var/cache/yum/*
      ;;
    *)
      ;;
  esac
}

pkg_mgr_update() {
  if [[ "${INSTALL_CMD}" = "apt-get" ]]; then
    if [[ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]]; then
      echo "Running apt-get update..."
      ${INSTALL_CMD} update -y
    fi
  elif [[ ${INSTALL_CMD} = "dnf" ]] || [[ ${INSTALL_CMD} = "yum" ]]; then
    if [[ "$(find /var/cache/"${INSTALL_CMD}"/* | wc -l)" = "0" ]]; then
      echo "Running ${INSTALL_CMD} check-update..."
      ${INSTALL_CMD} check-update
    fi
  fi
}

check_packages() {
  if [[ "${INSTALL_CMD}" = "apt-get" ]]; then
    if ! dpkg -s "$@" > /dev/null 2>&1; then
      pkg_mgr_update
      ${INSTALL_CMD} -y install --no-install-recommends "$@"
    fi
  elif [[ "${INSTALL_CMD}" = "dnf" ]] || [[ "${INSTALL_CMD}" = "yum" ]]; then
    _num_pkgs=$(echo "$@" | tr ' ' \\012 | wc -l)
    _num_installed=$(${INSTALL_CMD} -C list installed "$@" | sed '1,/^Installed/d' | wc -l)
    if [[ "${_num_pkgs}" != "${_num_installed}" ]]; then
      pkg_mgr_update
      ${INSTALL_CMD} -y install "$@"
    fi
  elif [[ "${INSTALL_CMD}" = "microdnf" ]]; then
    ${INSTALL_CMD} -y install \
      --refresh \
      --best \
      --nodocs \
      --noplugins \
      --setopt=install_weak_deps=0 \
    "$@"
  else
    echo "Linux distro ${ID} not supported."
    exit 1
  fi
}

latest_release_version() {
  if [[ $# -eq 0 ]]; then
    echo "No repository URL provided."
    exit 1
  fi

  curl -s --head "${1}"/releases/latest | sed -nr 's/location:.*\/v(.+)/\1/ip' | tr -d '\r'
}

export DEBIAN_FRONTEND="noninteractive"
