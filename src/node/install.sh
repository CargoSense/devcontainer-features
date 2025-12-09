#!/usr/bin/env bash

set -e

NODE_VERSION="${VERSION:-"automatic"}"
NODE_MAJOR_VERSION="24"

pkg="nodejs"

if [[ "${NODE_VERSION}" != "automatic" ]]; then
  NODE_MAJOR_VERSION="$(echo "${NODE_VERSION}" | cut -d. -f1)"
  pkg="${pkg}=${NODE_VERSION}-1nodesource1"
fi

curl_installed=""
gpg_installed=""

if ! type curl >/dev/null 2>&1; then
  apt update --yes
  apt install --yes curl

  curl_installed="true"
fi

if ! type gpg >/dev/null 2>&1; then
  apt update --yes
  apt install --yes gnupg

  gpg_installed="true"
fi

apt_sources_snippet="$(cat << EOF
Types: deb
URIs: https://deb.nodesource.com/node_${NODE_MAJOR_VERSION}.x
Suites: nodistro
Components: main
Signed-By: /etc/apt/keyrings/nodesource.gpg
EOF
)"

install -dm 755 /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "${apt_sources_snippet}" | tee /etc/apt/sources.list.d/nodesource.sources

if [[ -n "${curl_installed}" ]]; then
  apt purge curl --autoremove --yes
  rm -rf /var/lib/apt/lists/*
fi

if [[ -n "${gpg_installed}" ]]; then
  apt purge gnupg --autoremove --yes
  rm -rf /var/lib/apt/lists/*
fi

apt update --yes
apt install --yes "${pkg}"
rm -rf /var/lib/apt/lists/*

node_rc_snippet="$(cat << EOF
export NODE_VERSION="$(node -v | cut -c2-)"
EOF
)"

if [[ "$(cat /etc/bash.bashrc)" != *"${node_rc_snippet}"* ]]; then
  echo "${node_rc_snippet}" >> /etc/bash.bashrc
fi

if [[ -f "/etc/zsh/zshrc" ]] && [[ "$(cat /etc/zsh/zshrc)" != *"${node_rc_snippet}"* ]]; then
  echo "${node_rc_snippet}" >> /etc/zsh/zshrc
fi
