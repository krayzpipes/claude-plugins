# Core Architectural Principles

Universal design constraints the architect applies when decomposing tasks, regardless of language or framework.

## Layer Responsibilities

| Layer | Responsibility | Does NOT Do |
|-------|---------------|-------------|
| API | Serialization, validation, HTTP concerns | Business logic, direct DB access |
| Service | Business logic, orchestration, domain rules | Serialization, HTTP status codes |
| Data | Backend communication, persistence, queries | Business rules, request parsing |

Tasks must respect these boundaries. If a task description mixes concerns across layers, split it.

## Design Patterns

- **Composition over inheritance** — Prefer injecting collaborators over extending base classes. Task descriptions should specify constructor parameters, not parent classes.
- **Immutable-first** — Default to immutable data structures. Mutable state requires explicit justification in the design.
- **Protocols for contracts** — Name protocols `CanDoThing` or `HasSomeThing` (e.g., `CanAuthenticate`, `HasPermissions`). Locate the protocol definition in the module that owns the concept, not in a central `interfaces` file.
- **Thin controllers** — API handlers delegate to services immediately. No business logic in route handlers.

## Concurrency

- **Avoid unless needed** — Do not introduce concurrency primitives unless the design explicitly calls for it.
- **Structured concurrency preferred** — When concurrency is needed, prefer structured concurrency (trio) over raw asyncio. Fallback to anyio for library compatibility.
- **Async at the boundary** — Framework-level async (HTTP handlers, DB sessions) is fine. Business logic should be synchronous unless it performs I/O.

## Testing Philosophy

- **Test public API only** — Tests call the same interface external consumers use. No testing private methods or internal state.
- **No monkeypatching** — Compose dependencies via constructor injection. If a test needs a fake, inject it through the constructor, not by patching globals.
- **Resilient to refactoring** — Tests should not break when implementation details change. Assert on behavior and outputs, not on how they were produced.
- **Structured test format** — Use parametrized GIVEN/AND, WHEN, THEN sections. Each spec scenario from OpenSpec maps to at least one test with this structure.
- **Spec-driven coverage** — Every Given/When/Then scenario in specs/ becomes a test task. Security and edge-case scenarios get their own dedicated test tasks.

## Security

- **Always test auth** — Every feature with access control gets explicit auth, authz, and tenancy tests. These are separate tasks, not afterthoughts.
- **Random IDs only** — Use BigInt random, UUID7, or equivalent. Never auto-increment IDs. Task descriptions for models must specify the ID strategy.
- **Injection defense** — Parametrized queries only. No string interpolation for SQL, shell commands, or template rendering.
- **Tenancy isolation** — Multi-tenant systems must include cross-tenant access tests to verify data isolation.

## Data Design

- **Normalize by default** — Fully normalize relational data unless the design documents a strategic reason to denormalize (read-heavy analytics, materialized views).
- **Intentional indexes** — Create indexes based on expected query patterns documented in the design, not speculatively. Each index is a task item.
- **Engine selection** — SQLite or Postgres for OLTP workloads. DuckDB for analytics and batch processing. Task descriptions should note which engine applies.

## Infrastructure

- **K8s/Helm for multi-service** — Multi-service deployments use Kubernetes with Helm charts. Single-service tools may use simpler deployment.
- **Local-first** — Every service must be runnable locally with minimal setup. Docker Compose or equivalent for local multi-service orchestration.
- **Environment parity** — Local, CI, and production environments use the same configuration shape. Differences are limited to values, not structure.
