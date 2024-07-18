# My devcontainer features

My devcontainer features using the [feature-starter](https://github.com/devcontainers/feature-starter) template.

## `magicmirror`

Automatically setup package manager mirrors, including ubuntu, pypi and apk etc.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/sidecus/devcontainer-features/magicmirror:1": {
            "ubuntu_mirror": "your-ubuntu-mirror",
            // "apk_mirror": "your-alpine-apk-mirror"
            "pypi_mirror": "your-python-pypi-mirror",
        }
    }
}
```
