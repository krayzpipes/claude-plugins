---
name: plan
description: Deliberate planning — iterate through each OpenSpec stage with review pauses between artifacts.
argument-hint: <change-name>
---

# `/fab:plan` — Deliberate Planning

Steps through each OpenSpec planning stage one at a time, pausing after each artifact for review. Use when requirements are ambiguous, the domain is unfamiliar, scope is large, or stakeholders need to review at each stage.

## When to Use

| Factor | Use `/fab:sketch` instead | Plan |
|--------|--------------------------|------|
| Requirements | Clear, well-defined | Ambiguous, evolving |
| Domain | Well-understood | New, unfamiliar |
| Scope | Small to medium | Large, multi-system |
| Review needs | Review once at the end | Review each stage |

Use plan when you need to think carefully at each stage or when requirements might change based on what you learn during planning.

## Procedure

See **references/planning-procedure.md** for the full procedure, but in brief:

1. Check for existing change at `openspec/changes/<name>/` — resume from last completed stage if partial
2. Create change folder with `/opsx:new <name>` if needed
3. Iterate through stages with `/opsx:continue <name>`, pausing after each:
   - **Proposal** → **Specs** → **Design** → **Tasks**
4. Pause after final stage — run `/fab:bootstrap <name>` when ready

## After Plan

Review all artifacts in `openspec/changes/<name>/`, then run `/fab:bootstrap <name>` to decompose and create the task graph.
