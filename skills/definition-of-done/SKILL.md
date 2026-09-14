---
name: definition-of-done
description: The DEFINITION OF DONE for any feature in any repo. A run-truth ladder (BUILT -> DEPLOYED -> WORKS -> FED) that says what "done" actually means and how to get a feature from "the code exists" to "it demonstrably works in production and I will know within a day if it stops." Use it whenever you are about to claim something is done, working, live, shipped, launched, ready, or wired; when writing a verifier for a task; when someone asks "is X actually working?"; or when a dashboard says green and you are not sure you believe it. Trigger on "is this done", "definition of done", "is it working", "how do I prove it works", "e2e passed", "what does done mean here", "how do I know this is live", "verify this feature", "mark this complete", "close this out". Do NOT use it to review visual design or to fact-check prose; it judges run-truth only.
---

# Definition of Done: the run-truth ladder

## Automatic trigger

Invoke this skill for every feature-finishing task, even when nobody names it. "Finish"
includes complete, ship, land, launch, go live, ready, close out, final pass, archive, and
mark done. Before ending that work, evaluate every applicable rung below and state the
highest rung actually proven. A local check cannot silently stand in for production proof,
and a missing prerequisite must be reported as `PRECONDITION_BROKEN`, `UNRUNNABLE`, or
`UNMETERED` rather than waived.

Why this exists: in one real portfolio, several hundred declared task verifiers were parsed
and about two of them touched a deployed environment. A green check meant "a command exited 0
in a throwaway worktree." That is how a login route served a debug stub for ten months while
every board read green.

## The one thing to understand

"Done" is not one state. It is four, and you must say which one you mean.

| Rung | The claim | What actually proves it | What a lie here costs |
|---|---|---|---|
| 1 BUILT | the code is on the origin trunk | build or test command exits 0 AND the sha is on `origin/<trunk>` | nothing works, but you think you shipped |
| 2 DEPLOYED | the artifact is live where it matters | a probe hits the deployed URL or version and gets YOUR code back | you shipped to a branch nobody serves |
| 3 WORKS | the core loop executes against the deployed thing | a health check, canary, or end-to-end probe runs the real path in the real environment | it exists, it is live, and it is broken |
| 4 FED | real users, data, or money flow through it | a "last real activity" timestamp inside an agreed window, with your own probe traffic excluded | it works perfectly and nobody uses it, which looks identical to success on every board |

A green local build only ever proves rung 1. If you are claiming anything above rung 1, name
the evidence.

## The four laws

1. Prose may CITE truth; it may not STORE it. If a human can hand-type a status into a
   document, it will eventually become a lie. Generate the status, or cite the generated thing.
2. Staleness is a state. A green you have not re-checked in a week is UNKNOWN, not green.
   Verified-ness decays. Red never decays; it persists until someone fixes it.
3. UNRUNNABLE is loud, never a silent skip. "I could not check" must be as visible as "it
   failed." A silent skip looks exactly like coverage. The classic form: an error reporter that
   quietly returns when its env vars are unset, so "no errors" and "reporting is dark" are
   indistinguishable. That indistinguishability IS the bug.
4. A verifier that cannot fail is not a verifier. Before you trust a check's green, see it red
   against the unfixed world. A declared verifier is a string someone typed; nothing proves the
   binary honours it. A script that ignored an unknown flag once fell through to a read-only
   report mode, printed a plan, and exited 0 on a feature that had never run. Never verify a
   receipt against a value the receipt itself supplies; current truth comes from outside the
   artifact being judged.

## Rung verdicts

Use these words exactly. Each one means something different to the person reading it.

| Verdict | Meaning |
|---|---|
| PROVEN at rung N | the artifact for rung N exists and you can point to it |
| UNKNOWN | nobody has checked, or the last check is stale |
| UNRUNNABLE | the check exists but could not execute (missing tool, blocked command, no access). Say which command was blocked. |
| UNMETERED | no source can answer the question at all (usually rung 4). This is a task, not a shrug. |
| PRECONDITION_BROKEN | the fixture, account, or test data the check depends on is not ready. Distinct from an outage so it pages differently. |
| STARVED | built and wired, zero real flow (rung 4 only) |

