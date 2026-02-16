# Coordination Rules

Rules for avoiding conflicts and maintaining consistency when one or more agents work through a Beads task graph.

## Rule 1: One Task, One Agent

**Before starting ANY work on a task, you MUST claim it:**
```bash
bd update <id> --status in_progress
```

Never work on a task another agent has marked `in_progress`. Never start implementing without claiming first. `bd ready` only shows unclaimed, unblocked tasks — trust it.

**How to check:** If a task you wanted is missing from `bd ready`, run `bd show <id>` to check its status.

**If you need that task's output:** Work on a different unblocked task. The dependency graph ensures you won't be assigned work that depends on incomplete tasks.

## Rule 2: Dependency Respect

Only work on tasks where all dependencies are `closed`.

**How it works:** `bd ready` enforces this automatically — it filters to tasks with no open blockers. Trust `bd ready` as the source of truth for what's available.

**If you think a dependency is wrong:** Don't skip it. Instead, update the dependency graph:
```bash
bd dep remove <child-id> <incorrect-parent-id>
```

## Rule 3: File Conflict Avoidance

If two ready tasks would modify the same files, they should be made sequential.

**When discovering a conflict:**
```bash
# Make task B depend on task A (so A runs first)
bd dep add <task-B-id> <task-A-id>
```

**Common conflict patterns:**
- Two tasks both modifying a config file
- Two tasks adding routes to the same router file
- Two tasks editing the same component

**During bootstrap:** The dependency inference rules catch most of these. During execution, agents should add dependencies when they discover new conflicts.

## Rule 4: Blocker Escalation

If a task is blocked by something outside the task graph (missing information, broken dependency, unclear requirement):

1. Update the task with blocker details:
   ```bash
   bd update <id> --notes "BLOCKED: <reason>. Need: <what would unblock>"
   ```
2. Do NOT close the task — leave it `in_progress` or set back to `open`
3. Move to the next `bd ready` task
4. Report the blocker in your next `/conduct:report` or `/conduct:handoff`

## Rule 5: Commit Convention

All commits that implement task work must reference the bead ID:

```
bd-XXXX: Short description of what was done

Longer description if needed.
```

This creates a traceable link between git history and the Beads task graph.

**Multiple tasks in one commit** (if changes are tightly coupled):
```
bd-XXXX, bd-YYYY: Description covering both tasks
```

## Conflict Resolution

### Git Conflicts in `.beads/issues.jsonl`

If two agents commit Beads state simultaneously:

1. Pull the latest: `git pull`
2. If conflicts in `issues.jsonl`, keep both sets of changes (it's append-only JSONL)
3. Run `bd sync` to rebuild the database from the merged JSONL
4. Commit the merge

### Task Claim Race Condition

If two agents try to claim the same task:

1. The first `bd sync` + push wins
2. The second agent sees the task as `in_progress` after pulling
3. Second agent moves to next `bd ready` task
4. No special resolution needed — the protocol handles this naturally

### Stale Claims

If a task has been `in_progress` for an unusually long time with no commits:

1. Check the task notes: `bd show <id>`
2. If notes indicate the claiming agent is still working, wait
3. If no recent activity, the lead agent may reassign:
   ```bash
   bd update <id> --status open --notes "Reclaimed: previous agent inactive"
   ```

## `/conduct:report` Format

Progress reports use the Beads reporting contract with conductor context:

```markdown
## Conductor Report: <change-name>

### Completed
- bd-XXXX.1: <task title> — closed
- bd-XXXX.2: <task title> — closed

### In Progress
- bd-XXXX.3: <task title> — <agent/session if known>

### Blocked
- bd-XXXX.4: <task title> — <blocker reason>

### Ready (next up)
- bd-XXXX.5: <task title> (priority 1)
- bd-XXXX.6: <task title> (priority 1)

### Progress
- Epic: <done>/<total> tasks closed
- Blocked: <count>
- Dependencies remaining: <count of unclosed deps>
```

Generate this by combining:
- `bd list --json` for task states
- `bd ready --json` for next tasks
- `bd dep tree <epic-id>` for dependency overview
