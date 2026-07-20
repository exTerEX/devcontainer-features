# NCBI BLAST+ (blast)

Feature installs the standalone suite of BLAST+ command-line tools into your devcontainer environment.

## Supported Architectures & Distributions

* **Architectures:** `x86_64` (x64), `aarch64` (ARM64)
* **Linux Distributions:** Debian, Ubuntu, Fedora, RHEL, OpenSUSE, and Arch Linux

## Example Usage

```json
"features": {
    "ghcr.io/exterex/features/blast:1": {
        "version": "latest"
    }
}

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific BLAST+ version to compile and install. | `string` | `latest` | `latest`, `2.14.1`, `2.15.0`, `2.16.0` |
