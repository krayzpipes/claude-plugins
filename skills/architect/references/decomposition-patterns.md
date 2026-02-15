# Decomposition Patterns

Core heuristics for breaking a design into implementation-ready tasks.

## Layer Ordering

Tasks are ordered by architectural layer. Lower layers block higher layers.

| Order | Layer | Examples | Blocks |
|-------|-------|----------|--------|
| 1 | Config/Infrastructure | env vars, docker-compose, CI config | Everything using that config |
| 2 | Schema/Data | DB models, migrations, type definitions | All data access |
| 3 | Repository/Data Access | DAOs, query builders, ORM repositories | Services |
| 4 | Service/Business Logic | domain services, use cases, validators | API layer |
| 5 | API/Interface | routes, controllers, GraphQL resolvers | Frontend |
| 6 | Frontend/UI | components, pages, forms, styles | Integration tests |
| 7 | Integration/Wiring | dependency injection, app bootstrap, middleware registration | End-to-end tests |
| 8 | Testing | unit tests, integration tests, e2e tests | Nothing (leaf nodes) |

**Usage:** Map each item from design.md's "affected files" to a layer. Group by layer. Order groups top-to-bottom.

## Granularity Rules

Each task should satisfy ALL of these:

1. **1-3 files** — A task touching 4+ files is too broad; split by file or concern
2. **No design decisions** — If a task requires choosing between approaches, that choice belongs in design.md
3. **Clear done signal** — One of: file exists, test passes, endpoint responds, migration runs
4. **Atomic action** — If the description uses "and" to join unrelated actions, split into separate tasks
5. **Spec coverage** — Each Given/When/Then scenario from specs/ maps to at least one test task

## Dependency Detection Heuristics

When assigning `<!-- depends-on -->` annotations:

### Explicit signals (prefer these)
- Design.md states "X requires Y to be in place first"
- A file import chain: if task B creates a file that imports from task A's file, B depends on A
- Migration ordering: later migrations depend on earlier ones

### Implicit signals (use when explicit signals absent)
- **Schema → Query** — Any task that queries/mutates a table depends on the task creating that table
- **Interface → Implementation** — Abstract class/interface tasks block concrete implementation tasks
- **API → Consumer** — API endpoint tasks block frontend tasks calling those endpoints
- **Config → User** — Config/env tasks block tasks reading that configuration
- **Implementation → Test** — Feature tasks block their corresponding test tasks

### Cross-cutting dependencies
- Auth middleware affects all protected routes — place in layer 7 (integration/wiring), make it block API tasks that need auth
- Shared utilities (logging, error handling) — place in layer 1 or 2, block consumers
- Database seeding — depends on all migrations, blocks integration tests

## When Layers Don't Fit

Not every project follows a clean layered architecture. Adaptations:

- **Event-driven systems** — Replace API/UI layers with Publisher/Subscriber layers. Publishers block subscribers.
- **CLI tools** — Replace Frontend with "Command definitions". Replace API with "Command handlers".
- **Library/SDK** — Order: types → core functions → public API → examples → tests
- **Infrastructure-only changes** — Order: base resources → dependent resources → configuration → validation scripts
- **Data pipelines** — Order: source connectors → transformations → sink connectors → orchestration → monitoring

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| "Set up everything" task | Too broad, unclear done signal | Split into one task per config/setup item |
| Test tasks interleaved with implementation | Creates circular dependency risk | Group tests at the end, after all impl tasks |
| "Refactor X and add Y" | Two unrelated actions | Split into separate tasks |
| Task with no files listed | Can't detect same-file conflicts | Always annotate `<!-- files -->` |
| Single task per layer | Too coarse for large layers | Split by domain concern within the layer |
