# A system's account of its own failure is the least trustworthy thing it says

Written August 2026, from three defects in one small subsystem, found in one week.

## The observation

The reliability of a system's self-report is bounded by the correctness of the code doing the reporting, which is the code least likely to be tested, because testing it requires simulating the failures it exists to describe.

Error paths are the least-exercised code in any system. They are also the code that decides what a human is told when something breaks. Those two facts compound: the least-tested code is the code that determines whether anyone finds out about the second-least-tested code.

## The incident

An invite-accept endpoint in a small shared-calendar app had two bugs. Only one of them was findable.

The first: the handler granted access before marking the invite claimed, so a failure between those two steps left a link that had already worked and could work again. A fail-open on a bearer credential.

The second: every error out of that endpoint, regardless of cause, was reported to the caller as "refused", rendered as *that link is not valid*.

The second bug is why the first survived. A malformed database parameter, a null constraint, a network blip and a genuinely spent invite all produced the same four words. The endpoint was observably behaving correctly while being wrong, because its self-description had collapsed every failure mode onto the one outcome that looks like normal operation. Nobody investigates a link that is not valid. That is what an invalid link is supposed to do.

The bug underneath was found only after the classification was fixed: "refused" reserved for the one error that means refused, everything else escalated with a stack trace. The fix to the reporting layer was the thing that made the real defect visible. It was not a cleanup pass afterward.

A third, quieter instance in the same system: a database statement whose null comparison supplied no type, so the single-use race guard had never executed in production. It did not error. It did not log. The query ran, returned rows, and silently omitted the check it existed to perform. A guard that is skipped and a guard that passes produce identical output.

## The shape

Three failures, one shape: **the layer that reports on correctness had itself failed, so the report was clean.** This is worse than an unreported bug. An unreported bug leaves the operator uncertain, and uncertainty prompts investigation. A miscategorised bug leaves the operator confident and wrong, and confidence is the state in which nobody looks.

## The neighbouring idea

Session loading in the same app's mobile client had exactly one state with no exit: on a cold launch the keychain can hang rather than fail, so the app sat on a spinner forever. The loader handled a throwing keychain. It could not handle one that never answers. The fix was a three-second watchdog that gives up and treats it as signed out.

The principle: **failing in the safe direction is only safe if the safe direction has an exit.** "Wait until we know" is a fail-safe with no floor.

## The mechanism it produced

This is an observation, not a law, and the honest reasons are written in the long form: three instances is a pattern to a human and noise to a statistician, and there are systems where collapsing errors is correct (an auth endpoint should not distinguish "no such user" from "wrong password"). The rule that survives is narrower: **collapse at the boundary, never in the log.** The caller may be told less than the operator; the operator must never be told less than the truth.

It became the second of the seven cheap lies in this repository: a live process is not a finished job, and a clean report from a broken reporter is the cleanest of all.

Provenance: this came from the private system's philosophy register; the update path is this repository.

Next: `instruments-that-doubt-themselves.md`.
