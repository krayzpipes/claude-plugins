# Worked Example: Invite a Family Member

This example demonstrates how an OpenSpec maps to generated Playwright tests.

## Source OpenSpec

```markdown
# Feature: Invite a family member

## Preconditions
- User is logged in as "Parent"
- Family "Piper" exists

## User Flow: Send invite
1. Navigate to Settings → Family
2. Click "Invite member"
3. Enter email "kid@example.com"
4. Click "Send invite"

## Acceptance Criteria
- A success message appears: "Invite sent"
- The invite appears in the Pending Invites list with the entered email
```

## Generated Test

```typescript
import { test, expect } from "@playwright/test";

test.describe("Invite a family member", () => {
  test("Send invite", async ({ page }) => {
    // Preconditions:
    // User is logged in as "Parent"
    // Family "Piper" exists

    await test.step("Navigate to Settings → Family", async () => {
      await page.getByRole("link", { name: "Settings" }).click();
      await page.getByRole("link", { name: "Family" }).click();
    });

    await test.step("Click Invite member", async () => {
      await page.getByRole("button", { name: "Invite member" }).click();
    });

    await test.step("Enter email", async () => {
      await page.getByTestId("invite-email").fill("kid@example.com");
    });

    await test.step("Click Send invite", async () => {
      await page.getByRole("button", { name: "Send invite" }).click();
    });

    // Acceptance Criteria
    await expect(page.getByText("Invite sent")).toBeVisible();
    await expect(
      page.getByTestId("pending-invites").getByText("kid@example.com")
    ).toBeVisible();
  });
});
```
