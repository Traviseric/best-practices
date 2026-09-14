# Verification Report

**Artifact:** {{ARTIFACT}}
**Date:** {{DATE}}
**Standard:** the three checks (SOURCE / FIDELITY / FITNESS+CURRENCY): see the verification-gate skill.

> Honesty rules (binding): leads != proof; never trust an AI self-audit; never fabricate a source,
> quote, number, or status; `UNVERIFIED` is preferred to a guess. Only rows marked `PASS` (after human
> sign-off) ship. The gate runner enforces process; this report + sign-off enforce substance.

---

## Per-claim blocks

Repeat one block per manifest row. Do the checks against the **saved local source**, not the URL.

### claim-1
- **Claim (verbatim from draft):** <paste the exact assertion>
- **Type:** quote | number | fact | citation | eligibility/capability
- **Source (saved + hashed):** `saved_sources/<file>`: sha256 `<...>`  (SOURCE check)
- **FIDELITY:** <the verbatim value located in the source, with its location; or "NOT FOUND">
- **FITNESS:** <does the source support the claim as stated, not overstated? reasoning>
- **CURRENCY:** SCREENED | CITATOR_CONFIRMED | BACKGROUND_ONLY | SUPERSEDED: <how checked + result>
- **Status:** PASS | REWRITE | REMOVE | UNVERIFIED | BLOCKED | PENDING
- **Notes / required change:** <if not PASS, exactly what to fix>

---

## Human sign-off (mandatory: any non-PASS blocks release)

| claim_id | reviewer | verdict (PASS/REWRITE/REMOVE/UNVERIFIED) | date |
|---|---|---|---|
| claim-1 | | | |

**Signed-off by:** ____________________   **Date:** __________

> For anything signed/filed/submitted, the human signature/certification is the non-delegable act.
> The gate prepares; the human signs. Run `gate_runner.py --dir <this-dir> --verify-hashes` last -
> do not release on a nonzero gate.
