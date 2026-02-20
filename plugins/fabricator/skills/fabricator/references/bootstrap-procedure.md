# Bootstrap Procedure — `/fab bootstrap <change-name>`

Imports an OpenSpec change's tasks into td as a dependency-aware task graph.
Interactive — always preview before creating.

## Prerequisites

- OpenSpec change exists at `openspec/changes/<change-name>/` with a `tasks.md`
- td is initialized (`td init` has been run)
- Tasks in `tasks.md` use numbered or hierarchical checkbox format

## Step 0: Decompose (if needed)

Check if `tasks.md` has architect annotations (`<!-- depends-on -->`, `<!-- files -->`).

If annotations are missing or incomplete:

1. **Read inputs** — Load from `openspec/changes/<change-name>/`:
   - `proposal.md` — scope boundaries, what's in/out
   - `specs/` — Given/When/Then scenarios (each maps to test tasks)
   - `design.md` — affected files, architecture, technology choices
   - Scan project source tree for existing patterns and conventions

2. **Identify layers** — Map design.md items to architectural layers using the layer ordering table in **references/decomposition/decomposition-patterns.md**. Apply principles from **references/principles/core.md** and the relevant language-specific principles file.

3. **Decompose into tasks** — Apply granularity rules:
   - Each task touches 1-3 files
   - Each task completable without design decisions (those belong in design.md)
   - Each task has a clear "done" signal (file exists, test passes, endpoint responds)
   - If a task uses "and" to join unrelated actions, split it
   - Each Given/When/Then scenario → at least one test task

4. **Order by dependencies** — Arrange tasks bottom-up: infrastructure → data → services → API → UI → tests. Annotate with `<!-- depends-on -->` and `<!-- files -->` comments.

5. **Write tasks.md** — Output to `openspec/changes/<change-name>/tasks.md` using the format in **references/decomposition/tasks-format.md**.

6. **Present for review** — Show the user the task list with dependency graph before proceeding.

If `tasks.md` already has complete annotations → skip to Step 1.

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

Extract: task number, title, hierarchy (top-level = task, indented = subtask),
and any explicit dependency markers.

**Annotation parsing** (from decomposition):

- `<!-- depends-on: 1, 3 -->` — Explicit dependency declarations. Use directly.
- `<!-- files: src/models/user.py, src/api/routes/auth.py -->` — File annotations for same-file conflict detection.

When annotations are absent, fall back to title-based heuristics (see Dependency Inference Rules below).

## Step 2: Preview

Display parsed tasks with inferred dependencies for user review:

```
Epic: <change-name> (P2)

Tasks:
  1. Set up database schema (P1)
     1.1. Create users table migration (P1)
     1.2. Create sessions table migration (P1)
  2. Implement authentication API (P1)
     2.1. POST /auth/login endpoint (P1)
     2.2. POST /auth/logout endpoint (P1)
  3. Build login UI (P1)
  4. Write integration tests (P1)

Inferred dependencies:
  - Task 2 depends on Task 1 (schema → query rule)
  - Task 3 depends on Task 2 (API → UI rule)
  - Task 4 depends on Tasks 2, 3 (impl → test rule)
  - Subtask 1.2 depends on 1.1 (same-file: migrations)

Dependency rules applied: schema→query, API→UI, impl→test, same-file
```

Ask user to review and confirm. They can reorder, add/remove dependencies,
change priorities, or skip tasks.

## Step 3: Validate

Before creating td issues, run decomposition quality checks. **Block creation if any check fails.**

1. **Layer ordering** — Tasks follow bottom-up order (infrastructure → data → services → API → UI → tests). No task depends on a later-layer task.
2. **Granularity** — Each task touches 1-3 files. No compound tasks (tasks joined by "and" with unrelated actions).
3. **Dependency completeness** — All dependencies are declared and acyclic. Schema tasks block query tasks, API tasks block UI tasks, implementation tasks block test tasks.
4. **Spec coverage** — Every Given/When/Then scenario in `specs/` maps to at least one test task.
5. **Annotations present** — Every task has `<!-- depends-on -->` and `<!-- files -->` comments.

If checks fail: report findings with specific fix suggestions, return to Step 0 or ask the user to fix tasks.md manually. Do not proceed to Create.

## Step 4: Create

After validation passes and user approval, create td issues and wire dependencies:

```bash
# 1. Create the epic
td create "<change-name>" --type epic --priority P2
# Returns: issue ID (e.g., 1)

# 2. Create tasks
td create "Set up database schema" --priority P1
td create "Implement authentication API" --priority P1
td create "Build login UI" --priority P1
td create "Write integration tests" --priority P1
# Returns: issue IDs (e.g., 2, 3, 4, 5)

# 3. Create subtasks
td create "Create users table migration" --priority P1
td create "Create sessions table migration" --priority P1
td create "POST /auth/login endpoint" --priority P1
td create "POST /auth/logout endpoint" --priority P1
# Returns: issue IDs (e.g., 6, 7, 8, 9)

# 4. Wire dependencies
td dep add 3 2    # Auth API depends on schema
td dep add 4 3    # Login UI depends on auth API
td dep add 5 3    # Tests depend on auth API
td dep add 5 4    # Tests depend on login UI
td dep add 7 6    # Second migration depends on first (same-file)

# 5. Validate the graph
td critical-path
```

## Step 5: Stamp

Write td issue IDs back into tasks.md:

**Before:** `- [ ] 1. Set up database schema`
**After:** `- [ ] 1. (td-2) Set up database schema`

```bash
git add openspec/changes/<change-name>/tasks.md
git commit -m "fab: bootstrap <change-name> into td"
```

## Dependency Inference Rules

Apply in order. Explicit `<!-- depends-on -->` annotations always take priority over heuristics.

### 1. Schema → Query

Schema/migration tasks block everything that queries those tables.

**Triggers:** "schema", "migration", "database", "model", "table"

### 2. API → UI

API endpoint tasks block UI tasks that call them.

**Triggers:** "API", "endpoint", "route", "handler" block "UI", "component", "page", "view", "form"

### 3. Config → Dependent

Config/setup tasks block tasks that use that config.

**Triggers:** "config", "setup", "init", "env", "bootstrap"

### 4. Implementation → Test

Implementation tasks block their corresponding test tasks.

**Triggers:** "test", "spec", "e2e" depend on the feature they test

### 5. Same-file

If two tasks modify the same file (detected via `<!-- files -->` annotations), make them sequential to avoid merge conflicts. Add a dependency from the lower-priority task to the higher-priority one.

## Edge Cases

- **No tasks.md found** — Error suggesting to run `/fab sketch` or `/fab plan` first
- **Tasks already have td IDs** — Warn already bootstrapped; offer to skip or re-bootstrap
- **Empty task list** — Error with guidance
- **Nested subtasks (3+ levels)** — Flatten to two levels (task + subtask)
- **Circular dependencies detected** — Error and ask user to resolve before creating
