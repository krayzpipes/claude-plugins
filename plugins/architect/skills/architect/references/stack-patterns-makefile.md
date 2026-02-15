# Stack Patterns: Makefile Build Automation

Decomposition patterns for projects using Makefiles as the build and task automation layer.

## Typical Layer Mapping

| Layer | Makefile Equivalent | Common Targets |
|-------|--------------------|----------------|
| Config | Variables, includes, env detection | Top-of-file `VAR :=`, `-include .env` |
| Dependencies | Fetch/install external deps | `deps`, `install`, `vendor` |
| Code Generation | Generate code from schemas/protos | `generate`, `proto`, `codegen` |
| Build/Compile | Compile source to artifacts | `build`, `compile`, `dist` |
| Test/Lint | Run tests and static analysis | `test`, `lint`, `fmt`, `check` |
| Install/Package | Install locally or create packages | `install`, `package`, `docker-build` |
| Clean/Reset | Remove generated files | `clean`, `distclean`, `reset` |

## Decomposition Order

### 1. Variables and configuration first
Define all variables, paths, and tool versions at the top. These are dependencies for everything else.

```markdown
## 1. Configuration
- [ ] 1.1 Define project variables (name, version, Go/Python version, output paths)
- [ ] 1.2 Add platform detection (OS, ARCH) for cross-compilation
- [ ] 1.3 Include optional .env file for local overrides
```

### 2. Dependencies before build
Fetch and install tools before any target that uses them.

```markdown
## 2. Dependencies
- [ ] 2.1 Add `deps` target to install project dependencies
- [ ] 2.2 Add `tools` target to install dev tools (linter, formatter, codegen)
```

### 3. Build before install
Compile artifacts must exist before they can be installed or packaged.

```markdown
## 3. Build
- [ ] 3.1 Add `build` target to compile the main binary/output
- [ ] 3.2 Add `build-all` target for cross-platform builds (if needed)
```

### 4. Test and lint alongside or after build
Tests and linters operate on source or compiled output.

```markdown
## 4. Quality
- [ ] 4.1 Add `test` target to run test suite
- [ ] 4.2 Add `lint` target to run static analysis
- [ ] 4.3 Add `fmt` target to auto-format source code
- [ ] 4.4 Add `check` meta-target that runs fmt + lint + test
```

### 5. Phony targets for orchestration
High-level targets compose lower-level ones. Define `.PHONY` declarations.

```markdown
## 5. Orchestration
- [ ] 5.1 Add `all` default target (deps + build)
- [ ] 5.2 Add `ci` target (deps + check + build)
- [ ] 5.3 Declare all .PHONY targets
```

### 6. Clean targets last
Clean targets remove generated artifacts. They have no upstream dependencies.

```markdown
## 6. Clean
- [ ] 6.1 Add `clean` target to remove build artifacts
- [ ] 6.2 Add `distclean` target to also remove vendor/deps
```

## Common Pitfalls

- **Don't forget `.PHONY`** — targets that don't produce a file of the same name must be declared `.PHONY`, or Make will skip them if a matching file exists
- **Separate dependency installation from build** — `deps` and `build` are different targets; combining them causes unnecessary re-fetching
- **Use `$(VAR)` not `${VAR}`** — while both work in GNU Make, `$(VAR)` is the conventional and portable form
- **Each target does one thing** — a `build` target that also runs tests violates separation of concerns; compose with meta-targets like `ci` instead
- **Use `:=` for immediate assignment** — prefer `:=` (simple expansion) over `=` (recursive expansion) to avoid surprising re-evaluation

> For general infrastructure principles (local-first, environment parity), see `principles-core.md`.
