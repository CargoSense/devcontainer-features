# apt-packages

Install programs using the [APT package manager](https://wiki.debian.org/AptCLI).

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/apt-packages:1": {
    "packages": "curl ca-certificates"
  }
}
```

## OS Support

This Feature should work on recent versions of Debian/Ubuntu and Linux distributions using the `apt` command-line program.
