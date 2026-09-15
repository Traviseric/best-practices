# The AGENTS.md Contract

Four rules about the entry-point file, each stated as the thing an agent would have done wrong. The contract is small on purpose: it exists to stop two files from becoming two playbooks.

---

## 1. You would have maintained two playbooks

**The rule.** One file is the maintained playbook. Every other agent entry file is a short, stable pointer to it.

**The incident.** Different agents read different files. Claude Code loads `CLAUDE.md`; other tools look for `AGENTS.md`; some editors read their own dotfile. Maintain detailed instructions in two of them and they drift within weeks, in the worst possible way: both look authoritative, neither says it is stale, and the agent that reads the wrong one has no way to tell. The failure is silent and it compounds, because each session edits whichever file it happened to load.

**The mechanism.** A three-rule contract in the pointer file, short enough that nobody is tempted to grow it:

```markdown
# Agent Entry Point Contract

Purpose:
- This file is a stable entrypoint contract for coding agents.
- `CLAUDE.md` is the maintained operational playbook for this repo.

Rules:
1. Read `CLAUDE.md` first.
2. Do not duplicate detailed operational playbooks in this file.
3. Do not expand or rewrite this file unless a human explicitly asks.

## Verify
<the exact command that proves a change works in this repo>
```

**Apply it.** Pick the canonical file today. If your team's primary tool is Codex, make `AGENTS.md` the playbook and `CLAUDE.md` the pointer; the pattern is symmetric. What matters is that exactly one is maintained.

## 2. You would have helpfully rebuilt the playbook in the pointer file

**The rule.** Rule 3 of the contract exists because well-meaning agents recreate the playbook in the wrong file. State the prohibition explicitly or it will not hold.

**The incident.** An agent asked to "improve the agent documentation" finds a three-line pointer file, correctly concludes it looks thin, and fills it in. Now there are two playbooks again, and the newer one is the one nobody reviewed. This is not a failure of intelligence. It is the natural response to a file that looks unfinished, so the fix is to make the file say it is finished on purpose.

**The mechanism.** The literal sentence "Do not expand or rewrite this file unless a human explicitly asks", inside the file itself. It converts an apparent gap into a stated intention.

**Apply it.** If your pointer file does not carry that sentence, add it before the next agent finds the file.

## 3. You would have put the behavioral rules in the file nobody loads

**The rule.** Conventions go in the playbook that loads automatically. Pointers, contracts, and indexes can live anywhere. A behavioral rule in a file nobody opens is not a rule.

**The incident.** The general form of this cost a large private system months of repeated violations: rules about branch placement, secrets, and conflict markers lived in an operating document and were broken regularly, not out of defiance but because nothing put them in front of the agent at the moment of the action. Each one became a guard in an afternoon and the violations stopped. See `docs/ENGINEERING_PRINCIPLES.md` rules 6 and 7, and `docs/HOOKS.md` for what replaced them.

**The mechanism.** A split by kind, not by length. Lookup (where things live, what exists) can be externalized and grepped, which `docs/DOC_ORGANIZATION.md` rule 1 covers. Behavior (what to do, what never to do) stays in the file that is always in context, or becomes a hook.

**Apply it.** Read your pointer file and your playbook. Any imperative sentence in the pointer file is in the wrong place.

## 4. You would have written a contract you never ran

**The rule.** The entry file carries the one command that proves a change works in this repo, under a heading the agent can find. An agent that knows how to verify itself does not need a human to catch it.

**The incident.** This repository shipped exactly this defect, and a cold read by an unfamiliar agent caught it in September 2026. Its `AGENTS.md` told the agent that recorded tests for the guard hooks were in `docs/HOOKS.md`. There were none. The file described a test you could run, not a test anyone had run. A repository whose central claim is "a check you did not run is not a check" was citing checks that did not exist. It was fixed the same day by running them and recording the output, which is the only fix available.

**The mechanism.** A `## Verify` section in the entry file with the exact invocation, plus the rule that a completion claim names the rung it proved (`skills/definition-of-done`). Putting the command in the entry file rather than in prose is what makes the agent run it before claiming done.

**Apply it.** Add `## Verify` to your entry file now, with the command you would run before believing someone else's "it works". This repository's own is in `AGENTS.md`.

---

## What goes where

| Content | Home | Why |
|---|---|---|
| Conventions, prohibitions, the way this repo does things | The playbook | Must be in context to fire |
| The verify command | The entry file | The agent runs it before claiming done |
| Where things live | An index the agent greps | Costs nothing until needed |
| Current focus, active work | The playbook | Changes often, read every session |
| The pointer contract itself | The entry file | Stable, three rules, never grows |

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `AGENTS.md` (this repo runs its own contract).
