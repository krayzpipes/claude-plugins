---
name: continue
description: Resume work from a previous session — load context, read handoffs, pick up where you left off.
---

# `/fab:continue` — Session Resume

Resumes work from a previous session by loading context, reading pending handoffs, and identifying the next task to work on.

## Session Start Protocol

1. **Load context:** `td usage --new-session` — loads open issues, recent activity, pending handoffs
2. **Read handoffs:** Review any pending handoffs from the previous session for context
3. **Find work:** `td critical-path` — identify unblocked work and bottlenecks
4. **Pick task:** Select highest-priority task from the START NOW section
5. **Claim:** `td start <id>` — MANDATORY before any implementation

## Work Loop

After starting, follow the standard work loop:

1. **Implement:** Write code, run tests, commit
2. **Log:** `td log "what was done"` with appropriate flags (`--decision`, `--tried`, `--result`)
3. **Submit:** `td review <id>` when complete
4. **Next:** `td critical-path` → pick next task → `td start <id>` → repeat

## CRITICAL: Claim Before Working

**Every agent MUST run `td start <id>` BEFORE starting any implementation work.** This is the lock that prevents multiple agents from colliding on the same task. No exceptions.

See **references/coordination-rules.md** for full coordination rules, conflict avoidance, and multi-agent safety.
