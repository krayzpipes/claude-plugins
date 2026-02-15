---
name: beads
description: Git-backed task graph and agent memory using Beads (bd CLI). Use for dependency-aware task management, long-horizon projects, and session-resilient development.
---

# Beads — Agent Memory & Task Graph

Beads (`bd`) is a distributed, git-backed graph issue tracker for AI coding agents. It replaces flat task lists with a dependency-aware DAG, enabling long-horizon development without losing context across sessions.

## When to Use Beads

| Situation | Use Beads? |
|-----------|-----------|
| <5 tasks, single session, no dependencies | **No** — a simple checklist is enough |
| 5-10 tasks, some ordering matters | **Maybe** — use if spanning multiple sessions |
| 10+ tasks, cross-task dependencies, multi-session | **Yes** |
| Resuming work after a break or context compaction | **Yes** — `bd ready` is instant context recovery |

## Project Setup

```bash
bd init   # Creates .beads/ — commit issues.jsonl, do NOT commit beads.db
```

## Session Start Protocol

**Every session, before doing anything else:**

```bash
bd ready
```

Shows all tasks with no open blockers, sorted by priority. If resuming work, this tells you exactly where to pick up.

If `bd ready` returns nothing but you expect work, run `bd list` and `bd dep tree <epic-id>` to diagnose.

## Essential Commands

```bash
# Create tasks
bd create "Task title" -p 1
bd create "Epic title" -t epic -p 0
bd create "Subtask" -p 1 --parent bd-XXXX

# Dependencies
bd dep add <child-id> <parent-id>
bd dep remove <child-id> <parent-id>
bd dep tree <id>

# Find work
bd ready                                    # Unblocked tasks by priority
bd list                                     # All open tasks
bd show <id>                                # Task details + audit trail

# Work on tasks
bd update <id> --status in_progress
bd update <id> --notes "Progress: ..."      # Record state for future sessions
bd close <id> --reason "Completed: ..."
```

Use `--json` on any command for programmatic parsing.

Hierarchical IDs: `bd-a3f8` (epic) → `bd-a3f8.1` (task) → `bd-a3f8.1.1` (subtask).

## Solo Workflow Loop

```
1. bd ready                              # What is unblocked?
2. Pick the highest priority task
3. bd update <id> --status in_progress   # Claim it
4. Implement the task
5. bd close <id> --reason "..."          # Close with meaningful reason
6. git commit -m "... (bd-XXXX)"         # Include Beads ID in commit
7. Go to 1
```

## Notes Best Practice

Write notes as if explaining to a future agent with zero conversation context. Include: what was completed, current state, next step, and any key decisions made.

## End of Session Protocol

Before ending a session:

1. Update notes on any in-progress task with current state
2. Close all completed tasks with meaningful reasons
3. Run `bd sync` then `git add .beads/ && git commit -m "beads: sync state"`
4. Report: what was done, what `bd ready` shows next

## Reference Files

For detailed information, read these files in `references/` alongside this skill:

- **command-reference.md** — Full command catalog with examples
- **openspec-integration.md** — Combining Beads with OpenSpec for structured planning
- **error-recovery.md** — Troubleshooting common issues
- **reporting-contract.md** — Standard iteration reporting format

## Links

- **Repo:** <https://github.com/steveyegge/beads>
- **Agent instructions:** <https://github.com/steveyegge/beads/blob/main/AGENT_INSTRUCTIONS.md>
