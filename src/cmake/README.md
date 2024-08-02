# CMake (cmake)

Installs the provided version of CMake in devcontainer image. CMake is installed from precompiled binaries. For now, the future is limited to debian derived linux.

## Example usage

```json
"features": {
    "ghcr.io/exterex/devcontainer-features/CMake": {}
}
```

## Options

| Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select a Python version to install. | string | latest |

## Customizations

### VS Code Extensions

- `ms-vscode.cmake-tools`
- `twxs.cmake`
