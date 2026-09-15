# The Seven Cheap Lies

**A check you did not actually run is not a check.**

The [definition of done](../skills/definition-of-done/SKILL.md) says WHICH rung you must
prove. This document says HOW the proof gets faked. Every one of these has produced a false
"done" in a real production portfolio. Each one is cheap to tell and expensive to retract.

Pin this next to your agent. Then look for these seven sentences in its output before you
believe a "verified."

---

## 1. HTTP status is not content

A 200 from a Next.js, SPA, or any framework route is the shell, not the page. A soft-404
answers 200 all day. A route that returns 200 and writes nothing is the most common lie in any
codebase.

**Do instead:** read the response BODY for the expected content, and assert the downstream
effect (the row, the file, the email) before writing "verified."

## 2. A live process is not a finished job

On Windows especially, `kill -0`, a PID check, or "the window is still open" prove nothing
about completion. A process can be alive, stuck, and never going to finish.

**Do instead:** poll for the actual artifact: the file, the commit sha, the log line, the
database row. Completion is an artifact, not a heartbeat.

## 3. Re-reading a file is not running the gate

If typecheck, build, test, or lint is blocked, unavailable, or errors out, "I re-read the
source and it looks right" is not a substitute for a compiler.

**Do instead:** say exactly which command was blocked and mark the change UNVERIFIED. The
honest sentence is "I could not run `npm test`," not "it looks correct."

## 4. A short sha is not a sha

Watching CI on a guessed or hand-expanded prefix means you may be watching someone else's
build, or a build that does not exist.

**Do instead:** watch CI on the exact output of `git rev-parse HEAD`, and paste that value into
the report.

## 5. A configured env var is not a configured VALUE

`vercel env ls`, and every console equivalent, lists the NAME. It will happily show a
variable whose value is an empty string. Found in production, Aug 2026: a service key was
reported as configured, was empty, and the code's own `length < 32` guard then failed silently
into a log nobody read. The live test ran against nothing.

**Do instead:** read the VALUE (`vercel env pull`, then check its length) before writing "the
credentials are set." And a guard that fails closed and logs is not a check either: if a rail is
required, prove ONE REAL CALL through it.

## 6. A local build is not the CI build

CI sets `CI=true`, which turns warnings into errors, so a build that passes on your machine can
fail the gate on a lint warning you never saw. The nastier form: a test suite that aborts during
COLLECTION reports one tidy `ModuleNotFoundError` and runs ZERO tests. A repo can sit fully
untested behind a failure that reads like a single missing import, and fixing the first missing
dependency only reveals the second.

**Do instead:** reproduce the gate's exact invocation locally, env and all, before believing
either a green or a red. Read the tallies (`Test Files N passed (N)`), not only the exit code.

## 7. A piped exit code is not the command's exit code

A shell pipeline returns the LAST stage's status. `npx vitest run | tail -18` exits 0 on a suite
that failed, and a background runner then reports "completed (exit code 0)" for a red suite.
This is the most silent of the seven because success and failure look identical.

**Do instead:** never pipe a command whose verdict you intend to trust. Redirect and inspect:

```sh
cmd > out.log 2>&1; echo "EXIT:$?"
grep -E "passed|failed" out.log
```

Or use `${PIPESTATUS[0]}` in bash. And read the tallies too, because a collection abort (lie 6)
reports zero tests as cheerfully as it reports a thousand.

---

## How to use this with an agent

Add one line to your `CLAUDE.md` or `AGENTS.md`:

```
Before writing "verified", "tested", or "done", check your evidence against docs/SEVEN_CHEAP_LIES.md
and name the rung proven per skills/definition-of-done.
```

Then, when the agent reports, scan for the tells:

| It wrote | Ask |
|---|---|
| "returns 200" | what was in the body? |
| "the process is running" | where is the artifact? |
| "I reviewed the code and it's correct" | which command did you run? |
| "CI is green" | on which full sha? |
| "the env var is set" | how long is the value? |
| "tests pass locally" | with `CI=true`? how many tests ran? |
| "exit code 0" | was there a pipe? |

## The close

The honest answer is always cheaper than the retraction. "I could not check" costs one
sentence now. "It's done" when it is not costs the retraction, the trust, and usually a
production incident someone else finds first.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `philosophy/README.md` (https://github.com/Traviseric/best-practices/blob/main/philosophy/README.md).
