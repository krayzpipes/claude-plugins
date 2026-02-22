---
name: pw
description: Playwright testing toolkit — run existing tests or generate new ones from OpenSpec feature specs.
argument-hint: [command]
---

# Playwright Testing Toolkit

Coordinate Playwright test running and generation from a single entry point.

## When to Use

| Scenario | Command |
|----------|---------|
| Run existing Playwright tests (full suite or filtered) | `/pw:run` |
| Generate new Playwright tests from an OpenSpec feature spec | `/pw:gen` |
| Quick check — run tests then review failures | `/pw:run` → read report |

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/pw:run [test-path or grep] [--headed] [--project=...]` | Run Playwright tests, collect artifacts, summarize failures |
| `/pw:gen [path-to-openspec.md] [output-dir]` | Convert an OpenSpec feature spec into Playwright test files |

## Stack

```
OpenSpec (what to test) → pw:gen (generate tests) → pw:run (execute tests)
```

Generate once, run often. Tests land in `tests/ui/generated/` by default.
