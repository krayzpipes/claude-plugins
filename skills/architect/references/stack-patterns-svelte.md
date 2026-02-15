# Stack Patterns: SvelteKit

Decomposition patterns for projects using SvelteKit with component-based architecture.

## Typical Layer Mapping

| Layer | SvelteKit Equivalent | Common Paths |
|-------|---------------------|--------------|
| Config | svelte.config.js, env, adapters | `svelte.config.js`, `src/lib/config.ts` |
| Schema/Data | TypeScript types, Zod schemas | `src/lib/types/`, `src/lib/schemas/` |
| Data Access | API client, fetch wrappers | `src/lib/api/` |
| Service | Stores, business logic | `src/lib/stores/`, `src/lib/utils/` |
| API | Server routes, form actions | `src/routes/**/+server.ts`, `+page.server.ts` |
| Frontend/UI | Pages, components, layouts | `src/routes/**/+page.svelte`, `src/lib/components/` |
| Testing | Vitest, Playwright | `tests/`, `e2e/` |

## Decomposition Order

### 1. Types and schemas first
Shared TypeScript interfaces and Zod validation schemas are the foundation.

```markdown
## 1. Types & Schemas
- [ ] 1.1 Create TypeScript interfaces for domain entities
- [ ] 1.2 Create Zod schemas for form validation
```

### 2. Stores before components
Svelte stores manage state. Components consume stores. Build stores first.

```markdown
## 2. Stores
- [ ] 2.1 Create auth store with login/logout actions
- [ ] 2.2 Create notification store with add/dismiss
```

### 3. Server routes before pages
`+server.ts` and `+page.server.ts` files provide data. `+page.svelte` files consume it.

```markdown
## 3. Server Routes
- [ ] 3.1 Create GET/POST /api/items server route
- [ ] 3.2 Create items page server load function (+page.server.ts)

## 4. Pages & Components
- [ ] 4.1 Create reusable ItemCard component
- [ ] 4.2 Create items list page (+page.svelte)
- [ ] 4.3 Create item detail page with form
```

### 4. Layouts and shared UI
Layouts and shared components (nav, footer, error pages) can be parallel with or after page tasks.

```markdown
## 5. Layouts
- [ ] 5.1 Update root layout with navigation changes
- [ ] 5.2 Create group layout for authenticated routes
```

### 5. Component tests then e2e
Unit-test components with Vitest, then e2e with Playwright.

```markdown
## 6. Testing
- [ ] 6.1 Component tests for ItemCard
- [ ] 6.2 E2E test: create and view item flow
```

## Common Pitfalls

- **Don't combine +page.svelte and +page.server.ts in one task** — server-side data loading and client-side rendering are separate concerns
- **Don't create components and their consuming pages together** — reusable components should be standalone tasks
- **Separate store creation from store usage in components** — the store is the dependency, components are consumers
