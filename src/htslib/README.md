# HTSlib (htslib)

Feature compiles and installs HTSlib C library and utilities (`bgzip`, `tabix`, `htsfile`) into your devcontainer environment for accessing high-throughput biological sequencing data formats.

## Supported Architectures & Distributions

* **Architectures:** `x86_64` (x64), `aarch64` (ARM64) via native compilation.
* **Linux Distributions:** Debian, Ubuntu, Fedora, RHEL, OpenSUSE, and Arch Linux.

## Example Usage

```json
"features": {
    "ghcr.io/exterex/features/htslib:1": {
        "version": "latest"
    }
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific HTSlib version to compile and install. | `string` | `latest` | `latest`, `1.24`, `1.23.2`, `1.22` |
