---
name: run
description: Run Playwright UI tests end-to-end, collect artifacts, and summarize failures with next-step fixes.
disable-model-invocation: true
argument-hint: "[optional: test-path or grep] [--headed] [--project=...]"
allowed-tools: Read, Grep, Glob, Bash(npm *), Bash(pnpm *), Bash(yarn *), Bash(npx playwright *), Bash(node *)
---

# Goal

Run Playwright tests deterministically and return a pass/fail summary, the top failing tests with likely cause, and artifact paths (playwright-report/, test-results/, traces).

## Rules

- Prefer `npm` scripts if present in package.json, else use `npx playwright`.
- Default to headless unless user passed `--headed`.
- Only run against localhost / internal env configured in `playwright.config.*`.
- If Playwright or browsers are missing, install them using `scripts/ensure-playwright.sh`.
- Always run with trace enabled on failure if not already configured.

## Steps

### 1. Locate Playwright
- If `package.json` exists and includes `@playwright/test`, use project-local.
- Otherwise install as a dev dependency + browsers.

### 2. Ensure browsers installed
```bash
bash plugins/playwright/skills/run/scripts/ensure-playwright.sh
```

### 3. Run tests
- If `package.json` has a `test:ui` script, run `npm run test:ui -- $ARGUMENTS`
- Otherwise run `npx playwright test $ARGUMENTS`

### 4. If failing — re-run with diagnostics
Re-run only failing tests once:
```bash
npx playwright test --last-failed --trace=on --screenshot=only-on-failure
```

### 5. Summarize
- Give a tight summary and list failing spec names.
- Point to artifacts: `playwright-report/` and `test-results/` paths.
- Follow the structured output contract in `references/output-format.md`.

## Constraints

- Never open arbitrary external URLs.
- Do not start application servers unless explicitly instructed.
- Keep trace files for debugging; do not delete them automatically.
