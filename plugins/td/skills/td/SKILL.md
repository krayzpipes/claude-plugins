---
name: td
description: Use this skill when the user mentions "td", task tracking, issue management, session handoffs, or structured logging for development work. Guides usage of the td CLI for tracking tasks across AI coding sessions.
---

# td — Task Tracking for AI Sessions

td is a CLI that tracks tasks across AI coding sessions. It provides structured handoffs, progress logging, and session-isolated review workflows so context is never lost between sessions.

## Session Protocol

**Start of session:**

```
td usage --new-session
```

Read the output carefully — it contains open issues, recent activity, and pending handoffs from prior sessions. Use `td usage -q` for subsequent reads within the same session.

**End of session:** Create a handoff for every in-progress issue before the session ends (see Handoff Protocol below).

## Core Workflow

The issue lifecycle flows: **open** → **in_progress** → **in_review** → **closed** (with **blocked** as an alternate state).

### 1. Create

```
td create "Description" --type <type> --priority <priority>
```

Types: `bug`, `feature`, `task`, `epic`, `chore`. Priority: `P0` (critical) through `P4` (lowest), defaults to `P2`.

### 2. Start

```
td start <issue-id>       # Transition to in_progress
td next                   # Show highest-priority open issue
td focus <issue-id>       # Track focus without status change
```

### 3. Log Progress

Log work continuously as you make progress. Use metadata flags to categorize entries:

```
td log "What you accomplished"
td log --decision "Why you chose this approach"
td log --blocker "What's preventing progress"
td log --hypothesis "What you think might be true"
td log --tried "What you attempted and why it didn't work"
td log --result "Measurable outcome or benchmark"
```

**When to use each flag:**
- `--decision` — Record rationale whenever you choose between alternatives
- `--blocker` — Flag immediately when progress stalls; include what's needed to unblock
- `--hypothesis` — Before investigating, state what you expect to find
- `--tried` — After a failed approach, document it to prevent rework in future sessions
- `--result` — After testing or benchmarking, capture the data

### 4. Handoff

Create a structured handoff to transfer context to the next session:

```
td handoff <issue-id> \
  --done "Completed work" \
  --remaining "Outstanding tasks" \
  --decision "Key choices and rationale" \
  --uncertain "Unresolved questions"
```

All four fields matter:
- `--done` — What was completed (be specific, not "made progress")
- `--remaining` — Concrete next steps, not vague descriptions
- `--decision` — Choices made and why, so the next session doesn't revisit them
- `--uncertain` — Open questions that need investigation or user input

### 5. Review

```
td review <issue-id>                          # Submit for review
td reviewable                                 # List reviewable issues
td approve <issue-id>                         # Close the issue
td reject <issue-id> --reason "Explanation"   # Return to in_progress
```

Session isolation: the session that did the work cannot approve it.

## Dependencies & Parallelization

Model work as a dependency graph to identify what can run in parallel vs. what must be sequential.

```
td dep add <issue> <blocker>   # issue depends on blocker (blocker must finish first)
td dep <issue>                 # Show what blocks this issue
td critical-path               # Optimal sequence to unblock the most work
```

**Before starting work**, run `td critical-path` to see:
- **Critical path sequence** — Tasks ranked by how many downstream issues they unblock
- **Start now** — Unblocked work ready for parallel execution
- **Bottlenecks** — Tasks blocking the most issues (prioritize these)

When a blocking issue is approved/closed, its dependents auto-unblock (only when all their dependencies are satisfied). This cascades through epic hierarchies.

Use `td block <issue>` / `td unblock <issue>` to manually manage blocked state when external factors (not task dependencies) prevent progress.

## Boards

Organize issues into query-based views:

```
td board create "Name" --query "priority <= P1"
td board show <board-slug>
```

## References

- **[Full command reference](references/commands.md)** — All commands, subcommands, and flags
- **[Query language (TDQ)](references/query-language.md)** — Filtering syntax for `td query` and boards
