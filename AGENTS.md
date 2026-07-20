# Project AI Constraints & Automation

## Devcontainer Feature Development Rules

### 1. Cross-Distribution & Architecture Parity
- **Multi-Arch:** Natively support `x86_64` and `aarch64` using dynamic `uname -m` checks for binary fetching or native compilation.
- **Distro Agnostic:** Support Debian, Ubuntu, Fedora, RHEL, OpenSUSE, and Arch Linux. Use a dynamic package manager matrix (`apt-get`, `dnf`, `zypper`, `pacman`) in `install.sh`.

### 2. Script Cleanliness
- **Zero Footprint:** Any temporary compilation utilities or development headers (`gcc`, `make`, `*-devel`) must be entirely purged before the installation script exits.
- **Line Endings:** Enforce strict `LF` line endings on all `install.sh` scripts to prevent cross-platform host initialization failures.

### 3. Verification & Discoverability
- **Testing Matrix:** Every feature requires a dedicated harness in `test/<feature-id>/`, featuring a multi-distro `scenarios.json` and strict binary execution tests.
- **README Synchronization:** Immediately update the root `README.md` whenever a tool is added or modified to keep the feature matrix discoverable for users and AI agents.

## Token Optimization Rules

### 1. Codebase Navigation (Graphify)
- **Triggers:** Queries regarding architecture, file relations, structural changes, or locating components.
- **Protocol:** Never perform broad directory scans or recursive file reads if `graphify-out/graph.json` exists. Use targeted subcommands instead:
  - `graphify query "<question>"` -> General codebase structure/location questions.
  - `graphify path "<A>" "<B>"` -> Relationships between files/classes.
  - `graphify explain "<concept>"` -> Deep-dives into focused concepts.
- **Context Fallbacks:** 
  - Use `graphify-out/wiki/index.md` for high-level navigation.
  - Read `graphify-out/GRAPH_REPORT.md` only if subcommands yield insufficient context.
  - Inspect raw source files *only* when actively modifying/debugging, if the graph lacks depth, or if the graph is missing/stale.
- **Maintenance:** Run `/graphify` in chat to regenerate or update codebase maps.

### 2. Terminal Output Compression (RTK Proxy)
- **Core Rule:** You must prefix all shell and terminal commands with the `rtk` wrapper to filter and compress stdout/stderr (e.g., `rtk cargo test`, `rtk docker ps`, `rtk git status`).
- **Available Meta Commands:**
  - `rtk gain` / `rtk gain --history` -> Inspect token savings dashboard and metrics.
  - `rtk discover` -> Scan for un-proxied command opportunities.
  - `rtk proxy <cmd>` -> Run a raw command bypass while maintaining usage logs.
