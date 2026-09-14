---
name: friction-audit
description: Use this skill to hunt and delete DEAD CAUTION - prose rules, timid defaults, and prompt warnings that an incident once justified but that the system now enforces itself (transactions, locks, preflight checks, watchdogs, retries, gates). Trigger on "friction audit", "deguard", "remove the guardrails", "why is this so slow or limited", "the docs are stopping the system", "strip the warnings", or any time an agent notices it is obeying a documented rule the machine already enforces or no longer needs. Do NOT use it to remove a control that is still the only thing standing between an agent and money, a real person, legal exposure, or irreversible production - this skill deletes redundant prose, never live safety.
---

# friction-audit: hunt and delete dead caution

## The disease this cures

Every incident adds prose caution: "never do X", "run one at a time to be safe", "treat this
folder as a global lock", "emergency override only". Later, engineering moves the real safety
into the machine: transactions, leases, scope-aware preflight, watchdogs, retries, gates.
Nobody deletes the prose. Agents obey the prompt they are handed, so the dead caution keeps
serializing, blocking, and under-parallelizing the system forever. The docs become the
bottleneck the engine no longer is.

The incident that earned this skill: an autonomous runner had gained scope-aware preflight,
isolated-worktree parallelism, a serialized landing gate, and a lease on its state board,
while its own field guide and skill still taught "one worker at a time", "never two windows",
and "the config folder is a global lock". The fleet ran at a fraction of its designed
throughput on documentation debt alone.

## Doctrine (the one rule)

Safety lives in enforcement, never in prose. When enforcement lands, deleting the matching
prose is part of the enforcement's definition of done. A warning that outlives its hazard
becomes the hazard.

Prose caution is the worst of both worlds: too weak to stop a determined mistake, strong
enough to stop all routine throughput.

## The pass (run it per doc surface, quarterly or after any hardening lands)

1. **Inventory the hedges.** Grep the surface for caution markers:
   `never|always|do not|must not|conservative|to be safe|careful|emergency|exception|solo|one at a time|global mutex|--max-parallel 1|serialize|only when|danger`.
   Also sweep defaults: config values, CLI defaults, prompt templates. A timid default is a
   hedge wearing a number.
2. **Trace each hit to its hazard.** What concrete incident does this prevent? If nobody can
   name one, it is decoration: DELETE.
3. **Check for enforcement.** Does the engine now prevent that incident mechanically
   (transaction, lease, gate, watchdog, retry, schema, scope check)? Find the code.
4. **Classify into exactly three bins:**
   - **DELETE**: hazard gone, or enforcement exists. Remove the prose. Where useful, replace
     it with one line naming the enforcement ("preflight is scope-aware; it blocks only on
     genuine overlap") so readers know the machine has it. A pointer is not a warning.
   - **CONVERT**: hazard real, enforcement missing. The fix is to build the enforcement (file
     the task) and delete the prose when it lands. The prose may stay only until the
     enforcing commit and must carry its expiry: `<!-- delete when <mechanism> lands -->`.
   - **KEEP (rare)**: a live invariant that cannot be machine-enforced: a human decision
     gate, legal exposure, an irreversible external action. State it once, in one sentence,
     at the decision point. Never repeat it across surfaces.
5. **Apply the deletions in the same pass.** A friction audit that files a report instead of a
   diff is itself friction.
6. **Zero-new-warnings rule (hard).** The pass may not add qualifiers, hedges, "be careful"
   notes, or softening language anywhere, including to its own report. If you feel the urge to
   add a warning while deleting one, that is the tilt this skill exists to fight. Rewrites must
   be shorter than what they replace.

## Authoring gate (stops re-infection)

New caution may enter a doc only with all three:

1. The incident it prevents (a link or a date; "I imagined it could break" does not qualify).
2. The enforcement plan (which mechanism will make this prose deletable, or an explicit
   KEEP-class justification).
3. An expiry marker `<!-- delete when <mechanism> lands -->` for CONVERT-class prose.

Reviewers and agents reject caution that arrives without them. Models default to hedging; the
gate makes the default cost something.

## Where to run it (priority order)

1. Operator prompts agents actually execute: runbooks, drain prompts, command references.
   Highest leverage; agents obey these verbatim.
2. Defaults: runner config, CLI argument defaults, timeout and parallelism knobs.
3. Architecture docs and READMEs. Read less, obeyed less, lower urgency.

## What this skill is not

Not a license to remove machine-enforced invariants (verifier-gated completion marks, landing
transactions, human decision gates, plan-only modes). Those are enforcement, not prose, and
deleting them breaks the machine rather than de-hedging it. Their prose duplicates are still
fair game: state each once, delete every echo.

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `../hedge-audit/SKILL.md`, which classifies the caution the model left in the code rather than the docs.
