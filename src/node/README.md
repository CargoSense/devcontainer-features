# node

Install [Node.js](https://nodejs.org) from prebuilt binaries.

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/node:4": {}
}
```

## Options

| Option ID | Description                     | Type   | Default Value |
|:----------|:--------------------------------|:-------|:--------------|
| `version` | The Node.js version to install. | string | `latest`      |

## OS Support

This Feature should work on recent versions of Debian/Ubuntu and Linux distributions using the [apt](https://wiki.debian.org/AptCLI) management tool and on architectures for which Node.js provides prebuilt binaries.
