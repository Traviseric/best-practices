# AGENTS.md Entry Point Contract

A short, stable file that tells coding agents (Claude Code, Codex, Cursor, Aider) where to start when they enter your repo.

---

## The Problem

Different agents look for different files:
- Claude Code reads `CLAUDE.md`
- Codex looks for `AGENTS.md`
- Some IDEs check for `.cursorrules` or similar

If you maintain detailed playbooks in multiple files, they drift. One becomes stale, agents get conflicting instructions.

---

## The Solution

Pick ONE file as the maintained playbook (recommended: `CLAUDE.md`). Make every other agent file a stable, short pointer to it.

### Recommended `AGENTS.md`

```markdown
# Agent Entry Point Contract

Purpose:
- This file is a stable entrypoint contract for coding agents.
- `CLAUDE.md` is the maintained operational playbook for this repo.

Rules:
1. Read `CLAUDE.md` first.
2. Do not duplicate detailed operational playbooks in this file.
3. Do not expand or rewrite this file unless explicitly requested by a human.
```

---

## Why This Works

- **One source of truth.** All operational details live in `CLAUDE.md`. AGENTS.md is metadata.
- **Stable.** AGENTS.md doesn't change. Agents won't fight about "which playbook is canonical."
- **Tool-portable.** Codex, Cursor, etc. all see a consistent pointer. They follow it to your real playbook.
- **Prevents drift.** The explicit rule "do not expand unless asked" stops well-meaning agents from re-creating the playbook in the wrong file.

---

## Variations

If your team's primary tool is Codex, flip it: maintain `AGENTS.md` as the playbook, and let `CLAUDE.md` be the pointer. The pattern is the same — pick one canonical file, point others at it.
