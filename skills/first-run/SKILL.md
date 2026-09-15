---
name: first-run
description: >-
  Run this immediately after installing this kit, or any time someone wants to
  see what it actually does on their own repository rather than read about it.
  It takes the last thing the person shipped and returns a verdict in about two
  minutes, using the kit's own instruments: which rung of done that work has
  really reached, which of the seven cheap verification lies the recent history
  contains, whether a secret or a conflict marker would get past the guards,
  and whether the project's front door reads clearly to a stranger. Trigger on
  "I just installed this", "what does this kit do", "show me", "first run",
  "shake this down", "audit me", "is my repo in good shape", or any first use
  of this kit in a new repository. Do NOT use it as a substitute for the
  individual skills on a specific artifact; this is the two-minute sweep that
  tells the person which of them to run next.
---

# first-run: two minutes, on their repo, right now

A kit that changes nothing visible on the day it is installed is a kit that gets
uninstalled. This skill exists so the person sees the instruments work on their own
code before they read a word of doctrine.

Keep it to about two minutes. Do not fix anything. Report, then offer.

## The sweep

Work in the user's current repository. Skip any step that does not apply and say so.

**1. What did they last ship?** Read the last five commits (`git log -5 --stat`). Pick the
most substantial one: the one that added a feature, an endpoint, a page, a job. If the
working tree has uncommitted work instead, use that.

**2. Which rung has it actually reached?** Apply `definition-of-done`. For that piece of
work, say which of BUILT, DEPLOYED, WORKS, FED is proven, and name the single artifact that
would prove the next rung. Be specific to their stack: for a web app the next rung is usually
a URL whose body carries the expected content, for a job it is a log line or a row, for a
library it is a consumer that imports it.

**3. Does the recent history contain any of the seven cheap lies?** Read
`docs/SEVEN_CHEAP_LIES.md` and scan the last twenty commit messages and any CI or test
configuration for the tells: a claim of "verified", "tested", or "working" with no command
behind it; a pipeline whose exit code is the last stage's; a health check that reads a status
code and not a body; an env var listed rather than read; a local build standing in for CI.
Quote the exact line for each hit. Zero hits is a finding worth reporting too.

**4. Would the guards have caught anything?** Without installing the hooks, run the two
guard scripts from this kit against the current index (`hooks/guard-staged-secrets.sh` and
`hooks/guard-conflict-markers.sh`, or the `.ps1` twins on Windows without python3). If
nothing is staged, say so and offer to run them over the last commit's files instead. Report
what they say, including the fact that they read only the staged index and fail open.

**5. Does the front door land?** If the repo has a README, a homepage, or a product page,
apply the first pass of `clarity-gate`: read it once as a stranger with five seconds and say
what they would take away, then say what the author intended. If those two differ, that gap
is the finding.

## The verdict

Report in this shape, and keep the whole thing under a page:

```
FIRST RUN on <repo>

Last shipped: <one line about the commit or working tree>
Rung proven:  <BUILT | DEPLOYED | WORKS | FED>, because <the evidence>
Next rung:    <the one artifact that would prove it>

Cheap lies found: <n>
  <file:line or commit> - <which lie, in one line>

Guards: <what they said on the current index>

Front door: <what a stranger takes away in five seconds, vs what you meant>

The one thing I would do next: <a single concrete action>
```

## Then offer, do not act

End by naming which skill fits what you found, and let the person choose:

- A rung gap or a false "done" leads to `definition-of-done`.
- A cheap lie in CI or a health check leads to `docs/SEVEN_CHEAP_LIES.md` and the hooks.
- A front door that does not land leads to `clarity-gate`, then `room-and-ground`.
- Claims in a document that need to be true leads to `verification-gate`.
- A decision about to be made leads to `lamps`.
- Hedge-shaped code that may be lying leads to `hedge-audit`.
- Work about to be handed off leads to `session-closeout`.

If the sweep found nothing, say that plainly. A clean repo is a real result, and saying so is
the same honesty the rest of this kit is about.

---

Provenance: written for this kit on 2026-09-15, after a cold read found that installing it changed nothing a person could see; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/definition-of-done/SKILL.md`.
