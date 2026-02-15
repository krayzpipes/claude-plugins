# Beads Error Recovery

## `bd ready` returns nothing but work remains

```bash
bd list                       # Check if tasks exist
bd list --status blocked      # Check if everything is blocked
bd dep tree <epic-id>         # Visualize — look for circular deps or tasks blocked by closed items
```

## Wrong dependencies were created

```bash
bd dep remove <child> <parent>   # Unwire incorrect edge
bd dep add <child> <parent>      # Wire correct edge
bd ready                          # Verify new ordering
```

## Task was closed prematurely

```bash
bd update <id> --status open     # Reopen the task
bd update <id> --notes "Reopened: <reason>"
```

## Beads and tasks.md are out of sync

1. Run `bd list --json` and compare against tasks.md checkboxes
2. Close any Beads tasks that are checked off in tasks.md but still open
3. Add any tasks that exist in tasks.md but not in Beads
4. Source of truth for scope: tasks.md. Source of truth for execution state: Beads.

## Database issues

```bash
bd doctor                                    # Health check
bd import -i .beads/issues.jsonl             # Rebuild cache from JSONL
```
