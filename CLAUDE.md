# Claude Plugins Repo Conventions

## Adding a New Plugin

1. Place the plugin in the correct directory based on its type:
   - `skills/` for skills
   - `hooks/` for hooks
   - `slash-commands/` for slash commands
2. Use kebab-case for file and directory names (e.g., `my-new-skill`)
3. Add a corresponding entry to `registry.json`

## Registry Entry Format

Each entry in `registry.json` must include:
- `name` — kebab-case identifier
- `type` — one of: `skill`, `hook`, `slash-command`
- `description` — short summary of what the plugin does
- `path` — relative path from repo root
- `version` — semver string (start at `0.1.0`)

## General

- Keep plugins focused and single-purpose
- Include a brief comment or header in each plugin file explaining its purpose
