# Ninja-build (ninja)

Installs the provided version of Ninja-build in devcontainer image. Ninja is installed from precompiled binaries.

**Note**: For now, this feature will only support debian-based systems and x86_64-based images.

## Example usage

```json
"features": {
    "ghcr.io/exterex/devcontainer-features/ninja-build": {}
}
```

## Options

| Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select a Ninja version to install. | string | latest |
