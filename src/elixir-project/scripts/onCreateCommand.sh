#!/usr/bin/env bash

set -e

# Set permissions on volume mounts
sudo chown -R "${USER}":"${USER}" "${CONTAINER_WORKSPACE_FOLDER:?}"/{_build,deps,.expert}

# Create user Bash configuration directory
BASHRC_DIR="${HOME}/.bashrc.d"

mkdir -p "${BASHRC_DIR}"
chmod 700 "${BASHRC_DIR}"

# Configure environment variables that rely on `CONTAINER_WORKSPACE_FOLDER`
cat << EOF > "${BASHRC_DIR}/elixir-project.bashrc"
export HISTFILE="${CONTAINER_WORKSPACE_FOLDER}/.bash_history"
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\\"${CONTAINER_WORKSPACE_FOLDER}/.iex_history\\"'"
EOF

chmod +x "${BASHRC_DIR}/elixir-project.bashrc"

BASHRC_FILE="${HOME}/.bashrc"
BASHRC_LINE="for file in \"\${HOME}\"/.bashrc.d/*.bashrc; do source \"\${file}\"; done"

grep -qxF "${BASHRC_LINE}" "${BASHRC_FILE}" || echo "${BASHRC_LINE}" >> "${BASHRC_FILE}"

# Configure workspace `.gitignore`
GITIGNORE_FILE="${CONTAINER_WORKSPACE_FOLDER}/.gitignore"
GITIGNORE_LINES=(.bash_history /_build /.expert /.iex_history /deps)

touch "${GITIGNORE_FILE}"

for line in "${GITIGNORE_LINES[@]}"; do
  grep -qxF "${line}" "${GITIGNORE_FILE}" || echo "${line}" >> "${GITIGNORE_FILE}"
done
