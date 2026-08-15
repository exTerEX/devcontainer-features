# nf-core tools (nf-core)

Installs the official nf-core tools CLI into your devcontainer. This provides a suite of helper tools for use with nf-core Nextflow pipelines, including pipeline creation, linting, downloading, and schema management.

## Supported Environments

- **Architectures**: `x86_64` (amd64), `aarch64` (arm64)
- **Linux Distributions**: Debian, Ubuntu, Fedora, RHEL, openSUSE, and Arch Linux

## Example Usage

```json
"features": {
    "ghcr.io/andreassag/features/nf-core:1": {}
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific nf-core version to compile and install. | `string` | `latest` | `latest`, `2.14.1`, `2.13.1` |
