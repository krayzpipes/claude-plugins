# Roles and Session Protocol

Conductor defines three roles for agents working through a Beads task graph. In practice, a solo agent switches between lead and worker behavior within a single session.

## Roles

### Lead

The lead reviews overall progress, decides priorities, and manages session transitions.

**Responsibilities:**
- Review project state at session start (`bd ready`, `/conduct:report`)
- Decide which tasks to prioritize next
- Generate handoff summaries at session end
- Add dependencies if file conflicts are discovered
- Escalate blockers that need human input

### Worker

The worker claims and implements individual tasks.

**Responsibilities:**
- Claim a task: `bd update <id> --status in_progress`
- Implement the task fully (code, test, commit)
- Close with meaningful reason: `bd close <id> --reason "..."`
- Reference bead ID in commits: `bd-XXXX: description`
- Update task notes if interrupted before completion

### Solo (Default)

A solo agent acts as both lead and worker. Use lead behavior at session boundaries, worker behavior during implementation.

```
Session start  →  Lead hat   →  bd ready, /conduct:report, pick task
Implementation →  Worker hat →  claim, implement, close, repeat
Session end    →  Lead hat   →  notes, handoff, sync
```

## Session Start Protocol

Run these steps at the beginning of every session:

```
1. bd ready                         → See unblocked tasks
2. If resuming a project:
   a. /conduct:report               → Understand overall state
   b. bd show <last-in-progress>    → Read notes from previous session
3. Pick highest-priority unblocked task
4. bd update <id> --status in_progress → Claim it
```

**If `bd ready` returns nothing:**
- Run `bd list` to check if all tasks are closed (project may be done)
- Run `bd dep tree <epic-id>` to check for dependency deadlocks
- Check if tasks are blocked by unclosed dependencies

## Session Work Loop

```
1. Implement the claimed task
2. Test the implementation
3. git commit -m "bd-XXXX: <description>"
4. bd close <id> --reason "Completed: <summary of what was done>"
5. bd ready → pick next task
6. bd update <id> --status in_progress
7. Repeat from 1
```

## Session End Protocol

Run these steps before ending a session:

```
1. For any in-progress tasks:
   a. Write notes for the next agent (assume zero context):
      - What was completed so far
      - Current state of the implementation
      - What needs to happen next
      - Any decisions made and why
   b. bd update <id> --notes "<handoff notes>"

2. Close all fully completed tasks:
   bd close <id> --reason "Completed: <what was done>"

3. Sync and commit:
   bd sync
   git add .beads/ && git commit -m "beads: sync state"

4. Generate handoff:
   /conduct:handoff
```

## `/conduct:handoff` Format

The handoff produces a structured summary for the next session:

```markdown
## Session Handoff

### Completed This Session
- bd-XXXX.1: <task title> — <what was done>
- bd-XXXX.2: <task title> — <what was done>

### In Progress
- bd-XXXX.3: <task title> — <current state, what remains>

### Blocked
- bd-XXXX.4: <task title> — <why it's blocked, what would unblock it>

### Next Session Should
1. <highest priority action>
2. <second priority action>
3. <third priority action>

### Ready Tasks
<output of bd ready>
```

After generating the handoff, sync and commit:
```bash
bd sync
git add .beads/
git commit -m "beads: session handoff"
```

## Multi-Agent Sessions

When multiple agents work on the same project:

- Each agent follows the same session start/end protocol
- `bd update --status in_progress` acts as a claim lock — other agents see it via `bd ready`
- Agents must `bd sync` before checking `bd ready` to see latest state
- If an agent finds a task already claimed, it moves to the next ready task
- Git pull/push between agents to share Beads state via `.beads/issues.jsonl`
