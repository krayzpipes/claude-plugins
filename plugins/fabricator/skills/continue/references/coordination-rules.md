# Coordination Rules

Rules for avoiding conflicts and maintaining consistency when one or more agents
work through a td task graph.

## Rule 1: One Task, One Agent

Before starting ANY work on a task, you MUST claim it:

```bash
td start <id>
```

Never work on a task another agent has marked `in_progress`.
`td critical-path` only shows unclaimed, unblocked tasks in the START NOW section — trust it.

## Rule 2: Dependency Respect

Only work on tasks where all dependencies are satisfied.
`td critical-path` enforces this automatically — work from its START NOW section.

If a dependency is wrong, remove it and re-evaluate:

```bash
# Check current dependencies
td dep <id>

# The dependency graph may need adjustment as implementation reveals new information
```

## Rule 3: File Conflict Avoidance

If two ready tasks would modify the same files, make them sequential:

```bash
td dep add <task-B-id> <task-A-id>
```

Common conflict patterns: config files, router files, shared components, migration files.

Detect via `<!-- files -->` annotations in tasks.md, or by inspecting task descriptions.

## Rule 4: Blocker Escalation

If blocked by something outside the task graph:

1. Log the blocker immediately:
   ```bash
   td log --blocker "Cannot proceed: <reason>. Need: <what would unblock>"
   ```
2. Mark the issue as blocked:
   ```bash
   td block <id>
   ```
3. Move to next task from `td critical-path`
4. Report blocker in next `/fab:handoff`

When the blocker is resolved:

```bash
td unblock <id>
```

## Rule 5: Progress Logging

Log meaningful progress as you work. Use the right flag for the right context:

```bash
td log "Implemented user model with email validation"
td log --decision "Chose bcrypt over argon2 — wider library support in this stack"
td log --tried "Attempted to use ORM migrations — too rigid for our schema"
td log --result "Auth endpoint responds in <50ms under load test"
td log --hypothesis "The timeout is caused by connection pool exhaustion"
```

## Work Loop

The core implementation cycle for every task:

1. **Find work:** `td critical-path` → pick from START NOW section
2. **Claim:** `td start <id>` (MANDATORY before any implementation)
3. **Implement:** Write code, run tests, commit
4. **Log:** `td log "what was done"` with appropriate flags
5. **Submit:** `td review <id>` when complete
6. **Repeat:** `td critical-path` → next task

## Session Start Protocol — `/fab:continue`

When resuming work in a new session:

1. Run `td usage --new-session` — loads open issues, recent activity, pending handoffs
2. Read any pending handoffs from the previous session
3. Run `td critical-path` — identify unblocked work and bottlenecks
4. Pick highest-priority task from START NOW
5. `td start <id>` → begin work

## Session End Protocol — `/fab:handoff`

Before ending a session:

1. For every in-progress issue, create a structured handoff:
   ```bash
   td handoff <id> \
     --done "What was completed" \
     --remaining "Concrete next steps" \
     --decision "Key choices made and why" \
     --uncertain "Open questions needing investigation"
   ```
2. Submit completed work for review: `td review <id>`
3. Summarize session progress:
   - Tasks completed (submitted for review)
   - Tasks in progress (with handoff created)
   - Blockers encountered
   - Key decisions made

Write handoffs for a future agent with **zero prior context** — be specific, not vague.

## Multi-Agent Coordination

When multiple agents work on the same project:

- **`td start` is the lock** — first agent to start a task owns it
- **`td critical-path` is the planner** — agents independently pick from START NOW
- **No sync needed** — td uses local SQLite, no git conflicts on task state
- **Handoffs transfer context** — `td handoff` ensures the next agent can pick up seamlessly
- **Stale claims** — if an agent is inactive, lead may re-open the task:
  ```bash
  td log "Reclaiming: previous agent inactive"
  ```

## Status Visibility

Use td's built-in tools for progress awareness:

- `td critical-path` — What to work on next, what's blocking progress
- `td query "status = in_progress"` — Active work across all agents
- `td query "status = in_review"` — Completed work awaiting review
- `td board show <board>` — Kanban view of the project
- `td reviewable` — Issues ready for approval
