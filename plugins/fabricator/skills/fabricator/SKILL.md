---
name: fab
description: Orchestrates multi-agent development — bootstraps OpenSpec plans into td task graphs and coordinates agent teamwork.
argument-hint: [command]
---

# Fabricator — Agent Orchestration

Fabricator is the coordination layer between OpenSpec (planning) and td (execution). It imports planned tasks into a dependency-aware graph, defines session protocols for solo and multi-agent work, and tracks progress through structured logging and handoffs.

## When to Use

| Scenario | Use Fabricator? |
|----------|----------------|
| OpenSpec change with 5+ tasks to execute | **Yes** — bootstrap into td |
| Multi-session project needing handoff continuity | **Yes** — session protocol + handoff |
| Multiple agents working on the same project | **Yes** — coordination rules prevent conflicts |
| Quick single-session task | **No** — just use td directly |

## Stack

```
OpenSpec (planning) → Fabricator (decomposition + coordination) → td (execution)
```

OpenSpec owns *what* to build. Fabricator owns *how* to decompose it, *who does what*, and *how they coordinate*. td owns *what to do next*.

## Quick Start

```
Fast path:    /fab:sketch <feature> → review → /fab:bootstrap <feature> → work → /fab:handoff
Deliberate:   /fab:plan <feature>   → review → /fab:bootstrap <feature> → work → /fab:handoff
```

