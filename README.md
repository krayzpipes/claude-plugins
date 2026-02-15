# Claude Plugins Marketplace

A personal collection of Claude Code plugins — skills, hooks, and slash commands — designed to be shared across all development environments.

## Usage

Reference this repo from any project by adding to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "permissions": {
    "allow": [
      "Bash(cat:/path/to/claude-plugins/skills/*)"
    ]
  }
}
```

Or symlink individual skills/hooks into a project:

```bash
ln -s /path/to/claude-plugins/skills/my-skill /your/project/.claude/skills/my-skill
```

## Structure

- **`skills/`** — Reusable skill definitions (markdown prompt files or directories)
- **`hooks/`** — Hook scripts that run in response to Claude Code events
- **`slash-commands/`** — Custom slash command definitions
- **`registry.json`** — Catalog of all available plugins with metadata

## Adding a Plugin

1. Create your skill, hook, or slash command in the appropriate directory
2. Add an entry to `registry.json` with name, type, description, path, and version
3. Commit and push
