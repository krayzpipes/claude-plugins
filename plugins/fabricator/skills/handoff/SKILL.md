---
name: handoff
description: End session with structured handoffs — document progress, decisions, and next steps for the next agent.
---

# `/fab:handoff` — Session End

Creates structured handoffs for all in-progress work before ending a session. Ensures the next agent (or future you) can pick up seamlessly with zero prior context.

## Session End Protocol

1. **Handoff each in-progress issue:**
   ```bash
   td handoff <id> \
     --done "What was completed" \
     --remaining "Concrete next steps" \
     --decision "Key choices made and why" \
     --uncertain "Open questions needing investigation"
   ```

2. **Submit completed work:** `td review <id>` for any finished tasks

3. **Summarize session progress:**
   - Tasks completed (submitted for review)
   - Tasks in progress (with handoff created)
   - Blockers encountered
   - Key decisions made

## Handoff Quality

Write handoffs for a future agent with **zero prior context**:

- Be specific, not vague — "Implemented user model in `src/models/user.py` with email validation" not "Made progress on the model"
- Include file paths, function names, and concrete next steps
- Document decisions with rationale so the next agent doesn't re-investigate

See **references/coordination-rules.md** for full coordination rules, handoff format, and multi-agent safety.
