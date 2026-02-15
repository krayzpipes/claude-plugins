# Claude Plugins Marketplace

A personal collection of Claude Code plugins — skills for spec-driven development and agent orchestration — packaged as a plugin marketplace.

## Usage

### As a Plugin Marketplace

Register this repo as a marketplace source, then install individual plugins:

```bash
# Add this repo as a marketplace
claude plugin marketplace add /path/to/claude-plugins

# Install a plugin
claude plugin install beads
```

### Direct Plugin Loading

Load a plugin directly for testing or one-off use:

```bash
claude --plugin-dir /path/to/claude-plugins/plugins/beads
```

## Structure

- **`plugins/`** — Each subdirectory is a self-contained plugin with its own `.claude-plugin/plugin.json` manifest
- **`.claude-plugin/marketplace.json`** — Marketplace catalog listing all available plugins
- **`registry.json`** — Metadata catalog of all plugins

## Available Plugins

| Plugin | Description |
|--------|-------------|
| **beads** | Git-backed task graph and agent memory using Beads (bd CLI) |
| **skill-author** | Guidelines for authoring, evaluating, and restructuring Claude Code skills |
| **openspec** | Spec-driven development using OpenSpec proposals, specs, designs, and tasks |
| **conductor** | Orchestrates multi-agent development with OpenSpec plans and Beads task graphs |
| **architect** | Decomposes OpenSpec designs into dependency-ordered, implementation-ready tasks |

## Adding a Plugin

1. Create a new directory under `plugins/` with a `.claude-plugin/plugin.json` manifest
2. Add skills in `plugins/<name>/skills/<skill-name>/SKILL.md`
3. Add an entry to `registry.json` and `.claude-plugin/marketplace.json`
4. Commit and push
