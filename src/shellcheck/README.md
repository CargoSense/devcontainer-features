# shellcheck

Install [ShellCheck](https://www.shellcheck.net), a static analysis tool for shell scripts.

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/shellcheck:1": {}
}
```

## Options

| Option ID     | Description                                  | Type   | Default Value    |
|:--------------|:---------------------------------------------|:-------|:-----------------|
| `version`     | The ShellCheck version to install.           | string | `os-provided`    |
| `installPath` | The path where ShellCheck will be installed. | string | `/usr/local/bin` |

## OS Support

This Feature should work on recent versions of Debian/Ubuntu and Linux distributions using the [apt](https://wiki.debian.org/AptCLI) management tool.

`bash` is required to execute the `install.sh` script.
