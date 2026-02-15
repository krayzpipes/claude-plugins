# Claude Plugins Repo Conventions

## Adding a New Plugin

1. Create a new directory under `plugins/` with kebab-case naming (e.g., `plugins/my-new-plugin`)
2. Add a `.claude-plugin/plugin.json` manifest inside the plugin directory
3. Place skills in `plugins/<name>/skills/<skill-name>/SKILL.md`
4. Add a corresponding entry to `registry.json`
5. Add the plugin to `.claude-plugin/marketplace.json`

## Plugin Structure

Each plugin follows this structure:
```
plugins/<name>/
  .claude-plugin/plugin.json    # Plugin manifest
  skills/<skill-name>/
    SKILL.md                    # Skill definition
    references/                 # Supporting reference docs
```

## Registry Entry Format

Each entry in `registry.json` must include:
- `name` — kebab-case identifier
- `type` — one of: `skill`, `hook`, `slash-command`
- `description` — short summary of what the plugin does
- `path` — relative path from repo root (e.g., `plugins/my-plugin`)
- `version` — semver string (start at `0.1.0`)

## General

- Keep plugins focused and single-purpose
- Include a brief comment or header in each plugin file explaining its purpose
