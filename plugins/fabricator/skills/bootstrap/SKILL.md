---
name: bootstrap
description: Decompose OpenSpec tasks into a dependency-aware td task graph with validation and stamping.
argument-hint: <change-name>
---

# `/fab:bootstrap` — Task Graph Bootstrap

Decomposes an OpenSpec change's tasks into a dependency-aware graph and imports them into td. Interactive — always previews before creating.

## Prerequisites

- OpenSpec change exists at `openspec/changes/<change-name>/` with a `tasks.md`
- td is initialized (`td init` has been run)
- Tasks in `tasks.md` use numbered or hierarchical checkbox format

## Overview

`/fab:bootstrap <change-name>` runs 6 steps:

1. **Decompose** (if needed) — When `tasks.md` lacks annotations (`<!-- depends-on -->`, `<!-- files -->`), read OpenSpec artifacts, identify architectural layers, decompose into implementation tasks, order by dependencies, and annotate. See **references/decomposition/decomposition-patterns.md** for layer ordering and heuristics.

2. **Parse** — Read `openspec/changes/<name>/tasks.md`, extract task list and annotations.

3. **Preview** — Display parsed tasks with inferred dependencies for review.

4. **Validate** — Check decomposition quality: layer ordering respected, granularity rules met (1-3 files per task), dependencies complete and acyclic, all spec scenarios covered by test tasks, annotations present. **Block creation if checks fail** — report findings with fix suggestions.

5. **Create** — After approval, create td issues + wire dependencies with `td dep add`.

6. **Stamp** — Write td issue IDs back into `tasks.md` and commit.

See **references/bootstrap-procedure.md** for the full logic, dependency inference rules, and edge cases.

## Decomposition References

When decomposing, consult the relevant references:

- **references/decomposition/decomposition-patterns.md** — Layer ordering table, granularity rules, dependency heuristics
- **references/decomposition/tasks-format.md** — Enhanced tasks.md format with annotation spec
- **references/principles/core.md** — Universal design principles (layer responsibilities, testing, security, data design)
- **references/principles/python.md** — Python-specific patterns (attrs, Pydantic, SQLAlchemy, pytest)
- **references/principles/typescript.md** — TypeScript-specific patterns (strict types, Zod, Result types, Vitest)
- **references/principles/golang.md** — Go-specific patterns (error handling, interfaces, concurrency, table-driven tests)
- **references/principles/svelte.md** — Svelte/SvelteKit-specific patterns (reactivity, stores, SSR, component design)

## Stack-Specific Patterns

Consult the relevant stack pattern reference for technology-specific decomposition ordering:

- **references/stack-patterns/python-fastapi.md** — FastAPI + SQLAlchemy + Alembic
- **references/stack-patterns/svelte.md** — SvelteKit components and routes
- **references/stack-patterns/k8s-helm.md** — Kubernetes, Helm charts, Skaffold
- **references/stack-patterns/golang-http.md** — Go HTTP services (chi, gorilla/mux, echo)
- **references/stack-patterns/duckdb.md** — DuckDB analytics and data pipelines
- **references/stack-patterns/makefile.md** — Makefile build automation
