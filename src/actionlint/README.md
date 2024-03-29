# actionlint

Install [actionlint](https://github.com/rhysd/actionlint), a static checker for [GitHub Actions](https://github.com/features/actions) workflow files.

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/actionlint:1": {}
}
```

## Options

| Option ID     | Description                                  | Type   | Default Value    |
|:--------------|:---------------------------------------------|:-------|:-----------------|
| `version`     | The actionlint version to install.           | string | `latest`         |
| `installPath` | The path where actionlint will be installed. | string | `/usr/local/bin` |

## OS Support

This Feature should work on recent versions of Debian/Ubuntu, RedHat Enterprise Linux, Fedora, Alma, and RockyLinux distributions with the `apt`, `yum`, `dnf`, or `microdnf` package manager installed.

`bash` is required to execute the `install.sh` script.
