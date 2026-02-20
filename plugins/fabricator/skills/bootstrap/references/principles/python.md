# Python Architectural Principles

Python-specific technology choices and patterns. Apply these alongside `principles-core.md` for any Python project.

## Immutability

- **`attrs.frozen` by default** — All domain objects and value types use `@attrs.frozen`. Task descriptions for model/data classes must specify `attrs.frozen`.
- **Frozen dataclasses as fallback** — When attrs is unavailable or impractical (e.g., simple config structs), use `@dataclass(frozen=True)`.
- **No mutable default arguments** — Use `attrs.Factory` or `field(default_factory=...)` for collection defaults.

## Serialization

- **Pydantic for API boundaries** — FastAPI request/response schemas use Pydantic `BaseModel`. These are distinct from domain objects.
- **Separate schema from domain** — Pydantic schemas live in API layer (`schemas/`). Domain objects use attrs. Conversion between them is explicit.

## ORM and Database

- **SQLAlchemy for queries** — Use SQLAlchemy 2.0 style with `select()` statements. No legacy Query API.
- **Alembic for migrations** — All schema changes go through Alembic. One migration per logical change, generated after models are complete.
- **Mapped classes** — SQLAlchemy models use `DeclarativeBase` with `Mapped[]` type annotations. These are persistence models, separate from domain attrs classes.

## Type Contracts

- **Python protocols for interfaces** — Use `typing.Protocol` to define contracts between layers. No ABCs unless a shared implementation is needed.
- **Protocols near their owner** — A protocol lives in the module of the concept it defines, not in a central `interfaces.py` or `protocols.py`. For example, `CanAuthenticate` lives in the auth module.
- **Runtime checkable when tested** — Add `@runtime_checkable` to protocols that appear in isinstance checks or test assertions.

## Concurrency

- **trio preferred** — For async beyond framework handlers, use trio for structured concurrency.
- **anyio as fallback** — When trio is not viable (library compatibility), use anyio to remain runtime-agnostic.
- **Async for I/O boundaries** — FastAPI route handlers and SQLAlchemy async sessions use async. Service-layer business logic stays synchronous unless it directly performs I/O.

## Testing

- **pytest** — All tests use pytest. No unittest.TestCase subclasses.
- **Parametrized fixtures** — Use `@pytest.mark.parametrize` for GIVEN/AND variations. Shared setup goes in conftest.py fixtures.
- **Constructor injection for fakes** — Services accept dependencies as constructor arguments. Tests pass fakes/stubs through the constructor. No `monkeypatch`, no `unittest.mock.patch`.
- **Factory patterns for test data** — Use factory functions or factory-boy for creating test objects. No raw dict literals for complex test data.
