# TDQ — td Query Language

TDQ is the expression language used by `td query` and board definitions to filter issues.

## Operators

| Operator | Meaning |
|----------|---------|
| `=` | Equals |
| `!=` | Not equals |
| `~` | Contains |
| `!~` | Not contains |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less than or equal |
| `>=` | Greater than or equal |

## Boolean Logic

Combine expressions with `AND`, `OR`, and `NOT`. Use parentheses for precedence. Consecutive expressions without an explicit operator are implicitly `AND`.

```
status = open AND priority <= P1
type = bug OR type = feature
NOT status = closed
(type = bug OR type = feature) AND priority = P0
```

## Queryable Fields

| Field | Values / Type |
|-------|---------------|
| `status` | `open`, `in_progress`, `in_review`, `closed`, `blocked` |
| `type` | `bug`, `feature`, `task`, `epic`, `chore` |
| `priority` | `P0` through `P4` (case-insensitive) |
| `points` | Numeric |
| `labels` | String (use `~` for partial match) |
| `title` | String |
| `description` | String |
| `created` | Timestamp |
| `updated` | Timestamp |
| `closed` | Timestamp |
| `implementer` | String |
| `reviewer` | String |
| `parent` | Issue ID |
| `epic` | Issue ID |

## Date Queries

Use relative durations with `d` (days) or `h` (hours):

```
created >= -7d        # Created in the last 7 days
updated >= -24h       # Updated in the last 24 hours
```

## Built-in Functions

| Function | Description |
|----------|-------------|
| `rework()` | Issues that were rejected and returned to in_progress |
| `stale(N)` | Issues with no activity in N days |

```
td query "stale(14)"           # Inactive for 2 weeks
td query "rework() AND type = bug"
```

## Sorting

Append `sort:field` for ascending or `sort:-field` for descending:

```
td query "status = open sort:priority"
td query "type = bug sort:-created"
```

## Board Integration

Queries persist in board definitions:

```
td board create "Urgent" --query "priority <= P1 AND status != closed"
td board create "Stale" --query "stale(14)"
```
