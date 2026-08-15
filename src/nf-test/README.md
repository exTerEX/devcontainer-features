# nf-test (nf-test)

A feature to install the nf-test framework to allow quick and isolated pipeline testing for Nextflow workflow setups.

## Supported Environments

- **Architectures**: `x86_64` (amd64), `aarch64` (arm64)
- **Linux Distributions**: Debian, Ubuntu, Fedora, RHEL, openSUSE, and Arch Linux

## Example Usage

```json
"features": {
    "ghcr.io/andreassag/features/nf-test:1": {}
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific nf-test version to compile and install. | `string` | `latest` | `latest`, `0.9.3`, `0.9.2` |
