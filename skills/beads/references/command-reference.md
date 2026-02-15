# Beads Command Reference

Full catalog of `bd` commands with examples.

## Creating Tasks

```bash
bd create "Implement auth middleware" -p 1
bd create "Auth System" -t epic -p 0                     # Epic (parent for subtasks)
bd create "Add rate limiting" -p 2 -n "Use token bucket" # With notes
bd create "Subtask title" -p 1 --parent bd-a3f8          # Child of epic
```

## Dependencies

```bash
bd dep add <child-id> <parent-id>                # B depends on A
bd dep add bd-a1b2 bd-f3g4 --type blocks         # Explicit type
bd dep remove <child-id> <parent-id>             # Unwire
bd dep tree <id>                                 # Visualize DAG
```

## Finding Work

```bash
bd ready                    # Unblocked tasks, sorted by priority
bd list                     # All open tasks
bd list --status blocked    # Only blocked tasks
bd show <id>                # Task details + audit trail
bd search "<partial>"       # Find task by title substring
```

## Working on Tasks

```bash
bd update <id> --status in_progress     # Claim a task
bd update <id> --status open            # Reopen a task
bd update <id> --notes "Progress: ..."  # Record state for future sessions
bd close <id> --reason "Completed"      # Close when done
```

## Hierarchical IDs

```
Epic:     bd-a3f8
Tasks:    bd-a3f8.1, bd-a3f8.2, bd-a3f8.3
Subtasks: bd-a3f8.1.1, bd-a3f8.1.2
```

## JSON Output

All commands support `--json` for structured output:

```bash
bd ready --json
bd list --json
bd show <id> --json
```

## Git Sync

```bash
bd sync              # Sync database <-> JSONL, optional commit
bd doctor            # Health check
bd import -i .beads/issues.jsonl   # Rebuild cache from JSONL
```

Include the Beads ID in commit messages for traceability: `feat: implement JWT middleware (bd-x1y2.2)`

## Concrete Example

```bash
# Create epic + tasks
bd create "Add search feature" -t epic -p 0            # bd-m3n4
bd create "Set up search index" -p 1 --parent bd-m3n4   # bd-m3n4.1
bd create "Build search API endpoint" -p 1 --parent bd-m3n4  # bd-m3n4.2
bd create "Create search UI component" -p 1 --parent bd-m3n4 # bd-m3n4.3
bd create "Add search tests" -p 1 --parent bd-m3n4      # bd-m3n4.4

# Wire dependencies
bd dep add bd-m3n4.2 bd-m3n4.1   # API needs index
bd dep add bd-m3n4.3 bd-m3n4.2   # UI needs API
bd dep add bd-m3n4.4 bd-m3n4.3   # Tests need UI

# Execute
bd ready                          # --> bd-m3n4.1
# ... implement ...
bd close bd-m3n4.1 --reason "Elasticsearch index configured"
git commit -m "Set up search index (bd-m3n4.1)"

bd ready                          # --> bd-m3n4.2 (now unblocked)
```
