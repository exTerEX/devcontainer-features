# Nextflow (nextflow)

Installs Nextflow into your devcontainer environment to allow rapid and robust computational pipeline prototyping and execution[cite: 20].

## Supported Platforms

- **Architectures**: `x86_64` (amd64), `aarch64` (arm64)
- **Linux Distributions**: Debian, Ubuntu, Fedora, RHEL, openSUSE, and Arch Linux

## Example Usage

```json
"features": {
    "ghcr.io/andreassag/features/nextflow:1": {}
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific Nextflow version to compile and install. | `string` | `latest` | `latest`, `24.04.4` |
