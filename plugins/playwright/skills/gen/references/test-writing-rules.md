# Playwright Test Writing Rules

## Selector Strategy

1. **Prefer `getByTestId`** when possible
   - Requires `data-testid` attributes in HTML
   - Most stable and maintainable

2. **Fallback to `getByRole`** with accessible names
   - Use semantic HTML roles
   - Pair with labels/names where possible

3. **Avoid brittle selectors**
   - Never use CSS nth-child selectors like `.btn:nth-child(2)`
   - Never rely on class names that change frequently
   - Only use as last resort

## Test Structure

- Use `test.describe()` to group tests by OpenSpec flow
- Use `test.step()` for each numbered step in the OpenSpec
- This makes traces readable and maintainable

## Assertion Mapping

- Map OpenSpec Acceptance Criteria directly to `expect()` assertions
- Use element matchers: `expect().toBeVisible()`, `expect().toHaveText()`, etc.
- Avoid timing assumptions; use Playwright's built-in waiting

## Test Scope

- Keep each test focused on a single user flow
- Split flows if they exceed ~12 steps
- One test case per OpenSpec "User Flow" section

## Example Structure

```typescript
test.describe("Feature Name", () => {
  test("User Flow: Descriptive name", async ({ page }) => {
    // Preconditions as comments

    await test.step("Step 1 from OpenSpec", async () => {
      // Actions
    });

    await test.step("Step 2 from OpenSpec", async () => {
      // Assertions
      expect(element).toBeVisible();
    });
  });
});
```
