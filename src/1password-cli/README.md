# 1password-cli

Install the [1Password CLI](https://developer.1password.com/docs/cli/) (`op`) from 1Password's signed apt repository.

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/1password-cli:1": {}
}
```

## Options

This Feature has no options. It installs the latest `1password-cli` package.

## Signing in

The 1Password desktop app's CLI integration does not reach into a container, so `op` signs in with your account details instead:

```sh
op account add --address <your-team>.1password.com --email <you@example.com>   # once; asks for your Secret Key and password
eval "$(op signin)"                                                            # in each terminal that needs it
```

`op account add` stores the account in `~/.config/op`. Mount a named volume there (for example `type=volume,source=op-config,target=/home/vscode/.config/op`, owned by the remote user) to keep it across rebuilds.

## OS Support

This Feature should work on recent versions of Debian/Ubuntu and Linux distributions using the [apt](https://wiki.debian.org/AptCLI) management tool, on `amd64` and `arm64`.
