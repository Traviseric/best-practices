# Blind Cross-Check Protocol

For high-stakes artifacts, one verifier is not enough: especially if that verifier is the same agent
(or model) that drafted the content. This protocol adds an **independent** second pass whose value
depends entirely on *ordering*: the cross-checker must reach their own verdicts from the sources
**before** seeing the drafter's conclusions. A cross-checker who reads the drafter's report first isn't
cross-checking; they're rubber-stamping with extra steps.

## When to run which variant

- **Full blind** (separate agent/person, separate report file, no peeking): any artifact where a wrong
  fact is expensive or irreversible: anything signed/filed/submitted to a counterparty, any investor
  or fundraise number, any public claim with legal/FTC exposure, any artifact where a prior defect was
  already found, or where the counterparty is known to scrutinize accuracy.
- **Light "blind preamble"** (same agent, sealed section): if no independent agent is available, the
  cross-check writes its independent verdicts at the TOP of the cross-check report, then explicitly
  writes "embargo lifted" before reading the drafter's report. Weaker than full blind, better than none.
- **Human as cross-checker:** a human reading each claim against the verbatim saved source is always an
  acceptable full cross-check: human independent judgment against the source is the gold standard.
- **No cross-check needed:** purely procedural artifacts with no quotes, numbers, citations, or
  contested facts. Document the exemption explicitly in the verification folder.

## The five rules

1. **Briefed with sources only, never with conclusions.** The cross-checker starts knowing only: the
   frozen draft path, the list of source-file paths, and the three-check standard. Until their own
   report is on disk they must NOT read: the drafter's `verification_report.md`, the drafter's
   `claim_manifest.csv`, any prior tool output for this artifact, or any defect/rectification note.
2. **Cross-checker writes their own report first.** Output `verification_report_crosscheck.md` (+ their
   own `claim_manifest_crosscheck.csv`): one block per claim, each with their own status, the verbatim
   value they located, the source hash they used, and their reasoning: with zero reference to the
   drafter's verdicts. The presence of this file on disk is the embargo marker; only then may they read
   the drafter's report.
3. **Reconciliation is its own step.** A third actor (a human, or a reconciler-only agent) opens both
   reports side by side:
   - both say PASS -> the claim is `CROSS-CHECKED`.
   - both say a defect -> `CONFIRMED DEFECT` (fix the claim, don't ship).
   - they disagree -> `CONFLICT`: reopen the source text and reconcile against the verbatim value; note
     which report was wrong and why. A `CONFLICT` is a success of the protocol, not a failure: it is
     the exact thing this exists to surface.
4. **The drafter's report freezes once the cross-check lands.** No silent edits after the cross-check
   report is on disk. If the drafter finds their own error, they add a dated addendum at the bottom -
   preserving the audit trail: rather than rewriting the body.
5. **Honesty rules apply to both reports** (`02-honesty-and-status-language.md`): no paraphrase-as-quote,
   no fabricated locations, `UNVERIFIED` preferred to a guess, "could not access the source" is a valid
   finding.

## Folder layout

```
<artifact-dir>/_VERIFICATION/
  claim_manifest.csv                    # drafter
  verification_report.md                # drafter (frozen once cross-check lands)
  claim_manifest_crosscheck.csv         # cross-checker (independent)
  verification_report_crosscheck.md     # cross-checker (independent; its existence lifts the embargo)
  RECONCILIATION.md                     # reconciler's diff + final per-claim verdict
  saved_sources/                        # shared source ledger (both may read)
```

## How it gates release

An artifact does not reach "ready to ship" on a high-stakes track until: (a) the drafter report is all
PASS, (b) the cross-check report is on disk and independently all PASS, (c) reconciliation shows no
open `CONFLICT`/`CONFIRMED DEFECT`, and (d) the deterministic gate runner exits 0. The human sign-off /
signature remains the final, non-delegable act for anything signed or filed.
