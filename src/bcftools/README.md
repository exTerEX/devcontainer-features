# BCFtools (bcftools)

Feature compiles and installs the official suite of BCFtools utilities into your devcontainer environment for variant calling and manipulating VCF and BCF files.

## Supported Architectures & Distributions

* **Architectures:** `x86_64` (x64), `aarch64` (ARM64) via native compilation.
* **Linux Distributions:** Debian, Ubuntu, Fedora, RHEL, OpenSUSE, and Arch Linux.

## Example Usage

```json
"features": {
    "ghcr.io/exterex/features/bcftools:1": {
        "version": "latest"
    }
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific BCFtools version to compile and install. | `string` | `latest` | `latest`, `1.24`, `1.23.2`, `1.22` |
