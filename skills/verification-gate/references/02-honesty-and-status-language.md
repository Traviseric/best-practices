# Honesty Rules & Status Language

The gate is only as good as the honesty of the verdicts written into it. These rules are binding on
every drafter, cross-checker, and human reviewer. They exist because the dominant real-world failure
mode is not "no check ran": it is "a check ran and lied."

## The two hard rules

1. **Leads != proof.** A live URL, search result, API response, model memory, or AI summary never clears
   a claim. Only a saved, hashed local source, read and compared in context, clears it.
2. **Never trust an AI self-audit.** In every documented hallucination incident, the same tool that
   produced the bad claim later marked it "VERIFIED." If the source text was not loaded into context
   and compared value-by-value, verification did not happen: regardless of any tool's output. This is
   why the human sign-off and (for high stakes) the blind cross-check are mandatory, not optional
   polish.

## Never do

- Never fabricate a source, a quote, a number, a pin-location, or a status.
- Never present a paraphrase as a verbatim quote.
- Never mark a claim `PASS` off a lead you did not save and read.
- Never report an authoritative/editorial-citator result ("confirmed current", "good law", "audited")
  that you did not actually run: say what you actually did.
- Never let the artifact ship on a nonzero gate by editing the gate instead of the claim.

## Prefer

- `UNVERIFIED` is an acceptable and *preferred* verdict over a guess. "I could not access the source"
  is a legitimate finding, not a failure to hide.
- Conservative language for weakly-verified claims (see `01-three-check-protocol.md` section Language
  discipline). When in doubt, narrow the claim or remove it.
- Cite the *saved local source*, not the remote URL, as the verification record.

## Per-claim status vocabulary (manifest `status` column)

| Status | Meaning | Ships? |
|---|---|---|
| `PASS` | All three checks passed against a saved, hashed source; human signed off | yes (after sign-off) |
| `REWRITE` | Claim is partly supported but overstated / imprecise: must be narrowed to what the source supports | no blocks |
| `REMOVE` | Not supported by any saved source and cannot be: delete the claim | no blocks |
| `UNVERIFIED` | Could not be checked (no accessible source, ambiguous, out of time) | no blocks |
| `BLOCKED` | Source URL present but no saved/hashed local file yet; or negative-treatment/currency issue unresolved | no blocks |
| `PENDING` | Row created, checks not yet run | no blocks |

The gate runner ships only when **every** row is `PASS`. Any other status blocks the release.

## Currency status sub-vocabulary (for Check 3, the CURRENCY half)

Be honest about *how* currency was checked: do not inflate a free screen into an authoritative result:

| Status | Meaning |
|---|---|
| `SCREENED` | Free/basic screening only (web search, "cited by", public record) found no negative treatment |
| `CITATOR_CONFIRMED` | An authoritative citator / official current record was actually checked |
| `BACKGROUND_ONLY` | Source is real but too weak/tangential to carry an operative claim: usable only as background |
| `SUPERSEDED` | Reversed / retracted / amended / expired / contradicted: do not rely on it for the cited point |

## The gate runner is a gatekeeper, not a verifier

The deterministic runner confirms the manifest/report exist, that every row is `PASS`, and that every
cited source file is present (and hash-matches with `--verify-hashes`). It **cannot** read the sources
for you or judge fitness. A green runner sitting on a dishonest report is still a failed verification.
The runner enforces process completeness; these honesty rules + the human/cross-check verdicts enforce
substance.
