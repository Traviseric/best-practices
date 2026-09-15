# Best Practices for AI Coding Agents

This repository is one person's operating method for working with AI coding agents, taken from a private portfolio of production systems that agents build and operate. Every rule in it is stated as the thing an agent would have done wrong, and carries the failure that earned it and the mechanism that now stops it. Nothing here is advice; each rule was paid for.

This file is the index. Fifty-six numbered rules live in seven documents, and nine skills run them. Below is what governs what, and where to go.

---

## The map of the method

**What "done" means, and how the proof gets faked.**
`skills/definition-of-done` is the ladder: BUILT, DEPLOYED, WORKS, FED, and what each rung costs to prove. `docs/SEVEN_CHEAP_LIES.md` is the seven ways the proof gets faked, from an HTTP 200 that is not content to a piped exit code that is not the command's. Behind them, engineering rules **2** (a green board is not a measurement), **3** and **4** (shipping order, and why a weekly check is not monitoring), **12** (a rehearsal cannot prove demand), and **14** (the seven, in one rule). `skills/verification-gate` holds a document to its sources before it leaves your hands. `docs/AUDIT_YOUR_PROJECT.md` runs the whole check on a repo you just met. `skills/first-run` does a two-minute version on yours.

**Concurrency, git, and not losing the work.**
Engineering rules **9** (never amend, stash, or recover in place) and **10** (glue mangles the payload). Patterns **2** (state lives in files), **3** (stage explicit paths, never `git add -A`), **4** (worktrees, not copies), and **5** (a session that writes nothing down did not happen). `skills/session-closeout` encodes the stand-off rule and the explicit-path commit.

**Guards: putting the rule in a mechanism instead of prose.**
Engineering rule **6** is the argument, and rules **5** (test a new gate in both directions), **7** (scope it to the staged index), **8** (an unverified claim about authority is denied like any other), and **11** (secrets, including the ones inside documents) are what it produced. `docs/HOOKS.md` installs the three commit guards in two minutes; `docs/PRE_COMMIT_BUILD_GATE.md` is the highest-leverage one on its own. `skills/hedge-audit` classifies what a model left behind; `skills/friction-audit` deletes the caution that outlived its hazard.

**Writing that has to move a person.**
`docs/ROOM_AND_GROUND.md` is the method and the only place it is defined: two documents, never one, the room written first. `skills/room-and-ground` is the procedure. `skills/clarity-gate` reads your page as a stranger with five seconds.

**Design, and what ships to a user.**
`docs/WEB_DESIGN_PRINCIPLES.md`, thirteen rules from real client sites. Rule **1** is the one that matters most: a page the agent has not seen rendered does not exist yet.

**Context, tasks, and organization.**
Engineering rules **1** (intelligence in markdown, not code) and **13** (prose may cite truth, never store it). Patterns **1** (one context, one task) and **6** (delegate the outcome, not the implementation). `docs/DOC_ORGANIZATION.md`, seven rules on where documentation lives and why the index does not belong in the file that loads every session. `docs/MCP_OPTIMIZATION.md`, five rules on what your servers cost before the first question. `docs/AGENTS_MD_CONTRACT.md`, four rules on what belongs in `AGENTS.md` versus `CLAUDE.md`.

**Before you decide.**
`skills/lamps` runs ten task-independent questions at four fixed moments: who decides, what they default to, who argues against you, where the loss is, and the five questions nobody asked. `philosophy/` holds seven short entries on why the model behaves the way it does, each with the incident and the mechanism it produced.

---

## If you only read three things

1. **[docs/SEVEN_CHEAP_LIES.md](docs/SEVEN_CHEAP_LIES.md)**: the seven sentences to look for before you believe a "verified".
2. **[skills/definition-of-done/SKILL.md](skills/definition-of-done/SKILL.md)**: the ladder, and why a green local build proves only the first rung.
3. **[docs/ROOM_AND_GROUND.md](docs/ROOM_AND_GROUND.md)**: why your accurate page does not land, and the two-document fix.

---

## Where to start, by symptom

| What is happening | Start here |
|---|---|
| My agent says it is done and it is not | [docs/SEVEN_CHEAP_LIES.md](docs/SEVEN_CHEAP_LIES.md), then [skills/definition-of-done](skills/definition-of-done/SKILL.md) |
| My page says everything and lands nothing | [skills/clarity-gate](skills/clarity-gate/SKILL.md), then [docs/ROOM_AND_GROUND.md](docs/ROOM_AND_GROUND.md) |
| My sessions lose their work overnight | [docs/PATTERNS.md](docs/PATTERNS.md) rules 2 and 5, then [skills/session-closeout](skills/session-closeout/SKILL.md) |
| I am about to make a decision someone else will judge | [skills/lamps](skills/lamps/SKILL.md) |
| Agents keep breaking the same rule I keep writing down | [docs/ENGINEERING_PRINCIPLES.md](docs/ENGINEERING_PRINCIPLES.md) rule 6, then [docs/HOOKS.md](docs/HOOKS.md) |
| Context is gone before the agent reads a file | [docs/MCP_OPTIMIZATION.md](docs/MCP_OPTIMIZATION.md), then [docs/DOC_ORGANIZATION.md](docs/DOC_ORGANIZATION.md) rule 1 |
| A new agent cannot find anything in my repo | [docs/DOC_ORGANIZATION.md](docs/DOC_ORGANIZATION.md), then `templates/CLAUDE.md.template` |
| I just installed this and want to see it work | [skills/first-run](skills/first-run/SKILL.md) |
| Something in the codebase looks like it is lying | [skills/hedge-audit](skills/hedge-audit/SKILL.md) |
| I need a document to be right before it ships | [skills/verification-gate](skills/verification-gate/SKILL.md) |

---

## Setting up a project

The templates carry what used to be spelled out here, and `docs/DOC_ORGANIZATION.md` carries the rules behind them.

- `templates/CLAUDE.md.template`: the agent entry point, carrying conventions, commands, and a lookup table that points at files instead of restating them.
- `templates/AGENTS.md.template`: the stable pointer for tool-portable repos. What goes in which file is `docs/AGENTS_MD_CONTRACT.md`.
- `templates/.claudeignore.template`: what the agent should not read. Binary documents and dependency trees cost tokens and return the wrong file.
- `templates/settings.json.template`: the three commit guards, wired.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `AGENTS.md` (https://github.com/Traviseric/best-practices/blob/main/AGENTS.md).
