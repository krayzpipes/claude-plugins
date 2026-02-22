# OpenSpec Parsing Rules

When extracting content from an OpenSpec markdown file, follow this order:

## 1. Feature Name / Title
- Extract the top-level heading (# Feature: ...)
- This becomes the test suite name

## 2. Preconditions / Setup
- Look for a "Preconditions" or "Setup" section
- List logins, seed data, prerequisites
- Include these as comments in the generated test

## 3. User Flows
- Identify numbered steps sections (## User Flow: ...)
- Each flow becomes a separate test case
- Number of steps should be reasonable (~12 max)

## 4. Acceptance Criteria
- Look for "Acceptance Criteria" section
- Each criterion maps to an `expect()` assertion
- Keep criteria aligned with actual test steps

## Handling Missing Sections

If any section is missing:
- Infer minimally
- Add a TODO comment in the generated test file
- Do NOT ask questions unless absolutely necessary
