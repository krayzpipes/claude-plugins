---
name: architect
description: Decomposes OpenSpec designs into dependency-ordered, implementation-ready tasks for Conductor/Beads execution.
argument-hint: [command] [change-name]
---

# Architect — Design-to-Task Decomposition

Reads OpenSpec planning artifacts (proposal, specs, design) and produces a properly decomposed `tasks.md` with dependency annotations. Bridges the gap between "how to build it" (design.md) and "what to do next" (Conductor/Beads).

## When to Use

| Scenario | Use Architect? |
|----------|---------------|
| OpenSpec change has design.md, needs tasks.md | **Yes** — `/arch:decompose` |
| Existing tasks.md feels too coarse or misordered | **Yes** — `/arch:review` then re-decompose |
| Simple change with 1-3 obvious tasks | **No** — write tasks.md by hand |
| No design.md yet | **No** — run `/opsx:ff` or `/opsx:continue` first |

## Workflow Position

```
OpenSpec (/opsx:ff)  →  Architect (/arch:decompose)  →  Conductor (/conduct:bootstrap)  →  Beads (bd ready)
```

Architect **replaces** the tasks.md generation step in the OpenSpec flow.

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/arch:decompose <name>` | Read OpenSpec artifacts for `<name>`, produce `tasks.md` |
| `/arch:review <name>` | Audit existing `tasks.md` for decomposition quality |

## `/arch:decompose <name>` Procedure

1. **Read inputs** — Load from `openspec/changes/<name>/`:
   - `proposal.md` — scope boundaries, what's in/out
   - `specs/` — Given/When/Then scenarios (each maps to test tasks)
   - `design.md` — affected files, architecture, technology choices
   - Scan project source tree for existing patterns and conventions

2. **Identify layers** — Map design.md items to architectural layers using the layer ordering table. See **references/decomposition-patterns.md** for the full table and heuristics. Apply architectural principles from **references/principles-core.md**. For Python projects, also consult **references/principles-python.md**.

3. **Decompose into tasks** — Apply granularity rules:
   - Each task touches 1-3 files
   - Each task completable without design decisions (those belong in design.md)
   - Each task has a clear "done" signal (file exists, test passes, endpoint responds)
   - If a task uses "and" to join unrelated actions, split it
   - Each Given/When/Then scenario → at least one test task
   - If principles mandate specific patterns (security tests, immutability, protocol definitions), create explicit tasks for them

4. **Order by dependencies** — Arrange tasks bottom-up: infrastructure → data → services → API → UI → tests. Annotate with `<!-- depends-on -->` and `<!-- files -->` comments.

5. **Write tasks.md** — Output to `openspec/changes/<name>/tasks.md` using the enhanced format. See **references/tasks-format.md** for the full spec.

6. **Present for review** — Show the user the task list with dependency graph before committing.

## `/arch:review <name>` Procedure

1. Read existing `openspec/changes/<name>/tasks.md`
2. Check against decomposition quality criteria:
   - Layer ordering respected?
   - Granularity rules met? (1-3 files per task, no compound tasks)
   - Dependencies complete and acyclic?
   - All spec scenarios covered by test tasks?
   - `<!-- depends-on -->` and `<!-- files -->` annotations present?
3. Report findings with specific fix suggestions

## Stack-Specific Patterns

When decomposing, consult the relevant stack pattern reference for technology-specific ordering:

- **references/stack-patterns-python-fastapi.md** — FastAPI + SQLAlchemy + Alembic
- **references/stack-patterns-svelte.md** — SvelteKit components and routes
- **references/stack-patterns-k8s-helm.md** — Kubernetes, Helm charts, Skaffold

## Edge Cases

- **No design.md** — Error: "Run `/opsx:ff <name>` or `/opsx:continue <name>` through design.md first"
- **design.md lists no affected files** — Warn and decompose from specs + proposal only
- **Existing tasks.md** — Ask: overwrite, or run `/arch:review` first?
- **Cross-cutting concerns** (logging, auth middleware) — Place in earliest dependent layer, note in `<!-- files -->` that multiple sections touch the file

## References

- **references/decomposition-patterns.md** — Layer ordering table, granularity rules, dependency heuristics
- **references/tasks-format.md** — Enhanced tasks.md format with annotation spec
- **references/stack-patterns-python-fastapi.md** — FastAPI/SQLAlchemy decomposition
- **references/stack-patterns-svelte.md** — SvelteKit decomposition
- **references/stack-patterns-k8s-helm.md** — Kubernetes/Helm/Skaffold decomposition
- **references/principles-core.md** — Universal design principles (layer responsibilities, testing, security, data design)
- **references/principles-python.md** — Python-specific patterns (attrs, Pydantic, SQLAlchemy, pytest)
