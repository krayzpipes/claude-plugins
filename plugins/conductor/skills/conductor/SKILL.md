---
name: conductor
description: Orchestrates multi-agent development — bootstraps OpenSpec plans into Beads task graphs and coordinates agent teamwork.
argument-hint: [command]
---

# Conductor — Agent Orchestration

Conductor is the coordination layer between OpenSpec (planning) and Beads (execution). It imports planned tasks into a dependency-aware graph, defines session protocols for solo and multi-agent work, and provides progress reporting.

## When to Use

| Scenario | Use Conductor? |
|----------|---------------|
| OpenSpec change with 5+ tasks to execute | **Yes** — bootstrap into Beads |
| Multi-session project needing handoff continuity | **Yes** — session protocol + handoff |
| Multiple agents working on the same project | **Yes** — coordination rules prevent conflicts |
| Quick single-session task | **No** — just use Beads directly |

## Stack

```
OpenSpec (planning) → Conductor (coordination) → Beads (execution)
```

OpenSpec owns *what* to build. Beads owns *what to do next*. Conductor owns *who does what and how they coordinate*.

## Quick Start

1. Plan with OpenSpec: `/opsx:ff <feature>`
2. Bootstrap into Beads: `/conduct:bootstrap <feature>`
3. Work through tasks: `bd ready` → implement → `bd close`
4. Check progress: `/conduct:report`
5. End session: `/conduct:handoff`
6. Verify completion: `/opsx:verify <feature>`

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/conduct:bootstrap <change-name>` | Parse OpenSpec tasks.md → preview tasks + dependencies → create Beads entries after approval |
| `/conduct:report` | Generate progress report using Beads reporting contract |
| `/conduct:handoff` | End-of-session protocol: sync state, write handoff notes, structured summary |

## Roles

Conductor defines three roles. A solo agent wears both hats as needed.

- **Lead** — Reviews progress, plans next priorities, generates reports and handoffs
- **Worker** — Claims tasks, implements, closes with meaningful reasons
- **Solo** — Acts as lead at session boundaries, worker during implementation

See **references/roles-and-protocol.md** for full session start/end checklists.

## Session Protocol

**Start (lead hat):**
1. `bd ready` → see what's available
2. `/conduct:report` if resuming → understand overall state
3. Pick highest-priority unblocked task

**During (worker hat):**
1. `bd update <id> --status in_progress` → claim task
2. Implement, test, commit with bead ID: `bd-XXXX: description`
3. `bd close <id> --reason "..."` → mark complete
4. `bd ready` → next task

**End (lead hat):**
1. Update notes on any in-progress tasks (written for future agent with zero context)
2. Close all completed tasks with meaningful reasons
3. `/conduct:handoff` → structured summary + sync + commit

## Coordination Rules

1. **One task, one agent** — Never work on a task another agent has `in_progress`
2. **Dependency respect** — Only work on tasks where all dependencies are `closed`
3. **File conflict avoidance** — If two ready tasks touch the same files, make them sequential (`bd dep add`)
4. **Blocker escalation** — If blocked, update task notes, move to next ready task
5. **Commit convention** — All commits reference bead ID: `bd-XXXX: description`

See **references/coordination-rules.md** for conflict avoidance details and handoff format.

## Bootstrap Overview

`/conduct:bootstrap <change-name>` is interactive:

1. **Parse** — Read `openspec/changes/<name>/tasks.md`, extract task list
2. **Preview** — Display parsed tasks with inferred dependencies for review
3. **Create** — After approval, create Beads epic + tasks + dependencies
4. **Stamp** — Write bead IDs back into tasks.md and commit

See **references/bootstrap-procedure.md** for full logic and dependency inference rules.

## References

- **references/bootstrap-procedure.md** — Detailed `/conduct:bootstrap` logic and dependency inference
- **references/roles-and-protocol.md** — Lead/worker/solo protocols with checklists
- **references/coordination-rules.md** — Conflict avoidance, handoff format, multi-agent safety
