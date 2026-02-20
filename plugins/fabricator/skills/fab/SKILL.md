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

## Roles

Fabricator defines three roles. A solo agent wears both hats as needed.

- **Lead** — Reviews progress, plans next priorities, manages handoffs
- **Worker** — Claims tasks, implements, submits for review
- **Solo** — Acts as lead at session boundaries, worker during implementation

## Status Visibility

Use td's built-in tools instead of custom reports:

- `td critical-path` — Optimal work sequence, bottlenecks, unblocked tasks
- `td query "status = in_progress"` — Who's working on what
- `td board show <board>` — Kanban-style status view
- `td reviewable` — What's ready for review
