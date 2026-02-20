# Planning Procedures — `/fab:sketch` and `/fab:plan`

Both commands produce the same OpenSpec artifacts. They differ in pacing: sketch generates everything at once, plan iterates through each stage with review pauses.

After either command completes, review the artifacts and run `/fab:bootstrap <name>`.

## `/fab:sketch <name>` — Fast Path

Use when requirements are clear and you know what you want.

### Procedure

1. **Check for existing change:**
   - Look for `openspec/changes/<name>/`
   - If it exists with artifacts already present, report what's there and ask whether to continue or start fresh

2. **Create change folder:**
   - If no change exists, run `/opsx:new <name>` to scaffold the change directory

3. **Generate all artifacts:**
   - Run `/opsx:ff <name>` to fast-forward through all planning stages
   - This produces: proposal, specs, design, and tasks in one pass

4. **Present summary:**
   - List the artifacts that were generated
   - Show a brief summary of the proposal and task count

5. **Pause for review:**
   - Direct the user to review artifacts in `openspec/changes/<name>/`
   - When satisfied, run `/fab:bootstrap <name>` to decompose and create the task graph

## `/fab:plan <name>` — Deliberate Path

Use when requirements are ambiguous, the domain is unfamiliar, or each stage needs careful review.

### Procedure

1. **Check for existing change:**
   - Look for `openspec/changes/<name>/`
   - If it exists, determine which stage was last completed and resume from the next stage

2. **Create change folder:**
   - If no change exists, run `/opsx:new <name>` to scaffold the change directory

3. **Iterate through stages:**
   - Run `/opsx:continue <name>` to generate the next artifact
   - Present the artifact for review
   - Wait for user feedback before proceeding
   - Repeat until all stages are complete

   The stages in order:
   - **Proposal** — Problem statement, goals, scope, constraints
   - **Specs** — Detailed functional and technical specifications
   - **Design** — Architecture, component design, interfaces
   - **Tasks** — Implementation task breakdown

4. **Pause after final stage:**
   - Confirm all planning artifacts are complete
   - Direct the user to run `/fab:bootstrap <name>` when ready

### Resuming a Partial Plan

If planning was interrupted, `/fab:plan <name>` picks up where it left off. It checks which artifacts exist and runs `/opsx:continue` for the next missing stage.

## When to Use Sketch vs Plan

| Factor | Sketch | Plan |
|--------|--------|------|
| Requirements | Clear, well-defined | Ambiguous, evolving |
| Domain | Well-understood, standard patterns | New, unfamiliar |
| Scope | Small to medium | Large, multi-system |
| Review needs | Review once at the end | Review each stage |
| Speed | Fast — one pass | Slower — iterative |
| Best for | Features you've built before | Exploratory or high-stakes work |

**Default to sketch.** Use plan when you need to think carefully at each stage or when requirements might change based on what you learn during planning.

## Artifacts Produced

Both commands produce the same set of artifacts in `openspec/changes/<name>/`:

- `proposal.md` — Problem statement, goals, scope, success criteria
- `specs/` — Detailed specifications (functional, technical, API contracts)
- `design.md` — Architecture decisions, component design, interfaces
- `tasks.md` — Implementation task breakdown (pre-architect refinement)

After `/fab:bootstrap`, the architect refines `tasks.md` with dependency and file annotations, then tasks are imported into td.
