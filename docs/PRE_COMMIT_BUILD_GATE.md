# Pre-Commit Build Gate

**The single highest-leverage hook you can add to a project.** It catches broken builds before they hit CI, before they hit your teammates, and before the agent commits sloppy work overnight.

---

## What It Does

When the agent (Claude Code, etc.) tries to run `git commit`, this hook runs your build first. If the build fails, the commit is blocked with a clear reason. Agent reads the error, fixes it, retries.

No more waking up to a green TODO list and a broken main branch.

---

## How To Set It Up (Claude Code)

Create `.claude/settings.json` in your project root:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(git commit:*)",
        "hooks": [
          {
            "type": "command",
            "command": "<project-specific build command>",
            "timeout": 180,
            "statusMessage": "Build check before commit..."
          }
        ]
      }
    ]
  }
}
```

The hook returns JSON. To block the commit, the command must output `{"continue":false,"reason":"<why>"}`.

---

## Build Command By Stack

| Stack | Command |
|-------|---------|
| Next.js | `cd "<project-path>" && npx next build --no-lint > /dev/null 2>&1 \|\| echo '{"continue":false,"reason":"next build failed"}'` |
| Python (pytest) | `cd "<project-path>" && python -m pytest --tb=short 2>&1 \|\| echo '{"continue":false,"reason":"tests failed"}'` |
| TypeScript (tsc) | `cd "<project-path>" && npx tsc --noEmit 2>&1 \|\| echo '{"continue":false,"reason":"type errors"}'` |
| CDK / SAM | `cd "<project-path>" && npx cdk synth > /dev/null 2>&1 \|\| echo '{"continue":false,"reason":"cdk synth failed"}'` |
| Go | `cd "<project-path>" && go build ./... 2>&1 \|\| echo '{"continue":false,"reason":"go build failed"}'` |
| Rust | `cd "<project-path>" && cargo check 2>&1 \|\| echo '{"continue":false,"reason":"cargo check failed"}'` |

---

## Rules

- **Commit `.claude/settings.json` to the repo** — not `.claude/settings.local.json`. You want every machine and every overnight worker to inherit the gate.
- **Use `--no-lint` for Next.js** if your project has pre-existing lint warnings. The build catches *real* type/build errors; lint is a separate concern.
- **Timeout 180s** is fine for most projects. Bump it for large monorepos.
- **The hook only triggers on `git commit`** — normal development isn't slowed.

---

## Test It

After creating the file:

```bash
# Force a build break — comment out an import or break a type
# Then ask the agent to commit
git commit -m "test"
```

You should see the hook fire and the commit block. Restore the broken code, re-commit, watch it succeed.

---

## Why This Matters

Across many production overnight runs, the #1 source of "agent shipped broken code" is missing pre-commit verification. A 60-second build check eliminates an entire class of failure — and it's one file.

Every repo should have it.
