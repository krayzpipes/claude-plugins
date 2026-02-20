---
name: sketch
description: Fast planning — generate all OpenSpec artifacts in one pass, then pause for review.
argument-hint: <change-name>
---

# `/fab:sketch` — Fast Planning

Generates all OpenSpec planning artifacts (proposal, specs, design, tasks) in a single pass. Use when requirements are clear, the domain is well-understood, and scope is small-medium.

## When to Use

| Factor | Sketch | Use `/fab:plan` instead |
|--------|--------|------------------------|
| Requirements | Clear, well-defined | Ambiguous, evolving |
| Domain | Well-understood, standard patterns | New, unfamiliar |
| Scope | Small to medium | Large, multi-system |
| Review needs | Review once at the end | Review each stage |

**Default to sketch.** Switch to `/fab:plan` when you need to think carefully at each stage or when requirements might change based on what you learn during planning.

## Procedure

See **references/planning-procedure.md** for the full procedure, but in brief:

1. Check for existing change at `openspec/changes/<name>/`
2. Create change folder with `/opsx:new <name>` if needed
3. Generate all artifacts with `/opsx:ff <name>`
4. Present summary of what was generated
5. Pause for review — when satisfied, run `/fab:bootstrap <name>`

## After Sketch

Review artifacts in `openspec/changes/<name>/`, then run `/fab:bootstrap <name>` to decompose and create the task graph.
