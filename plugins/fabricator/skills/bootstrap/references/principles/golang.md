# Go Architectural Principles

Go-specific technology choices and patterns. Apply these alongside `principles-core.md` for any Go project.

## Value Semantics

- **Prefer values over pointers** — Use value types by default. Pass pointers only when mutation is required or structs are large (>64 bytes as a guideline).
- **Struct copying for updates** — Create modified copies rather than mutating in place. Go makes struct copying cheap.
- **Pointer receivers only for mutation** — Methods that don't mutate state use value receivers. Pointer receivers signal "this method changes the struct."

## Error Handling

- **Return `error` last** — Functions that can fail return `(result, error)`. The error is always the last return value.
- **Wrap with `%w`** — Use `fmt.Errorf("context: %w", err)` to add context while preserving the error chain for `errors.Is` and `errors.As`.
- **Check all errors** — Every returned error must be checked. No blank-identifier discards (`_ = err`) unless explicitly justified.
- **No panic in library code** — `panic` is reserved for truly unrecoverable states in `main`. Libraries return errors.

## Interfaces

- **Define at the consumer** — Interfaces belong in the package that uses them, not the package that implements them.
- **Keep small** — 1-3 methods per interface. Compose larger contracts from smaller interfaces via embedding.
- **Implicit satisfaction** — No `implements` keyword. If a struct has the methods, it satisfies the interface. Design APIs around this.

## Serialization

- **Struct tags for JSON** — Use `json:"field_name"` struct tags. Keep API-facing structs separate from domain models.
- **Separate API structs from domain** — Request/response types live near handlers. Domain types live in their own package. Conversion between them is explicit.

## Concurrency

- **Goroutines + channels** — Use goroutines for concurrent work and channels for communication. Prefer channels over shared memory with mutexes.
- **`context.Context` for cancellation** — Pass `context.Context` as the first parameter to functions that do I/O or long-running work.
- **`errgroup` for structured concurrency** — Use `golang.org/x/sync/errgroup` to manage groups of goroutines with error propagation and cancellation.

## Package Structure

- **Flat layout** — Avoid deep nesting. A small-to-medium service can be a single package or a handful of top-level packages.
- **Group by domain, not layer** — Prefer `user/`, `order/` over `models/`, `handlers/`, `services/`. Layers within a domain package are just files.
- **Avoid circular dependencies** — If two packages import each other, extract the shared contract into a third package or use interfaces.

## Testing

- **Table-driven tests** — Use `[]struct{ name string; ... }` slices with `t.Run(tc.name, ...)` for variations of the same behavior.
- **Constructor injection** — Accept interfaces in constructors. Tests pass fake implementations. No `init()` side effects.
- **`testify` for assertions** — Use `require` for fatal checks and `assert` for non-fatal. Keep test helper functions in `_test.go` files.
- **No `init()` in production** — Avoid package-level `init()` functions. They make testing harder and create hidden coupling.
