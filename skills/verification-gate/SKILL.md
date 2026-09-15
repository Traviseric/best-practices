---
name: verification-gate
description: >-
  Source-grounded accuracy gate for any document that must be right before it
  leaves your hands, such as a filing, a grant or contract packet, investor
  numbers, a published claim, a public README, or a report sent to a customer.
  Runs three checks on every checkable assertion. SOURCE, meaning it traces to a
  saved, hashed local file rather than a URL or model memory. FIDELITY, meaning
  every quote, number, and date matches that file verbatim. FITNESS and
  CURRENCY, meaning the source actually supports the claim and is still true.
  Then a claim manifest, a report, mandatory human sign-off, an optional blind
  cross-check, and a deterministic gate runner that blocks release until every
  row is PASS. Trigger on "fact-check this", "verify the claims in this doc",
  "before I publish / send / file / submit this", "make sure every number is
  right", "is this 100% accurate", or "don't let a fabricated fact go out". Do
  not trigger for drafting, brainstorming, summarizing, code fixes, or low-stakes
  notes.
---

# verification-gate: source-grounded accuracy gate

Turn "I think this is right" into "every claim is provably traced to a saved source, or it
does not ship." Use it before anything that must be exactly right is filed, submitted, sent,
signed, or published. It is domain-agnostic: legal citations, grant and contract packets,
investor numbers, marketing claims, contract terms, public technical claims.

Born from a well-documented failure mode (courts sanctioning filings with AI-fabricated
citations): a claim can look perfect and still be wrong in three qualitatively different
ways, and the check that catches one class misses the others. So this gate applies all three
checks to every claim, never just the cheapest.

## When to use / not use

**Use it** when the cost of one wrong fact is high and the document is about to leave your
control: filings, packets, proposals, investor docs, public claims, contracts, signed
statements, reports sent to the person they are about.

**Do not use it** for drafting new content, brainstorming, summarizing for yourself, code
fixes, or low-stakes internal notes. This gate verifies finished content; it does not create it.

## The one rule that makes it work

**Leads are not proof.** A live web page, a search result, an API response, a model's memory,
or an AI research summary is only a lead. A claim is verified only against a source file saved
locally and hashed, read in this context. Corollary: **never trust an AI self-audit.** In every
documented hallucination incident the same tool that produced the bad claim also marked it
"VERIFIED." If the source text was not loaded and compared, verification did not happen, no
matter what any tool reported.

## The three checks (all three, on every checkable assertion)

A checkable assertion is any quote, number, dollar amount, date, named fact ("X did Y", "we
hold certification Z"), citation or reference, or eligibility and capability claim.

1. **SOURCE.** The assertion maps to a saved, hashed local source (path plus SHA-256 recorded
   in the manifest), not a live URL, lookup, or model memory. Catches fabricated or unsourced
   references.
2. **FIDELITY.** Every quoted passage and every number or date matches the saved source
   verbatim at the cited location (punctuation, ellipses, brackets, units, rounding). Search
   the exact string; a paraphrase or a one-digit substitution is a failure. Catches drifted
   quotes and numbers.
3. **FITNESS and CURRENCY.** The source actually supports the claim as stated (not broader
   than the source says; not from a caption, summary, or aside), and the source is still true,
   not reversed, amended, expired, or superseded. Catches overstated and stale claims.

Full protocol, failure-mode taxonomy, and worked examples: `references/01-three-check-protocol.md`.

## Procedure

1. **Freeze the draft.** Save the exact text being verified. Never verify one version and ship
   another without re-running the gate.
2. **Scaffold the verification folder** next to the document:
   ```
   python scripts/scaffold_gate.py --artifact <path-to-draft> [--out <dir>]
   ```
   Creates `<artifact-dir>/_VERIFICATION/` with `claim_manifest.csv`,
   `verification_report.md`, and `saved_sources/`.
3. **Extract every checkable assertion** into `claim_manifest.csv`, one row each. Include
   short-form references ("as above", "that contract", "the same source") mapped back to their
   full source row.
4. **Save and hash each source** into `saved_sources/` (download the real document; convert
   PDFs to text first). Record `local_source_path` and `sha256` on the row. A row with a URL but
   no saved local file stays **BLOCKED**.
5. **Run the three checks** against the saved local source, not the URL. Write per-row findings
   (verbatim value located, fitness reasoning, currency result) into `verification_report.md`
   and set each row's `status`.
6. **Use honest status language.** See `references/02-honesty-and-status-language.md`.
   `UNVERIFIED` is an acceptable and preferred verdict over a guess.
7. **Human sign-off (mandatory).** A human opens each saved source and the report and marks
   every row `PASS`, `REWRITE`, `REMOVE`, or `UNVERIFIED`. Any non-PASS blocks release. For
   anything signed or filed, the signature is the non-delegable act: the gate prepares, the
   human signs.
8. **Blind cross-check (high stakes).** See `references/03-blind-cross-check.md`. An
   independent pass reaches its own verdicts from the sources before reading the drafter's report.
9. **Run the gate** (deterministic; it checks structure and status, it does not re-verify):
   ```
   python scripts/gate_runner.py --dir <artifact-dir>/_VERIFICATION [--verify-hashes]
   ```
   Exit 0 means every row is PASS and every source is present (and hashes match with
   `--verify-hashes`). Nonzero means blocked, with the offending rows listed. Do not release
   on a nonzero gate.

## Honesty rules (binding)

- Never fabricate a source, quote, number, or status. If it cannot be traced, the row is
  `REWRITE` or `REMOVE`, never invented to fill the cell.
- Prefer conservative language for anything verified only weakly ("secondary source",
  "screened, not confirmed against the official record").
- The gate runner is a gatekeeper, not a verifier. A green runner on a lying report is still a
  failure. It enforces that the verdicts exist and are all PASS; it cannot read the sources for you.

## Gotchas

- **PDFs:** convert to text before the FIDELITY search. A scanned PDF with no text layer cannot
  be searched; OCR it first or mark the row `UNVERIFIED`.
- **Short-form references** silently reintroduce unverified claims. Every one maps back to a
  verified full-source row.
- **Numbers drift** the same way quotes do. Check units and rounding, not just digits.
- **Green CI is not accuracy.** A build can pass and a claim still be fabricated. This gate is
  orthogonal to tests. If your repo also uses `definition-of-done`, that ladder proves the
  feature works; this gate proves the words about it are true.
- **Self-grading.** The agent that wrote the claims must not be the sole verifier of them.
  That is the documented failure mode. Use the human gate, and the blind cross-check for high stakes.

## Validation loop

- Prove the runner works: `python scripts/gate_runner.py --self-test` builds a passing and a
  failing fixture and asserts the gate behaves. Exit 0 on success.
- Success for a real document: the runner exits 0 and a human has signed off every row. If it
  exits nonzero, read the blocked rows, fix the claim (rewrite, remove, or source it),
  re-verify that row, and re-run. Never edit the gate to ship.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/definition-of-done/SKILL.md`.
