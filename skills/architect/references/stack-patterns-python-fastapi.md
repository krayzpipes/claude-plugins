# Stack Patterns: Python + FastAPI + SQLAlchemy

Decomposition patterns for projects using FastAPI with SQLAlchemy ORM and Alembic migrations.

## Typical Layer Mapping

| Layer | FastAPI Equivalent | Common Paths |
|-------|--------------------|--------------|
| Config | Settings, .env, app factory | `src/config.py`, `src/app.py` |
| Schema/Data | SQLAlchemy models | `src/models/` |
| Data Access | Alembic migrations | `alembic/versions/` |
| Service | Service classes, business logic | `src/services/` |
| API | FastAPI routers, Pydantic schemas | `src/api/routes/`, `src/api/schemas/` |
| Integration | Dependency injection, middleware | `src/api/deps.py`, `src/middleware/` |
| Testing | pytest tests | `tests/unit/`, `tests/integration/` |

## Decomposition Order

### 1. Models first, one per file
Each SQLAlchemy model is a separate task. If two models have a foreign key relationship, order the parent first.

```markdown
- [ ] 1.1 Create User model (src/models/user.py)
- [ ] 1.2 Create Post model with user_id FK (src/models/post.py)
```

### 2. Migrations after all models
Generate migrations after all models in a section are created. One migration per logical change, not per model.

```markdown
- [ ] 1.3 Generate Alembic migration for User and Post tables
```

### 3. Services before routes
Service methods encapsulate business logic. Routes are thin wrappers.

```markdown
## 2. Services
- [ ] 2.1 Create UserService with create_user(), get_user()
- [ ] 2.2 Create PostService with create_post(), list_posts()

## 3. API
- [ ] 3.1 Create Pydantic schemas for User endpoints
- [ ] 3.2 Create Pydantic schemas for Post endpoints
- [ ] 3.3 Add POST /users and GET /users/{id} routes
- [ ] 3.4 Add POST /posts and GET /posts routes
```

### 4. Dependencies and middleware
FastAPI `Depends()` functions and middleware go in a wiring section after routes exist.

```markdown
## 4. Wiring
- [ ] 4.1 Create get_db dependency for database sessions
- [ ] 4.2 Create get_current_user auth dependency
- [ ] 4.3 Register CORS middleware
```

### 5. Tests mirror implementation layers
One test file per service or route module. Map spec scenarios to test functions.

```markdown
## 5. Testing
- [ ] 5.1 Unit tests for UserService
- [ ] 5.2 Unit tests for PostService
- [ ] 5.3 Integration tests for /users endpoints
- [ ] 5.4 Integration tests for /posts endpoints
```

## Common Pitfalls

- **Don't combine model + migration in one task** — model creation and `alembic revision --autogenerate` are separate actions
- **Don't put Pydantic schemas with routes** — schemas are reusable; create them first, then routes that use them
- **Separate config from app factory** — config (reading env vars) and app setup (creating FastAPI instance) are distinct tasks

> For Python design constraints (immutability, testing, type contracts), see `principles-python.md`.
