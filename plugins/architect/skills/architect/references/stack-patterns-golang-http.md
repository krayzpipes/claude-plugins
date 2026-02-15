# Stack Patterns: Go HTTP Service

Decomposition patterns for Go HTTP services using the standard library or lightweight routers (chi, gorilla/mux, echo).

## Typical Layer Mapping

| Layer | Go Equivalent | Common Paths |
|-------|--------------|--------------|
| Config | Env parsing, config struct | `internal/config/` |
| Schema/Data | Domain models, value objects | `internal/models/`, `internal/domain/` |
| Data Access | SQL migrations | `migrations/` |
| Repository | Database queries, interfaces | `internal/repo/`, `internal/storage/` |
| Service | Business logic, orchestration | `internal/service/` |
| API | HTTP handlers, request/response types | `internal/handler/`, `internal/api/` |
| Integration | Router setup, middleware, DI wiring | `cmd/server/main.go`, `internal/middleware/` |
| Testing | Table-driven tests | `*_test.go` (co-located) |

## Decomposition Order

### 1. Models first, one per domain concept
Each domain struct is a separate task. Include JSON struct tags and any validation methods.

```markdown
## 1. Models
- [ ] 1.1 Create User model with ID, email, timestamps (internal/models/user.go)
- [ ] 1.2 Create Post model with ID, user_id, title, body (internal/models/post.go)
```

### 2. Repository interfaces before implementations
Define the interface in the consumer's package, then implement it.

```markdown
## 2. Repository
- [ ] 2.1 Define UserRepository interface in service package
- [ ] 2.2 Implement PostgresUserRepository (internal/repo/user_postgres.go)
- [ ] 2.3 Define PostRepository interface in service package
- [ ] 2.4 Implement PostgresPostRepository (internal/repo/post_postgres.go)
```

### 3. Services before handlers
Services contain business logic. Handlers are thin HTTP adapters.

```markdown
## 3. Services
- [ ] 3.1 Create UserService with Register(), GetByID() (internal/service/user.go)
- [ ] 3.2 Create PostService with Create(), List(), GetByID() (internal/service/post.go)

## 4. Handlers
- [ ] 4.1 Create request/response types for User endpoints (internal/handler/user_types.go)
- [ ] 4.2 Create UserHandler with POST /users, GET /users/{id} (internal/handler/user.go)
- [ ] 4.3 Create request/response types for Post endpoints (internal/handler/post_types.go)
- [ ] 4.4 Create PostHandler with POST /posts, GET /posts (internal/handler/post.go)
```

### 4. Router and middleware last
Wire everything together in the entrypoint after all handlers exist.

```markdown
## 5. Wiring
- [ ] 5.1 Create router with route registration (cmd/server/routes.go)
- [ ] 5.2 Add logging middleware (internal/middleware/logging.go)
- [ ] 5.3 Add auth middleware (internal/middleware/auth.go)
- [ ] 5.4 Wire dependencies in main.go (cmd/server/main.go)
```

### 5. Tests co-located with source
Test files sit next to the code they test. One test file per source file.

```markdown
## 6. Testing
- [ ] 6.1 Table-driven tests for UserService (internal/service/user_test.go)
- [ ] 6.2 Table-driven tests for PostService (internal/service/post_test.go)
- [ ] 6.3 HTTP tests for UserHandler (internal/handler/user_test.go)
- [ ] 6.4 HTTP tests for PostHandler (internal/handler/post_test.go)
```

## Common Pitfalls

- **Don't combine repo interface + implementation in one task** — the interface defines the contract (owned by consumer), the implementation is a separate concern
- **No business logic in handlers** — handlers parse HTTP, call services, write responses. If you see an `if` that isn't about HTTP, it belongs in the service
- **Separate router from handler definitions** — handlers are standalone structs with methods, the router wires them to paths in a central location
- **Don't skip request/response types** — create dedicated types for HTTP payloads, don't reuse domain models directly in handlers

> For Go design constraints (error handling, interfaces, concurrency), see `principles-golang.md`.
