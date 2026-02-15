# Skill Evaluation Guide — Detailed Reference

## Section-by-Section Triage Table

Use this table when restructuring an existing skill or reviewing a draft.

| Section Type | Action | Rationale |
|-------------|--------|-----------|
| Purpose / summary | **Keep** in SKILL.md | Model needs this to decide whether to apply the skill |
| When-to-use decision aid | **Keep** in SKILL.md | Prevents misapplication; keeps invocations relevant |
| Essential commands (compact) | **Keep** in SKILL.md | Core workflow must be immediately available |
| Session start/end protocols | **Keep** in SKILL.md | Executed every session; must load with the skill |
| Links to references | **Keep** in SKILL.md | Enables on-demand deeper reading |
| Full command catalog | **Move** to references | Useful but too long for every invocation |
| Worked examples | **Move** to references | Valuable for complex tasks; not needed every time |
| Integration with optional tools | **Move** to references | Only relevant when that tool is in play |
| Error recovery / troubleshooting | **Move** to references | Needed only when things go wrong |
| Output format contracts | **Move** to references | Load on demand when generating output |
| Git basics and conventions | **Cut** entirely | Claude knows how git works |
| Priority/severity scale definitions | **Cut** entirely | Standard scales are common knowledge |
| Installation for common tools | **Cut** entirely | Claude can look this up or already knows |
| Verbose duplicate examples | **Cut** entirely | One clear example is sufficient |
| Marketing or motivation copy | **Cut** entirely | The model follows instructions, not persuasion |

## Model-Tier Context Budget

Skill size matters more for smaller models. Keep this in mind:

| Model | Effective Context | Guidance |
|-------|------------------|----------|
| Opus | Large | Can handle skills near the 500-line ceiling, but shouldn't need to |
| Sonnet | Medium | Keep SKILL.md under 150 lines; use references liberally |
| Haiku | Small | Keep SKILL.md under 100 lines; minimize reference loads |

Regardless of model, shorter skills produce more consistent behavior. The 80-120 line target works well across all tiers.

## Common Anti-Patterns

### 1. Over-Prescriptive Output Formats

**Bad:** Mandating exact markdown templates with rigid heading structure, placeholder tokens, and line-count requirements for every output.

**Better:** Describe the information needed and let the model choose appropriate formatting. Only prescribe format when the output is machine-parsed or part of a strict contract.

### 2. Teaching Claude Things It Knows

**Bad:** Including a section explaining what git commits are, how to write a good commit message, or what semantic versioning means.

**Better:** Reference these concepts by name and trust the model's training. Only document project-specific conventions that deviate from standard practice.

### 3. Coupling to Optional Tools

**Bad:** SKILL.md contains 40 lines about an optional companion tool that's only used in 10% of invocations.

**Better:** Put companion tool integration in `references/` and link to it. SKILL.md should mention the integration exists in one line.

### 4. Kitchen-Sink Skills

**Bad:** A skill that covers task management, code review, deployment, and documentation in one SKILL.md.

**Better:** Split into focused skills. Each skill should have a clear, single-sentence purpose. If your description needs "and" more than once, consider splitting.

### 5. Redundant Context Loading

**Bad:** Using the `context` frontmatter field to always load files that are only sometimes needed.

**Better:** Load only what's needed every invocation via `context`. Reference other files in the body so the model can read them on demand.

## Recommended Directory Structure (Annotated)

```
skills/<skill-name>/
  SKILL.md                        # Always loaded on invocation
  references/                     # Read on demand by the model
    command-reference.md           # Full CLI docs if applicable
    <integration-name>.md          # Per-integration guides
    evaluation-guide.md            # Quality criteria (like this file)
    error-recovery.md              # Troubleshooting
```

Keep file names descriptive and kebab-case. Each reference file should be self-contained — readable without requiring other reference files.
