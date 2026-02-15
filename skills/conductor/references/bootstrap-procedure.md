# Bootstrap Procedure — `/conduct:bootstrap <change-name>`

Imports an OpenSpec change's tasks into Beads as a dependency-aware task graph. Interactive — always preview before creating.

## Prerequisites

- OpenSpec change exists at `openspec/changes/<change-name>/` with a `tasks.md`
- Beads is initialized (`bd init` has been run)
- Tasks in `tasks.md` use numbered or hierarchical checkbox format

## Step 1: Parse

Read `openspec/changes/<change-name>/tasks.md` and extract the task structure.

**Expected format in tasks.md:**
```markdown
## Tasks

- [ ] 1. Set up database schema
  - [ ] 1.1. Create users table migration
  - [ ] 1.2. Create sessions table migration
- [ ] 2. Implement authentication API
  - [ ] 2.1. POST /auth/login endpoint
  - [ ] 2.2. POST /auth/logout endpoint
- [ ] 3. Build login UI
- [ ] 4. Write integration tests
```

Extract: task number, title, hierarchy (top-level = task, indented = subtask), and any explicit dependency markers.

## Step 2: Preview

Display parsed tasks with inferred dependencies for user review:

```
Epic: <change-name> (priority 2)

Tasks:
  1. Set up database schema (priority 1)
     1.1. Create users table migration (priority 1)
     1.2. Create sessions table migration (priority 1)
  2. Implement authentication API (priority 1)
     2.1. POST /auth/login endpoint (priority 1)
     2.2. POST /auth/logout endpoint (priority 1)
  3. Build login UI (priority 1)
  4. Write integration tests (priority 1)

Inferred dependencies:
  - Task 2 depends on Task 1 (schema → query rule)
  - Task 3 depends on Task 2 (API → UI rule)
  - Task 4 depends on Tasks 2, 3 (impl → test rule)
  - Subtask 1.2 depends on 1.1 (same-file: migrations)

Dependency rules applied: schema→query, API→UI, impl→test, same-file
```

**Ask the user to review and confirm.** They can:
- Reorder tasks
- Add or remove dependencies
- Change priorities
- Skip tasks they don't want in Beads

## Step 3: Create

After user approval, create the Beads entries:

```bash
# 1. Create the epic
bd create "<change-name>" -t epic -p 2
# Returns: bd-XXXX

# 2. Create top-level tasks as children of the epic
bd create "<task title>" -p 1 --parent bd-XXXX
# Returns: bd-XXXX.1, bd-XXXX.2, etc.

# 3. Create subtasks as children of their parent task
bd create "<subtask title>" -p 1 --parent bd-XXXX.1
# Returns: bd-XXXX.1.1, bd-XXXX.1.2, etc.

# 4. Wire dependencies
bd dep add bd-XXXX.2 bd-XXXX.1    # Task 2 depends on Task 1
bd dep add bd-XXXX.3 bd-XXXX.2    # Task 3 depends on Task 2
bd dep add bd-XXXX.4 bd-XXXX.2    # Task 4 depends on Task 2
bd dep add bd-XXXX.4 bd-XXXX.3    # Task 4 depends on Task 3
```

## Step 4: Stamp

Write bead IDs back into `tasks.md` so both systems stay linked:

**Before:**
```markdown
- [ ] 1. Set up database schema
```

**After:**
```markdown
- [ ] 1. (bd-a3f8.1) Set up database schema
```

Commit the stamped tasks.md:
```bash
git add openspec/changes/<change-name>/tasks.md
git commit -m "conduct: bootstrap <change-name> into beads"
```

## Dependency Inference Rules

Apply these rules in order when inferring dependencies between tasks. These come from the Beads OpenSpec integration guide:

1. **Schema → Query** — Schema/migration tasks block everything that queries those tables
2. **API → UI** — API endpoint tasks block UI tasks that call them
3. **Config → Dependent** — Config/setup tasks block tasks that use that config
4. **Implementation → Test** — Implementation tasks block their corresponding test tasks
5. **Same-file** — If two tasks modify the same file, make them sequential

**Heuristics for detecting rule applicability:**
- Task titles containing "schema", "migration", "database", "model" → likely schema tasks
- Task titles containing "API", "endpoint", "route", "handler" → likely API tasks
- Task titles containing "UI", "component", "page", "view", "form" → likely UI tasks
- Task titles containing "test", "spec", "e2e" → likely test tasks
- Task titles containing "config", "setup", "init", "env" → likely config tasks
- When in doubt, ask the user during preview

## Edge Cases

- **No tasks.md found** — Error with message suggesting to run `/opsx:ff` first
- **Tasks already have bead IDs** — Warn that this change appears already bootstrapped; offer to skip stamped tasks or re-bootstrap from scratch
- **Empty task list** — Error with message that there are no tasks to import
- **Nested subtasks (3+ levels)** — Flatten to two levels (task + subtask) since Beads uses hierarchical IDs with max practical depth of 3
