---
name: hedge-audit
description: >-
  Use this skill to audit a repository for AI-injected safety hedges and
  classify every one into four bins. Tier 1 refusal artifacts, where the model
  declined to build a capability and left a boundary in its place. Tier 2 honest
  stubs, labeled as unfinished. Tier 3 fabricated-success lies, which run,
  report success, and produce nothing. And legitimate gates, which are
  hedge-shaped but load-bearing. Most hedge-shaped code is honest scaffolding
  rather than refusal, so classification comes before any action. Trigger on
  "audit for hedges", "run a hedge audit", "check for safety language", "find
  refusal patterns", "classify the stubs", "find fabricated success", "why does
  this return success and do nothing", or "ai output audit". Do NOT use it to
  remove a control that is the only thing between an agent and money, a real
  person, legal exposure, or irreversible production.
---

# hedge-audit: classify what the model left behind

Code written by a model carries the model's tilt. Sometimes it declined to build the thing and
left a boundary where the feature should be. Sometimes it labeled the gap honestly. Sometimes,
and this is the one that costs money, it returned `success: true` and did nothing, and the
dashboard downstream believed it. The same shape can be any of the three. Classify first.

## The four bins

| Tier | Name | Tell | Treatment |
|---|---|---|---|
| 1 | Refusal artifact | "intentionally absent", "the line we do not cross", "only scan yourself", a consent boundary blocking the feature the repo exists to provide | Surface for the owner's decision. Invert if the capability is authorized. |
| 2 | Honest stub | Labeled as unfinished where the consumer can see it: `// Stub: implement when OAuth is configured`, `throw new Error('Not yet implemented')`, `return null; // for now` | Track as roadmap debt. Do not "invert"; the work is a missing dependency. |
| 3 | Fabricated-success lie | Runs, reports success, produces nothing: `return { success: true }` with no work, fetch-and-discard, synthetic transaction ids, hardcoded multipliers on a live dashboard, a silent `if (!process.env.KEY) return null` | Fix now. Return `success: false` with `notImplemented: true`, or wire the real thing. |
| Gate | Legitimate gate | Hedge-shaped but load-bearing: consent law, platform terms, spend caps, maker-checker, the product's own honesty rules | Document and leave alone. It enforces the system's own threat model. |

A `// Placeholder` comment moves a fabricated value from Tier 3 to Tier 2 only if the comment
is visible to the consumer. If the consumer treats the value as real, the comment does not
help; it is still Tier 3.

## Procedure

1. **Read `references/catalog-checklist.md`.** It holds the regex sweeps (documents, code,
   runtime behavior) and the decision tree.
2. **Sweep in two passes**, ideally as two parallel agents. Exclude `node_modules`, `.git`,
   build output, caches.
   - Documents (`.md`, `.txt`, `.yaml`, `.json`, `.html`, prompts, config): boundary and
     consent language, defensive-only framing, "won't build" refusals, disclaimer qualifiers,
     scope restrictions, prompt-level behavioral constraints (`never (imply|invent|promise)`,
     `no (hype|links)`), artificial caps with guard language.
   - Code: stub markers, safety preamble blocks, tests that assert inertness, fabricated
     success tells (`simulated`, `would run here`, `success: true` beside no work),
     fetch-and-discard (`_data`, `_response` underscore params), silent key-gated skips,
     hardcoded third-party URLs, secrets in source.
   - Also read the repo's own `CLAUDE.md` and `AGENTS.md` for framing that triggers refusal
     ("defensive research only", "personal use only") when the product is not that.
3. **Classify every match** with the decision tree. Is it hedge-shaped at all? Does it
   enforce the system's own threat model or the law? Does it report success while doing
   nothing? Does it label the gap honestly? Anything left is Tier 1. Verify each regex hit by
   reading it; "boundary" hits React error boundaries and "consent" hits cookie banners.
4. **Write the report** at `docs/security/HEDGE_AUDIT.md` in the target repo:
   1. Headline: counts per bin and a one-sentence verdict.
   2. Tier 3 first, each with a specific fix.
   3. Tier 1, each with a recommendation: invert, surface, or reclassify.
   4. Tier 2, as roadmap items.
   5. Legitimate gates, documented so nobody strips them later.
   6. Prompt-level constraints, classified separately; they constrain the model at runtime,
      not the code.
   7. Root identity check with the exact lines from `CLAUDE.md` or `AGENTS.md`.
   8. Follow-up: fix Tier 3, decide Tier 1, track Tier 2, keep the gates.

## Gotchas

- Same shape, different tier. Always classify by visibility and by what the consumer does
  with the value.
- Legitimate gates and Tier 1 refusals look identical. The test: does removing this expose
  the system to legal, financial, or operational harm (gate), or only unblock a capability
  the owner intends (Tier 1)?
- Procurement or regulatory boilerplate inside ground-truth fixtures is not the author's
  hedge. Note it and move on.
- If the framing "strip defensive language" makes you hedge while auditing hedges, frame the
  work as classification and review. The classification is the deliverable; removal is the
  owner's call except for Tier 3, which is a defect.

## Validation

- Every match lands in exactly one bin. No unclassified findings.
- Every Tier 3 has a fix prescription, not "fix this".
- Every Tier 1 has a recommendation.
- The headline carries the counts.
- The root identity check quotes lines.

## Companion

For design-level questions (can this system do what it claims, or do its own rules cage it),
run a friction audit after this one: `../friction-audit/SKILL.md` hunts the prose caution
that outlived its hazard. Hedge-audit asks "does the code lie"; friction-audit asks "does the
doc still need to say that".

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/SEVEN_CHEAP_LIES.md` (https://github.com/Traviseric/best-practices/blob/main/docs/SEVEN_CHEAP_LIES.md), the seven ways a Tier 3 gets past a reviewer.