After bootstrap, the work loop is: `td critical-path` → `td start <id>` → implement → `td review <id>` → repeat.

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/fab:sketch <change-name>` | Fast planning: generate all OpenSpec artifacts at once, pause for review |
| `/fab:plan <change-name>` | Deliberate planning: iterate through proposal → specs → design with review at each stage |
| `/fab:bootstrap <change-name>` | Decompose (if needed) → parse tasks.md → preview → create td issues → stamp IDs |
| `/fab:continue` | Resume from handoff: new session context, critical path, pending handoffs |
| `/fab:handoff` | End-of-session: structured handoffs for all in-progress issues |

## Planning Commands

`/fab:sketch` and `/fab:plan` both produce the same OpenSpec artifacts (proposal, specs, design, tasks). They differ in pacing:

- **Sketch** — Generates everything in one pass via `/opsx:ff`. Use when requirements are clear, the domain is well-understood, and scope is small-medium. Best for standard patterns where you know what you want.
- **Plan** — Steps through each stage via `/opsx:continue`, pausing after each artifact for review. Use when requirements are ambiguous, the domain is unfamiliar, scope is large, or stakeholders need to review at each stage.

Both commands pause after planning completes. Review the artifacts in `openspec/changes/<name>/`, then run `/fab:bootstrap <name>` to decompose and create the task graph.

See **references/planning-procedure.md** for full procedures and decision criteria.

## Roles

Fabricator defines three roles. A solo agent wears both hats as needed.

- **Lead** — Reviews progress, plans next priorities, manages handoffs
- **Worker** — Claims tasks, implements, submits for review
- **Solo** — Acts as lead at session boundaries, worker during implementation

## Session Protocol

**Start (lead hat) — use `/fab:continue`:**
1. `td usage --new-session` → load session context + pending handoffs
2. `td critical-path` → see unblocked work and bottlenecks
3. Pick highest-priority task from the START NOW section

**During (worker hat):**
1. **FIRST: `td start <id>`** → claim task (MANDATORY before ANY implementation)
2. Implement, test, commit — log progress with `td log`
3. `td review <id>` → submit for review
4. `td critical-path` → next task

**End (lead hat) — use `/fab:handoff`:**
1. `td handoff <id>` for every in-progress issue (written for future agent with zero context)
2. `td review <id>` for any completed work
3. Structured summary of session progress

## CRITICAL: Claim Before Working

**Every agent MUST run `td start <id>` BEFORE starting any implementation work.** This is the lock that prevents multiple agents from colliding on the same task. Skipping this causes duplicate work.

This applies whether you are a solo agent, a lead, or a worker. No exceptions.

## Coordination Rules

1. **One task, one agent** — Never work on a task another agent has `in_progress`
2. **Dependency respect** — Only work on tasks in the START NOW section of `td critical-path`
3. **File conflict avoidance** — If two ready tasks touch the same files, make them sequential (`td dep add`)
4. **Blocker escalation** — If blocked, `td log --blocker "reason"` then `td block <id>`, move to next task
5. **Progress logging** — Use `td log` with appropriate flags (`--decision`, `--tried`, `--result`)

See **references/coordination-rules.md** for conflict avoidance details and handoff format.

## Bootstrap Overview

`/fab:bootstrap <change-name>` is interactive:

1. **Decompose** (if needed) — When tasks.md lacks annotations (`<!-- depends-on -->`, `<!-- files -->`), read OpenSpec artifacts (proposal, specs, design), identify architectural layers, decompose into implementation tasks, order by dependencies, and annotate. See **references/decomposition/decomposition-patterns.md** for layer ordering and heuristics.
2. **Parse** — Read `openspec/changes/<name>/tasks.md`, extract task list and annotations
3. **Preview** — Display parsed tasks with inferred dependencies for review
4. **Validate** — Check decomposition quality: layer ordering respected, granularity rules met (1-3 files per task), dependencies complete and acyclic, all spec scenarios covered by test tasks, annotations present. **Block creation if checks fail** — report findings with fix suggestions.
5. **Create** — After approval, create td issues + wire dependencies with `td dep add`
6. **Stamp** — Write td issue IDs back into tasks.md and commit

See **references/bootstrap-procedure.md** for full logic and dependency inference rules.

## Decomposition

When `/fab:bootstrap` needs to decompose (Step 0), it follows this procedure:

1. **Read inputs** — Load from `openspec/changes/<name>/`:
   - `proposal.md` — scope boundaries, what's in/out
   - `specs/` — Given/When/Then scenarios (each maps to test tasks)
   - `design.md` — affected files, architecture, technology choices
   - Scan project source tree for existing patterns and conventions

2. **Identify layers** — Map design.md items to architectural layers using the layer ordering table. See **references/decomposition/decomposition-patterns.md** for the full table and heuristics. Apply architectural principles from **references/principles/core.md**. Consult the relevant language-specific principles file: **references/principles/python.md** for Python, **references/principles/typescript.md** for TypeScript, **references/principles/golang.md** for Go, **references/principles/svelte.md** for Svelte/SvelteKit.

3. **Decompose into tasks** — Apply granularity rules:
   - Each task touches 1-3 files
   - Each task completable without design decisions (those belong in design.md)
   - Each task has a clear "done" signal (file exists, test passes, endpoint responds)
   - If a task uses "and" to join unrelated actions, split it
   - Each Given/When/Then scenario → at least one test task
   - If principles mandate specific patterns (security tests, immutability, protocol definitions), create explicit tasks for them

4. **Order by dependencies** — Arrange tasks bottom-up: infrastructure → data → services → API → UI → tests. Annotate with `<!-- depends-on -->` and `<!-- files -->` comments.

5. **Write tasks.md** — Output to `openspec/changes/<name>/tasks.md` using the enhanced format. See **references/decomposition/tasks-format.md** for the full spec.

6. **Present for review** — Show the user the task list with dependency graph before proceeding to validation.

### Stack-Specific Patterns

When decomposing, consult the relevant stack pattern reference for technology-specific ordering:

- **references/stack-patterns/python-fastapi.md** — FastAPI + SQLAlchemy + Alembic
- **references/stack-patterns/svelte.md** — SvelteKit components and routes
- **references/stack-patterns/k8s-helm.md** — Kubernetes, Helm charts, Skaffold
- **references/stack-patterns/golang-http.md** — Go HTTP services (chi, gorilla/mux, echo)
- **references/stack-patterns/duckdb.md** — DuckDB analytics and data pipelines
- **references/stack-patterns/makefile.md** — Makefile build automation

## Status Visibility

Use td's built-in tools instead of custom reports:

- `td critical-path` — Optimal work sequence, bottlenecks, unblocked tasks
- `td query "status = in_progress"` — Who's working on what
- `td board show <board>` — Kanban-style status view
- `td reviewable` — What's ready for review

## References

- **references/planning-procedure.md** — `/fab:sketch` and `/fab:plan` procedures and decision criteria
- **references/bootstrap-procedure.md** — Detailed `/fab:bootstrap` logic, decomposition, validation, and dependency inference
- **references/coordination-rules.md** — Work loop, conflict avoidance, handoff format, multi-agent safety
- **references/decomposition/decomposition-patterns.md** — Layer ordering table, granularity rules, dependency heuristics
- **references/decomposition/tasks-format.md** — Enhanced tasks.md format with annotation spec
- **references/principles/core.md** — Universal design principles (layer responsibilities, testing, security, data design)
- **references/principles/python.md** — Python-specific patterns (attrs, Pydantic, SQLAlchemy, pytest)
- **references/principles/typescript.md** — TypeScript-specific patterns (strict types, Zod, Result types, Vitest)
- **references/principles/golang.md** — Go-specific patterns (error handling, interfaces, concurrency, table-driven tests)
- **references/principles/svelte.md** — Svelte/SvelteKit-specific patterns (reactivity, stores, SSR, component design)
- **references/stack-patterns/python-fastapi.md** — FastAPI/SQLAlchemy decomposition
- **references/stack-patterns/svelte.md** — SvelteKit decomposition
- **references/stack-patterns/k8s-helm.md** — Kubernetes/Helm/Skaffold decomposition
- **references/stack-patterns/golang-http.md** — Go HTTP service decomposition
- **references/stack-patterns/duckdb.md** — DuckDB analytics/data pipeline decomposition
- **references/stack-patterns/makefile.md** — Makefile build automation decomposition
