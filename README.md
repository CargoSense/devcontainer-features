# CargoSense/devcontainer-features

🐳 📦 **Reusable Features for [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) and [GitHub Codespaces](https://github.com/features/codespaces).**

[![Build](https://img.shields.io/github/actions/workflow/status/CargoSense/devcontainer-features/lint.yml?label=Lint&logo=github&style=for-the-badge)](https://github.com/CargoSense/devcontainer-features/actions/workflows/lint.yml)
[![Build](https://img.shields.io/github/actions/workflow/status/CargoSense/devcontainer-features/test.yml?label=Test&logo=github&style=for-the-badge)](https://github.com/CargoSense/devcontainer-features/actions/workflows/test.yml)

> [!TIP]
> If you're new to Dev Containers, check out [the VisualStudio Code Dev Containers tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial).

## Usage

To reference a Feature from this repository, add the desired Features to a `devcontainer.json` file. Each Feature has a `README.md` that shows how to reference the Feature and which options are available for that Feature.

The example below installs [actionlint](https://github.com/rhysd/actionlint) and [ShellCheck](https://www.shellcheck.net) using the Features from this repository.

```json
{
  "name": "my-project-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/base:debian",
  "features": {
    "ghcr.io/CargoSense/devcontainer-features/actionlint:1": {},
    "ghcr.io/CargoSense/devcontainer-features/shellcheck:1": {
      "version": "latest"
    },
  }
}
```

> [!TIP]
> Features are located in this repository's [`./src` folder](https://github.com/CargoSense/devcontainer-features/tree/main/src). Each Feature's available options are detailed in their respective `README.md` files.

> [!NOTE]
> These Features are limited in scope and primarily target Debian/Ubuntu and compatible Linux distributions. They may not be suitable for every circumstance.

## License

The code in this repository is freely available under the [MIT License](https://opensource.org/licenses/MIT).
