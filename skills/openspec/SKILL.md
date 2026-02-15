---
name: openspec
description: Guides spec-driven development using OpenSpec — plan changes with proposals, specs, design docs, and tasks before writing code.
argument-hint: [feature-name]
---

# OpenSpec — Spec-Driven Development

Use OpenSpec to align on intent before writing code. Changes flow through structured artifacts — proposal, specs, design, tasks — so implementation matches requirements.

## When to Use

| Scenario | Use OpenSpec? |
|----------|--------------|
| New feature with multiple components | Yes |
| Refactor touching several files | Yes |
| Brownfield change to existing behavior | Yes — delta specs shine here |
| Quick bug fix or one-line change | No |
| Exploratory investigation | Use `/opsx:explore` first |

## Core Workflow

```
/opsx:new → /opsx:ff → /opsx:apply → /opsx:archive
```

1. **`/opsx:new <name>`** — Create a change folder under `openspec/changes/<name>/`
2. **`/opsx:ff <name>`** — Fast-forward: generate all planning artifacts at once
3. **`/opsx:apply <name>`** — Implement tasks from the generated checklist
4. **`/opsx:archive <name>`** — Merge delta specs into main specs and archive the change

For complex or exploratory work, replace step 2 with **`/opsx:continue <name>`** to generate one artifact at a time with review between steps.

## Project Structure

```
openspec/
├── changes/
│   ├── <feature-name>/
│   │   ├── proposal.md      # Why and what (rationale, scope)
│   │   ├── specs/            # Delta specs (ADDED/MODIFIED/REMOVED)
│   │   ├── design.md         # How (technical approach, file changes)
│   │   └── tasks.md          # Implementation checklist
│   └── archive/
│       └── <date>-<name>/    # Completed changes with merged specs
```

## Artifacts at a Glance

| Artifact | Contains | Key Question |
|----------|----------|--------------|
| `proposal.md` | Rationale, scope boundaries, approach | *Why are we doing this?* |
| `specs/` | Delta specs organized by domain | *What changes to requirements?* |
| `design.md` | Architecture choices, data flow, affected files | *How will we build it?* |
| `tasks.md` | Numbered, checkable implementation steps | *What do we do, in order?* |

## Delta Specs Format

Delta specs describe changes relative to existing behavior rather than restating entire specifications. Each spec file uses three sections:

- **ADDED** — New requirements the system must support
- **MODIFIED** — Changed existing behaviors (note what changed from previous version)
- **REMOVED** — Deprecated functionality being dropped

Requirements use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY). Scenarios use Given/When/Then structure for testable examples.

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/opsx:new <name>` | Create change folder |
| `/opsx:ff <name>` | Fast-forward — generate all artifacts |
| `/opsx:continue <name>` | Generate next artifact iteratively |
| `/opsx:apply <name>` | Implement tasks |
| `/opsx:verify <name>` | Validate implementation against specs |
| `/opsx:sync <name>` | Merge delta specs into main specs |
| `/opsx:archive <name>` | Archive completed change |
| `/opsx:bulk-archive` | Archive multiple changes at once |
| `/opsx:explore <topic>` | Investigate before committing to a change |
| `/opsx:onboard` | Interactive tutorial using your codebase |

## CLI Commands

| Command | Purpose |
|---------|---------|
| `openspec init` | Initialize OpenSpec in a project |
| `openspec update` | Regenerate agent instructions and skills |
| `openspec list` | View active changes |
| `openspec status --change <name>` | Check artifact status for a change |
| `openspec schemas` | List available schemas |
| `openspec schema init <name>` | Create a custom schema |

## Verification

After implementation, run `/opsx:verify` to check three dimensions:

1. **Completeness** — All tasks done, all requirements have corresponding code
2. **Correctness** — Implementation matches spec intent and handles edge cases
3. **Coherence** — Design decisions reflected in code structure

## References

For detailed walkthroughs, delta spec examples, and artifact format guidance, see:

- **references/workflow-details.md** — Full change cycle walkthrough with examples