## How to take any feature from "code exists" to "e2e passed"

Each rung has an artifact. Without the artifact you have not climbed it.

### Rung 1: BUILT
- Declare a real verifier command: a test file, a typecheck, a lint, a probe script. Write the
  test in the same task if it does not exist.
- Land on the trunk. Confirm the sha is an ancestor of `origin/<trunk>`, not only a local
  branch.
- You may now say "built." You may not say "working."

### Rung 2: DEPLOYED
- Know how your repo actually deploys (auto on merge? a manual workflow? a person?). Find out;
  do not assume. A merged commit is not a deployed commit.
- Prove the deployed artifact contains your change: a version endpoint, a build sha, or a probe
  that asserts the new behavior. "The deploy workflow was green" is not proof.

### Rung 3: WORKS
- Name THE one command that proves this project's core loop against the deployed environment.
  If the honest answer is "there is no such command," write GAP and file it as work.
- For a user-facing or money path, write a real end-to-end check against the deployed
  environment, not localhost. Keep it honest:
  - Assert the precondition first. If the fixture is not ready, exit `PRECONDITION_BROKEN`. A
    fixture failure reported as an outage trains everyone to ignore the alarm, and the real
    outage then arrives into a muted channel. In one case the money-path canary went red, was
    assumed to be fixture drift, and had actually caught a bug that hid the purchase button
    from customers.
  - Never complete a money-moving write in a recurring probe. Stop before the charge, or flag
    the row synthetic and clean it up in a teardown that runs even on failure.
  - Assert the downstream effect, not the HTTP 200. A route that returns 200 and writes nothing
    is the most common lie in any codebase.
- Only now may you say "it works."

### Rung 4: FED
- Ask: has real data flowed through this in the last N days? Classify as FED, STARVED, or
  UNMETERED.
- Exclude your own probe traffic from the count, or the gauge measures your heartbeat instead
  of real demand and every starved system reports healthy.
- A STARVED system is not a success. It is a build you should stop maintaining or start feeding.

## The checklist (paste into any "is it done?" conversation)

```
[ ] rung 1 BUILT     verifier command:        ______   exit 0?  sha on origin trunk?
[ ] rung 2 DEPLOYED  how does this deploy?    ______   proof the deployed artifact has my change?
[ ] rung 3 WORKS     health check / e2e:      ______   runs against DEPLOYED, asserts the downstream effect?
                     precondition asserted separately (PRECONDITION_BROKEN)?
[ ] rung 4 FED       last real data flow:     ______   FED / STARVED / UNMETERED (probe traffic excluded)
```

If you cannot fill a line, say so out loud. "I don't know if it's deployed" is a useful
sentence. "It's done" when you mean rung 1 is how a debug stub serves for ten months.

## The completion claim

End every finishing task with one sentence in this shape:

> Highest rung proven: WORKS. BUILT (tests pass, sha abc123 on origin/main), DEPLOYED (version
> endpoint returns abc123), WORKS (checkout probe placed and cancelled a synthetic order). FED:
> UNMETERED, no activity source exists yet; filed as follow-up.

Never archive a task, mark a feature complete, or tell a user it is working when a required
rung is UNKNOWN, UNRUNNABLE, UNMETERED, or PRECONDITION_BROKEN. Report the rung, report the
blocker, and stop there.

## For a new project

1. Write down the ONE command that proves the core loop. No command means the project is
   present, not active.
2. If you have scheduled jobs, wrap them in a check-in so a dead job pages. A cron with no
   check-in cannot tell you it died; the only signal is the absence of an effect nobody is
   watching for.
3. If you cross a system boundary, write a seam probe that asserts the contract (the shape and
   effect of a real call), not mere reachability.
4. Put every production canary on one board. A detector reporting to its own silo is a
   detector nobody reads.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `README.md` (the loop closes here; start again at the top).
