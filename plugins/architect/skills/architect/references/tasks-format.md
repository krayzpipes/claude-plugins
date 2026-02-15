# Enhanced tasks.md Format

Specification for the annotated tasks.md format produced by `/arch:decompose`. Backward-compatible with Conductor's bootstrap parser.

## Structure

```markdown
# Tasks: <change-name>

## <N>. <Section Title>
<!-- depends-on: <comma-separated section numbers, or "none"> -->
<!-- files: <comma-separated file paths> -->
- [ ] <N.M> <Task description>
- [ ] <N.M> <Task description>
```

## Annotations

### `<!-- depends-on: ... -->`

Declares which sections must be completed before this section can start.

- Placed immediately after the `## N. Title` heading
- Values: comma-separated section numbers, or `none` for root sections
- Conductor uses these directly when present; falls back to title-based heuristics when absent

**Examples:**
```markdown
<!-- depends-on: none -->
<!-- depends-on: 1 -->
<!-- depends-on: 2, 3 -->
```

### `<!-- files: ... -->`

Lists files that tasks in this section will create or modify.

- Placed after `<!-- depends-on -->` (or after heading if depends-on is absent)
- Values: comma-separated relative file paths
- Used by Conductor for same-file conflict detection

**Examples:**
```markdown
<!-- files: src/models/user.py, alembic/versions/001_create_users.py -->
<!-- files: src/api/routes/auth.py -->
```

## Complete Example

```markdown
# Tasks: add-user-auth

## 1. Database Schema
<!-- depends-on: none -->
<!-- files: src/models/user.py, src/models/session.py, alembic/versions/001_create_users.py, alembic/versions/002_create_sessions.py -->
- [ ] 1.1 Create User SQLAlchemy model with email, password_hash, created_at
- [ ] 1.2 Create Session model with user_id, token, expires_at
- [ ] 1.3 Generate Alembic migrations for both models

## 2. Auth Service
<!-- depends-on: 1 -->
<!-- files: src/services/auth_service.py, src/utils/password.py -->
- [ ] 2.1 Create password hashing utility (bcrypt)
- [ ] 2.2 Create AuthService with login(), logout(), validate_token() methods

## 3. API Endpoints
<!-- depends-on: 2 -->
<!-- files: src/api/routes/auth.py, src/api/schemas/auth.py -->
- [ ] 3.1 Create Pydantic request/response schemas for auth endpoints
- [ ] 3.2 Add POST /auth/login endpoint
- [ ] 3.3 Add POST /auth/logout endpoint
- [ ] 3.4 Add auth dependency for protected routes

## 4. Frontend Auth Flow
<!-- depends-on: 3 -->
<!-- files: src/frontend/pages/Login.svelte, src/frontend/stores/auth.ts -->
- [ ] 4.1 Create auth store with login/logout actions
- [ ] 4.2 Create Login page component

## 5. Testing
<!-- depends-on: 2, 3 -->
<!-- files: tests/unit/test_auth_service.py, tests/integration/test_auth_api.py -->
- [ ] 5.1 Unit tests for password hashing utility
- [ ] 5.2 Unit tests for AuthService.login() and .logout() (from REQ-AUTH-001)
- [ ] 5.3 Integration test: login flow returns valid token (from REQ-AUTH-002)
- [ ] 5.4 Integration test: expired token is rejected (from REQ-AUTH-003)
```

## Spec Traceability

When a task implements a specific spec scenario, append a parenthetical reference:

```markdown
- [ ] 5.2 Unit tests for AuthService.login() (from REQ-AUTH-001)
```

The `(from REQ-XXX)` suffix links the task to its originating spec requirement. This is optional but recommended for test tasks.

## Compatibility

- **Conductor bootstrap** parses `## N. Title` headings and `- [ ] N.M` checkboxes — this format preserves both
- **HTML comments** are invisible in rendered markdown and ignored by parsers that don't look for them
- **Without annotations** — Conductor falls back to existing title-based dependency heuristics; no breakage
- **Partial annotations** — Sections with annotations use them; sections without fall back to heuristics
