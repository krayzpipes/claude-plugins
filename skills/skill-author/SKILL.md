---
name: skill-author
description: Guidelines for authoring, evaluating, and restructuring Claude Code skills. Use when creating a new skill or reviewing an existing one for quality.
argument-hint: [skill-name or path-to-skill]
---

# Skill Author — Authoring & Evaluation Guide

Create high-quality Claude Code skills that are concise, actionable, and load only what the model needs at invocation time.

## Valid Frontmatter Fields

| Field | Description |
|-------|-------------|
| `name` | Kebab-case skill identifier (required) |
| `description` | One-line summary; shown in skill listings (required) |
| `argument-hint` | Placeholder shown to user, e.g. `[branch-name]` |
| `allowed-tools` | Restrict which tools the skill may use |
| `user-invocable` | Whether user can trigger via `/name` (default: true) |
| `disable-model-invocation` | Prevent model from auto-invoking (default: false) |
| `model` | Pin to a specific model tier |
| `context` | Additional files/globs to load with the skill |
| `agent` | Agent configuration for the skill |
| `hooks` | Shell commands triggered by skill lifecycle events |

## SKILL.md Sizing Rules

- **Target:** 80–120 lines
- **Ceiling:** 500 lines (hard max for any SKILL.md)
- **Overflow strategy:** Extract to `references/` and link from SKILL.md
- Every line should earn its place — if removing a line wouldn't change model behavior, cut it

## What Belongs in SKILL.md

- [ ] Purpose summary (2-3 lines)
- [ ] When-to-use decision aid (table or short list)
- [ ] Core workflow / essential commands (compact form)
- [ ] Session start and end protocols (if applicable)
- [ ] Links to reference files for details

## What to Move to References

These are valuable but don't need to load on every invocation:

- Full command catalogs with exhaustive flag documentation
- Concrete worked examples and walkthroughs
- Integration guides for optional companion tools
- Error recovery and troubleshooting tables
- Rigid output format contracts or templates
- Migration guides and version-specific notes

## What to Cut Entirely

Claude already knows these things — including them wastes context:

- **Git conventions** — commit message formats, branching strategies, `.gitignore` patterns
- **Priority/severity definitions** — P0-P3 scales, standard triage definitions
- **Basic tool usage** — how to run `git`, `npm`, `cargo`, etc.
- **Verbose examples of simple concepts** — if one example suffices, don't add three
- **Installation/setup instructions** — unless the tool is obscure or has non-obvious steps
- **Marketing copy** — "This revolutionary skill will transform your workflow..."
- **Motivation/persuasion** — The model doesn't need to be convinced to follow instructions

## Evaluation Checklist

When reviewing a skill, verify each item:

1. **Line count** — Is SKILL.md within 80-120 lines? Under 500 ceiling?
2. **Frontmatter** — Uses only official fields listed above? Has `name` and `description`?
3. **No redundant knowledge** — Nothing Claude already knows (git basics, priority scales)?
4. **Decision aid present** — Can the model decide when to use vs. skip this skill?
5. **References extracted** — Detailed content in `references/`, not inline?
6. **Actionable** — Every section changes model behavior; no filler or decoration?
7. **Single-purpose** — Skill does one thing well; not a grab-bag of loosely related guidance?
8. **No over-prescribed formats** — Output formats are flexible unless a strict contract is essential?

## Recommended Directory Structure

```
skills/<skill-name>/
  SKILL.md              # Core instructions (80-120 lines)
  references/           # Detailed supplementary material
    <topic>.md          # One file per topic, linked from SKILL.md
```

## Reference Files

For detailed evaluation criteria, anti-patterns, and the section triage table, see:

- **references/evaluation-guide.md** — Deep-dive on what to keep, move, or cut
