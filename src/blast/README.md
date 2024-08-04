# NCBI BLAST+ (blast)

Installs the provided version of BLAST+ in devcontainer image.

**Note**: For now, this feature will only support debian-based systems and x86_64-based images. *version* only support pure *.*.*, not *.*.*alpha or anything else.

## Example usage

```json
"features": {
    "ghcr.io/exterex/devcontainer-features/blast": {}
}
```

## Options

| Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select a Blast+ version to install. | string | latest |
