# SAMtools (samtools)

Feature compiles and installs the official suite of SAMtools utilities into your devcontainer environment for manipulating high-throughput biological sequencing data.

## Supported Architectures & Distributions

* **Architectures:** `x86_64` (x64), `aarch64` (ARM64) via native compilation.
* **Linux Distributions:** Debian, Ubuntu, Fedora, RHEL, OpenSUSE, and Arch Linux.

## Example Usage

```json
"features": {
    "ghcr.io/andreassag/features/samtools:1": {
        "version": "latest"
    }
}
```

## Options

| Option ID | Description | Type | Default | Proposals |
|-----------|-------------|------|---------|-----------|
| `version` | Select a specific SAMtools version to compile and install. | `string` | `latest` | `latest`, `1.24`, `1.23.2`, `1.22` |
