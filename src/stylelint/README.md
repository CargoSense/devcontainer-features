# stylelint

Install and configure [Stylelint](https://stylelint.io)'s [official Visual Studio Code extension](https://github.com/stylelint/vscode-stylelint).

## Usage

```json
"features": {
  "ghcr.io/CargoSense/devcontainer-features/stylelint:1": {}
}
```

> [!NOTE]
> From v1.0.0, the vscode-stylelint extension [does not bundle Stylelint](https://github.com/stylelint/vscode-stylelint#%EF%B8%8F-stylelint-is-no-longer-bundled). Be sure to add an up-to-date version of Stylelint to your project's `package.json` file.

## OS Support

This Feature should work on any operating system supported by Stylelint.
