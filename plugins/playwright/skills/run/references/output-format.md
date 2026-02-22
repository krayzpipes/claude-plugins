# Test Runner Output Format

The test runner returns structured output with these sections:

## Status
- **PASS**: All tests passed
- **FAIL**: One or more tests failed

## Failing Tests (if any)
A bullet list with:
- File path
- Test title

## Artifacts
Paths to:
- `playwright-report/` — HTML report
- `test-results/` — JSON/XML results
- Trace files (if enabled)

## Suggested Fixes
3–7 bullet points with the most likely causes and recommended next steps.
