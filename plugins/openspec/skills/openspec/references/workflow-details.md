# OpenSpec Workflow Details

Detailed reference for the OpenSpec change cycle, artifact formats, and CLI usage.

## Full Change Cycle Walkthrough

### 1. Start a Change

```
/opsx:new add-user-notifications
```

Creates `openspec/changes/add-user-notifications/` with the directory skeleton. If requirements are unclear, start with `/opsx:explore notifications architecture` to investigate first.

### 2. Generate Planning Artifacts

**Fast-forward** (clear requirements):
```
/opsx:ff add-user-notifications
```
Generates all four artifacts — proposal, specs, design, tasks — in one pass.

**Iterative** (complex or exploratory):
```
/opsx:continue add-user-notifications
```
Generates the next artifact in the dependency chain. Review and refine before continuing. Repeat until all artifacts exist. The dependency order is: proposal → specs → design → tasks.

### 3. Implement

```
/opsx:apply add-user-notifications
```

Works through `tasks.md` sequentially, checking off items. You can pause and resume — context is preserved in the artifacts. You can also work on parallel changes simultaneously.

### 4. Verify

```
/opsx:verify add-user-notifications
```

Checks three dimensions:

- **Completeness**: Are all tasks checked off? Do all spec requirements have corresponding code?
- **Correctness**: Does the implementation match spec intent? Are edge cases handled?
- **Coherence**: Do design decisions show up in the actual code structure and naming?

Verification is non-blocking — it surfaces issues but doesn't prevent you from proceeding.

### 5. Archive

```
/opsx:archive add-user-notifications
```

- Merges delta specs into the project's main specifications
- Moves the change folder to `openspec/changes/archive/<date>-add-user-notifications/`
- All artifacts remain accessible for historical reference

Use `/opsx:bulk-archive` to archive multiple completed changes at once.

## Delta Spec Format

Delta specs live in `specs/` within each change folder. They describe what's changing relative to current behavior, organized by domain.

### Example: `specs/notifications/spec.md`

```markdown
# Notifications — Delta Spec

## ADDED

### REQ-NOTIF-001: Email notification on signup
The system MUST send a welcome email when a new user completes registration.

#### Scenario: Successful signup notification
- **Given** a new user completes the registration form
- **When** the account is created successfully
- **Then** the system sends a welcome email to the registered address
- **And** the email contains a verification link

### REQ-NOTIF-002: In-app notification preferences
The system SHOULD allow users to configure notification preferences per channel (email, in-app, push).

## MODIFIED

### REQ-AUTH-003: Post-login redirect (was: redirect to dashboard)
The system MUST redirect users to the notifications center on first login, then to the dashboard on subsequent logins.

> **Previous**: Always redirected to dashboard after login.

## REMOVED

### REQ-LEGACY-SMS-001: SMS verification on login
SMS-based login verification is deprecated in favor of email-based verification.
```

### Key Conventions

- **Requirements** use RFC 2119 keywords: MUST, SHALL, SHOULD, MAY
- **Scenarios** use Given/When/Then for testable behavior
- **MODIFIED** entries note what changed from the previous version
- **REMOVED** entries briefly state what's being deprecated and why
- Organize specs by domain — one file per bounded context (e.g., `specs/auth/spec.md`, `specs/notifications/spec.md`)

## Artifact Contents

### proposal.md

Captures intent and boundaries. Should answer:

- **Why** is this change needed? (motivation, user problem, business goal)
- **What** is in scope? (features, components affected)
- **What** is out of scope? (explicit exclusions to prevent scope creep)
- **Approach** at a high level (not implementation details — that's design.md)

### specs/ (Delta Specs)

Documents requirement changes using the ADDED/MODIFIED/REMOVED framework. Each spec file covers one domain or component. This is the most important artifact for brownfield work — it makes explicit what's changing without restating unchanged requirements.

### design.md

Technical decisions and architecture. Should cover:

- **Technology choices** and rationale (why this library, pattern, or approach)
- **Data flow** through the system for the new/changed behavior
- **Files that will change** — explicit list of affected source files
- **Trade-offs** considered and why the chosen approach won

### tasks.md

Implementation checklist. Characteristics of good tasks:

- Numbered and hierarchically organized
- Each task completable in a single work session
- Concrete and checkable (not vague like "handle edge cases")
- Ordered by dependency — earlier tasks unblock later ones

Example structure:
```markdown
## 1. Database Changes
- [ ] 1.1 Add notifications table migration
- [ ] 1.2 Add notification_preferences table migration

## 2. Backend
- [ ] 2.1 Create NotificationService with send() method
- [ ] 2.2 Add email template for welcome notification
- [ ] 2.3 Hook signup handler to trigger welcome notification

## 3. Frontend
- [ ] 3.1 Add notification preferences page
- [ ] 3.2 Wire preferences form to API endpoint

## 4. Testing
- [ ] 4.1 Unit tests for NotificationService
- [ ] 4.2 Integration test for signup → email flow
```

## CLI Command Reference

| Command | Description |
|---------|-------------|
| `openspec init` | Initialize OpenSpec in your project. Creates `openspec/` directory and config. |
| `openspec update` | Regenerate agent instructions and slash command skills from latest OpenSpec version. Run after upgrading. |
| `openspec list` | Show all active (non-archived) changes. |
| `openspec status --change <name>` | Show which artifacts exist and their status for a specific change. |
| `openspec schemas` | List available schemas (templates for different change types). |
| `openspec schema init <name>` | Create a custom schema for specialized change types. |

## Tips for Working Iteratively

- **Start small**: Use `/opsx:explore` before committing to a formal change when you're unsure about scope.
- **Review between artifacts**: Use `/opsx:continue` instead of `/opsx:ff` when requirements are fuzzy — review each artifact before generating the next.
- **New change vs. update existing**: If the intent or scope has fundamentally changed, start a new change rather than modifying an existing one.
- **Parallel changes**: You can have multiple active changes simultaneously. OpenSpec detects conflicts when changes touch overlapping specs during archive.
- **Don't skip verification**: `/opsx:verify` catches gaps between specs and implementation before you archive.
