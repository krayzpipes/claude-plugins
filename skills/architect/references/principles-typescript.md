# TypeScript Architectural Principles

TypeScript-specific technology choices and patterns. Apply these alongside `principles-core.md` for any TypeScript project.

## Type System

- **`strict: true` always** — Enable all strict checks in `tsconfig.json`. No exceptions.
- **No `any`** — Use `unknown` when the type is genuinely uncertain. Narrow with type guards, never cast blindly.
- **Explicit return types on public APIs** — Exported functions and methods declare return types. Internal helpers may rely on inference.

## Immutability

- **`readonly` by default** — Object properties, array parameters, and function arguments use `readonly` unless mutation is required.
- **`as const` for literals** — Use `as const` for config objects, enums-as-objects, and discriminant values.
- **`const` over `let`** — Only use `let` when reassignment is unavoidable. Never use `var`.

## Serialization and Validation

- **Zod at boundaries** — Use Zod schemas for runtime validation of external input (API responses, form data, env vars).
- **Separate validation from domain** — Zod schemas live at the boundary layer. Domain types are plain TypeScript interfaces, not coupled to Zod.
- **Infer types from schemas** — Use `z.infer<typeof Schema>` to derive TypeScript types from Zod schemas, keeping types and validation in sync.

## Type Contracts

- **Branded types for domain IDs** — Use branded/opaque types (`type UserId = string & { readonly __brand: 'UserId' }`) to prevent ID mixups between entities.
- **Discriminated unions for ADTs** — Model state machines and variants with discriminated unions on a `type` or `kind` field.
- **`interface` for shapes, `type` for unions** — Use `interface` for object contracts (extendable). Use `type` for unions, intersections, and mapped types.

## Error Handling

- **Result types for expected errors** — Use a `Result<T, E>` pattern (or neverthrow) for operations with known failure modes. Reserve exceptions for truly unexpected errors.
- **Exhaustive switch** — Use `never` in default cases to catch unhandled discriminated union variants at compile time.

## Null Safety

- **`strictNullChecks` enabled** — Always on (implied by `strict: true`). Handle `null` and `undefined` explicitly.
- **Prefer `undefined` for optional** — Use `undefined` (via optional properties `?:`) over `null` for absent values. Use `null` only when it has distinct domain meaning.
- **No non-null assertions** — Never use `!` postfix. Narrow types with guards or provide defaults instead.

## Testing

- **Vitest preferred** — Use Vitest for unit and integration tests. Compatible with Jest API but faster.
- **Factory functions for test data** — Create typed factory functions that return valid domain objects with sensible defaults and optional overrides.
- **Constructor injection** — Pass dependencies as constructor or function arguments. No module-level mocking (`vi.mock`) except for truly external modules.
