---
name: gen
description: Convert an OpenSpec feature spec into deterministic Playwright tests using stable selectors and explicit assertions.
disable-model-invocation: true
argument-hint: "[path-to-openspec.md] [optional: output-dir]"
allowed-tools: Read, Write, Grep, Glob, Bash(node *), Bash(npx playwright *)
---

# Goal

Given an OpenSpec file path, generate Playwright tests that model user flows as test cases, use stable selectors, assert real acceptance criteria, and avoid brittle timing.

## Inputs

- OpenSpec file: `$ARGUMENTS[0]`
- Output directory (optional): `$ARGUMENTS[1]`, default `tests/ui/generated`

## Output

- One spec file per OpenSpec "User Flow" (or equivalent).
- Write tests to: `<output-dir>/<slug>.spec.ts`
- If needed, write shared helpers under `<output-dir>/_helpers/` (page objects, login helper).

## Core Workflow

### 1. Parse the OpenSpec
Follow the extraction procedure in `references/parsing-rules.md`:
1. Feature name / title (top heading)
2. Preconditions / Setup (logins, seed data)
3. User Flows (numbered steps)
4. Acceptance Criteria (assertions)

If any section is missing, infer minimally and add a TODO comment in the test file.

### 2. Generate test files
Apply the selector strategy and structure patterns in `references/test-writing-rules.md`.
Use the scaffold in `templates/playwright.spec.ts.template` as baseline structure.

See `references/example-openspec.md` for a worked example.

### 3. Post-generation checks
1. If `playwright.config.*` exists, align `baseURL` usage.
2. Run a quick syntax check:
   ```bash
   npx playwright test <generated-file> --reporter=line
   ```
3. If it fails due to missing app/server, do NOT start the server automatically unless the OpenSpec explicitly states the command.

## Final Response

- List created/modified files.
- Provide the command to run the generated suite.
- Call out any TODOs introduced.
