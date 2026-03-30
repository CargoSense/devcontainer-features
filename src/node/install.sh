#!/usr/bin/env bash

set -e

NODE_VERSION="${VERSION:-"latest"}"

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

# Determine the appropriate non-root user.
if [[ "${USERNAME}" = "automatic" ]]; then
  USERNAME=""
  POSSIBLE_USERS=("vscode" "node" "$(getent passwd 1000 | cut -d: -f1)")

  for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
    if id -u "${CURRENT_USER}" >/dev/null 2>&1; then
      USERNAME="${CURRENT_USER}"
      break
    fi
  done

  if [[ "${USERNAME}" = "" ]]; then
    USERNAME="root"
  fi
elif ! id -u "${USERNAME}" >/dev/null 2>&1; then
  USERNAME="root"
fi

curl_installed=""
xz_installed=""

if ! type curl >/dev/null 2>&1; then
  apt update --yes
  apt install --yes curl

  curl_installed="true"
fi

if ! type xz >/dev/null 2>&1; then
  apt update --yes
  apt install --yes xz-utils

  xz_installed="true"
fi

# Normalize architecture
arch="$(dpkg --print-architecture)"
if [[ "${arch}" = "amd64" ]] || [[ "${arch}" = "x86_64" ]] || [[ "${arch}" = "i386" ]]; then
  arch="x64"
fi

# Normalize Node.js version string
if [[ "${NODE_VERSION}" != "latest" ]] && [[ "${NODE_VERSION}" != "v"* ]]; then
  NODE_VERSION="v${NODE_VERSION}"
fi

# Configure "node" group
if ! grep -e "^node:" /etc/group >/dev/null 2>&1; then
  groupadd --system node
fi
usermod --append --groups node "${USERNAME}"

# Install Node.js
umask 0002
mkdir -p "${NODE_HOME:?}"
curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-${arch}.tar.xz" | tar xf - -C "${NODE_HOME}" -J --strip-components 1

chown -R "${USERNAME}:node" "${NODE_HOME}"
chmod g+rws "${NODE_HOME}"

# Configure shell
rc_snippet="export NODE_VERSION=\"$(node -v | cut -c2-)\""

if [[ -f /etc/bash.bashrc ]] && ! grep -q "${rc_snippet}" /etc/bash.bashrc; then
  echo "${rc_snippet}" >>/etc/bash.bashrc
fi

if [[ -f /etc/zsh/zshrc ]] && ! grep -q "${rc_snippet}" /etc/zsh/zshrc; then
  echo "${rc_snippet}" >>/etc/zsh/zshrc
fi

# Cleanup
if [[ -n "${curl_installed}" ]]; then
  apt purge curl --autoremove --yes
  rm -rf /var/lib/apt/lists/*
fi

if [[ -n "${xz_installed}" ]]; then
  apt purge xz-utils --autoremove --yes
  rm -rf /var/lib/apt/lists/*
fi
