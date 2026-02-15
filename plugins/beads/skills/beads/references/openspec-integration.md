# Beads + OpenSpec Integration

Use both when a feature needs structured planning AND dependency-aware execution. OpenSpec owns **what to build** (specs, proposals, design). Beads owns **what to do next** (dependency graph, execution state).

## The Combined Process

```
Phase 1: Planning (OpenSpec leads)
  /opsx:new <feature>
  /opsx:ff --> produces proposal.md, specs/, design.md, tasks.md
  Human reviews and approves artifacts

Phase 2: Task Import (Bridge to Beads)
  Parse tasks.md --> create Beads epic + tasks with dependencies
  Stamp Beads IDs back into tasks.md

Phase 3: Execution (Beads drives)
  bd ready --> pick task --> implement --> bd close --> check off tasks.md
  Repeat until all tasks done

Phase 4: Finalize (OpenSpec closes)
  /opsx:verify --> validate implementation matches specs
  /opsx:archive --> merge deltas, archive the change
```

## Task Import Procedure

When importing tasks from OpenSpec's tasks.md into Beads:

```bash
# 1. Create the epic, referencing the OpenSpec change name
bd create "Epic: <feature> (openspec: <change-name>)" -t epic -p 0
# Returns: bd-XXXX

# 2. Create each task as a child of the epic
bd create "<task title>" -p <priority> --parent bd-XXXX

# 3. Wire dependencies based on task relationships
bd dep add <child-id> <parent-id>

# 4. Stamp Beads IDs back into tasks.md:
#    BEFORE: - [ ] Set up auth schema
#    AFTER:  - [ ] (bd-x1y2.1) Set up auth schema
```

## Dependency Inference Rules

Apply in order when wiring dependencies:

1. Schema/migration tasks block everything that queries those tables
2. API endpoint tasks block UI tasks that call them
3. Config/setup tasks block tasks that use that config
4. Implementation tasks block their corresponding test tasks
5. If two tasks modify the same file, make them sequential

## Keeping Both in Sync

- **Close in BOTH:** `bd close <id>` and check off `[x]` in `tasks.md`
- **New tasks mid-flight:** Add to both `tasks.md` and Beads, wire dependencies
- **`bd ready` is canonical** for execution order, not the tasks.md list order
- **`tasks.md` is canonical** for scope and requirements
