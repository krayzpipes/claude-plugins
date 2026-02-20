# Claude Plugins Marketplace

A personal collection of Claude Code plugins — skills for spec-driven development and agent orchestration — packaged as a plugin marketplace.

## Usage

### As a Plugin Marketplace

Register this repo as a marketplace source, then install individual plugins:

```bash
# Add this repo as a marketplace
claude plugin marketplace add /path/to/claude-plugins

# Install a plugin
claude plugin install fabricator
```

### Direct Plugin Loading

Load a plugin directly for testing or one-off use:

```bash
claude --plugin-dir /path/to/claude-plugins/plugins/fabricator
```

## Structure

- **`plugins/`** — Each subdirectory is a self-contained plugin with its own `.claude-plugin/plugin.json` manifest
- **`.claude-plugin/marketplace.json`** — Marketplace catalog listing all available plugins
- **`registry.json`** — Metadata catalog of all plugins

## Available Plugins

| Plugin | Description |
|--------|-------------|
| **fabricator** | Orchestrates planning, task decomposition, and multi-agent coordination between OpenSpec and td |
| **td** | CLI task tracking with structured handoffs, progress logging, and dependency-aware scheduling across AI coding sessions |
| **skill-author** | Guidelines for authoring, evaluating, and restructuring Claude Code skills |

## Adding a Plugin

1. Create a new directory under `plugins/` with a `.claude-plugin/plugin.json` manifest
2. Add skills in `plugins/<name>/skills/<skill-name>/SKILL.md`
3. Add an entry to `registry.json` and `.claude-plugin/marketplace.json`
4. Commit and push
