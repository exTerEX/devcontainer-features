# Devcontainer Features

A collection of modular, production-ready **Development Container Features** designed to bootstrap reproducible computational biology and bioinformatics environments in seconds.

These features allow you to seamlessly inject foundational genomics tools, workflow managers, and utilities into your development containers without writing complex Dockerfiles.

---

## Available Features

The following features are located within the `src/` directory. Each link points directly to the respective feature configuration and documentation.

| Feature Name | Source Path | Description |
| :--- | :--- | :--- |
| **BCFtools** | [`src/bcftools`](./src/bcftools) | Variant calling and manipulating VCF and BCF files. |
| **BLAST** | [`src/blast`](./src/blast) | Basic Local Alignment Search Tool for comparing primary biological sequence information. |
| **NCBI Dataformat CLI** | [`src/dataformat-cli`](./src/dataformat-cli) | Command-line utility to convert NCBI metadata reports from JSON into other structured formats. |
| **NCBI Datasets CLI** | [`src/datasets-cli`](./src/datasets-cli) | Command-line tool to download biological data (genomes, genes) across NCBI databases. |
| **HTSlib** | [`src/htslib`](./src/htslib) | Core C library and utilities (`bgzip`, `tabix`, `htsfile`) for high-throughput sequencing data. |
| **Nextflow** | [`src/nextflow`](./src/nextflow) | A polyglot workflow framework for scalable, data-driven computational pipelines. |
| **nf-core** | [`src/nf-core`](./src/nf-core) | Developer tools for building, linting, and managing community-curated nf-core pipelines. |
| **nf-test** | [`src/nf-test`](./src/nf-test) | A lightweight unit and integration testing framework specifically built for Nextflow pipelines. |
| **SAMtools** | [`src/samtools`](./src/samtools) | Utilities for manipulating high-throughput sequencing data formats (SAM, BAM, CRAM). |

---

## Getting Started

To utilize these features in your project, reference them directly inside your `.devcontainer/devcontainer.json` file.

### Example Configuration

```json
{
    "name": "Bioinformatics Workspace",
    "image": "https://mcr.microsoft.com/devcontainers/base:debian",
    "features": {
        "ghcr.io/exterex/features/htslib:1": {
            "version": "latest"
        },
        "ghcr.io/exterex/features/samtools:1": {
            "version": "1.24"
        },
        "ghcr.io/exterex/features/nextflow:1": {
            "version": "latest"
        }
    }
}
```
