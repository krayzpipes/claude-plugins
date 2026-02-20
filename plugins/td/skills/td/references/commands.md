# td Command Reference

## Issue Management

### `td create`

Create a new issue.

```
td create "Title" [flags]
```

| Flag | Description | Default |
|------|-------------|---------|
| `--type` | `bug`, `feature`, `task`, `epic`, `chore` | `task` |
| `--priority` | `P0` (critical) through `P4` (lowest) | `P2` |

### `td start <issue-id>`

Transition an issue to `in_progress` status.

### `td next`

Display the highest-priority open issue.

### `td focus <issue-id>`

Track which issue you're working on without changing its status.

## Progress Logging

### `td log`

Log a progress entry against the focused or specified issue.

```
td log "Message" [flags]
```

| Flag | Purpose |
|------|---------|
| `--decision` | Record a choice and its rationale |
| `--blocker` | Flag something preventing progress |
| `--hypothesis` | State an expectation before investigating |
| `--tried` | Document a failed approach |
| `--result` | Capture a measurable outcome |

## Handoffs

### `td handoff <issue-id>`

Create a structured context transfer for the next session.

```
td handoff <issue-id> \
  --done "Completed work" \
  --remaining "Outstanding tasks" \
  --decision "Key choices made" \
  --uncertain "Unresolved questions"
```

| Field | Purpose |
|-------|---------|
| `--done` | Specific completed work items |
| `--remaining` | Concrete next steps |
| `--decision` | Choices and rationale |
| `--uncertain` | Open questions needing investigation |

## Review Workflow

### `td review <issue-id>`

Submit an issue for review (transitions to `in_review`).

### `td reviewable`

List all issues in `in_review` status.

### `td approve <issue-id>`

Close a reviewed issue. Cannot be done by the session that submitted it.

### `td reject <issue-id>`

Return an issue to `in_progress`.

```
td reject <issue-id> --reason "Explanation"
```

## Session Management

### `td usage`

Display current project context: open issues, recent activity, pending handoffs.

| Flag | Description |
|------|-------------|
| `--new-session` | Start a new session and show full context |
| `-q` | Quiet mode — abbreviated output for subsequent reads |

### `td session`

Manage sessions.

```
td session "name"    # Label the current session
td session --new     # Force a new session
```

## Boards

### `td board create`

Create a query-based board.

```
td board create "Name" --query "<TDQ expression>"
```

### `td board list`

List all boards.

### `td board show <board-slug>`

Display a board with its issues organized by status columns.

### `td board move <board-slug> <issue-id> <position>`

Reorder an issue within a board.

### `td board edit <board-slug>`

Update a board's name or query.

```
td board edit <board-slug> --name "New Name" --query "<new query>"
```

### `td board delete <board-slug>`

Delete a board.

## Dependencies

### `td dep add <issue> <blocker>`

Establish that `<issue>` depends on `<blocker>` — the blocker must complete before the issue can proceed.

### `td dep <issue>`

Show what tasks must complete before this issue can start.

```
td dep <issue>               # Show dependencies (what blocks this issue)
td dep <issue> --blocking    # Show what this issue blocks (downstream dependents)
```

### `td blocked-by <issue>`

List all issues currently blocked by the specified issue.

### `td critical-path`

Identify the optimal work sequence using topological sorting weighted by downstream impact. Output includes:

1. **Critical path sequence** — Tasks ranked by how many issues each unblocks
2. **Start now** — Unblocked work ready to begin in parallel
3. **Bottlenecks** — Tasks blocking the most issues

### `td block <issue>`

Manually mark an issue as blocked (for external blockers not modeled as dependencies).

### `td unblock <issue>`

Restore a blocked issue to open state.

### Auto-unblocking

When a blocking issue is approved or closed, dependents automatically transition from blocked to open — but only when **all** their dependencies are satisfied. Cascades through epic hierarchies.

## Querying

### `td query "<TDQ expression>"`

Filter issues using TDQ syntax. See [query-language.md](query-language.md) for full reference.

```
td query "status = open AND priority <= P1"
```

## Issue Lifecycle

```
open → in_progress → in_review → closed
         ↕
       blocked
```
