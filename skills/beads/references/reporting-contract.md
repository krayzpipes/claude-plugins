# Beads Standard Reporting Contract

At the end of every Beads-driven iteration, report status using this structure:

```markdown
Completed
- <major result 1>
- <major result 2>
- Key task status updates:
  - <issue-id> -> in_progress/closed (reason)
  - <issue-id> -> in_progress/closed (reason)

Validation + Git
- <validation command> passed/failed.  # tests/lint/build as applicable
- bd sync completed.
- Commit pushed: <hash>.               # if committed
- Branch is clean and synced with origin/<branch>.  # if pushed

Progress stats
- Active implementation change: <name> = <done>/<total> done (<left> left)
- New planning change: <name> = <done>/<total> done (<left> left)   # include when relevant
- Project-wide (all changes incl. archive): <done>/<total> done (<left> left)
- Current ready Beads tasks: <id>, <id>, <id>
```

## Rules

- Always include `Completed`, `Validation + Git`, and `Progress stats` headings in that order.
- Include Beads issue IDs for every task status transition made this iteration.
- Never claim `bd sync` or push status unless command output confirms success.
- If a step is not applicable, write `N/A` explicitly (do not omit the line).
- Keep the report compact and checklist-like for quick handoff scans.

## Metric Definitions

- **Active implementation change**: Current executing OpenSpec change tied to the active Beads epic.
- **New planning change**: A newly created OpenSpec change in the same session, if any.
- **Project-wide**: All checkbox tasks under `openspec/changes/**/tasks.md` (including archive).
- **Current ready Beads tasks**: From `bd ready`, top ready task IDs in priority order.
