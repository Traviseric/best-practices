# The Three-Check Protocol (full)

The gate exists because a claim can be wrong in qualitatively different ways, and the check that
catches one kind is blind to the others. Apply **all three checks to every checkable assertion**: not
just the cheapest one. This protocol is domain-agnostic; the worked failure modes below are drawn from
a real court AI-hallucination sanction incident but apply to any high-stakes artifact.

## Checkable assertions

Extract one manifest row for each:
- **Quote**: any passage in quotation marks attributed to a source.
- **Number / $ / date**: amounts, counts, percentages, dates, deadlines, IDs.
- **Named fact**: "X did Y", "we hold certification Z", "the account balance was $N on DATE".
- **Citation / reference**: a case, statute, standard, spec, prior document, exhibit, URL-as-authority.
- **Eligibility / capability claim**: "we are a small business", "we have prior experience with Q",
  "our system does R". (These sink grant/contract packets and marketing claims the way fake quotes
  sink filings.)
- **Short-form reference**: "as above", "id.", "that contract", "the same source". Each must map back
  to a verified full-source row; short-forms silently smuggle in unverified claims.

## The failure-mode taxonomy (what each check catches)

| # | Failure mode | Caught by | Note |
|---|---|---|---|
| 1 | **Nonexistent / unsourced**: the reference maps to no real document, or to nothing saved | SOURCE | Cheapest to catch; a "does it exist / do we have a source" check is necessary but **not sufficient**. |
| 2 | **Fabricated / drifted quote or number**: source is real but the quoted/numeric value isn't in it (incl. one-word or one-digit substitution) | FIDELITY | The most insidious class: the fabrication *sounds* right and tracks the domain vocabulary. |
| 3 | **Overstated / wrong-proposition**: source is real and quoted correctly but doesn't actually support the claim as stated (broader than the source; from a caption/aside/summary; wrong scope) | FITNESS | Requires reading the source in context, not a string match. |
| 4 | **Stale / superseded**: everything is accurate but the source is no longer current: reversed, retracted, amended, expired, contradicted by a newer record | CURRENCY | Neither an existence check nor a quote search will ever catch this. |

A single paragraph often carries more than one class at once. A complete verification applies every
check to every claim.

## Check 1: SOURCE

The assertion must trace to a **source file saved locally and hashed**, recorded on the manifest row as
`local_source_path` + `sha256`. A live URL, an API lookup response, a search result, a model's memory,
or an AI research summary is a **lead only** (`leads != proof`).

- Save the highest-authority source available (original/official > primary > reputable secondary).
- Convert PDFs to text/markdown so the later checks can search them.
- A row with a source URL but blank `local_source_path`/`sha256` stays **BLOCKED** until the source is
  saved, unless the report explicitly notes it is an already-hashed local cache file.
- Cheap sanity checks live here too (does the identifier/date/format even make sense).

## Check 2: FIDELITY

For every quote and every number/date, search the **saved local source** (not the URL) for the exact
value:
- Match punctuation, capitalization, word order, ellipses, and brackets for quotes.
- Match digits, units, rounding, and thousands separators for numbers.
- Watch ellipses that bridge non-adjacent passages: they can hide a fabrication inside a real quote.
- If the exact value is not found: remove it, or rewrite as a paraphrase **after** reading the real
  text. A "close" match is a failure: a one-word or one-digit substitution is still false.

## Check 3: FITNESS + CURRENCY

Two questions, both requiring reading the source in context:

**Fitness**: does the source actually support the claim *as stated*?
- Is the claim broader than what the source says?
- Is it leaning on a heading, caption, summary, aside, dissent, or a *reference the source itself made
  to some other authority* rather than the source's own substance?
- Is the context (scope, posture, subject) actually comparable?
- Test: "If an adversary pulled this source and read it cold, would they agree it supports the claim?"
  If uncertain, narrow the claim or drop it.

**Currency**: is the source still true / operative?
- Screen for negative treatment: reversed, overruled, retracted, amended, expired, withdrawn,
  superseded, contradicted by a newer authoritative record.
- Free screening (web search for the source name + negative terms; the source's "cited by"/"how cited";
  the issuing body's current record) is a *screen*, not an editorial citator. Do not report
  "confirmed current / good law" unless an authoritative citator/record was actually checked.
- **Deep-currency for foundational claims:** any claim the whole argument turns on (the main authority,
  a headline number, a binding requirement) gets the stronger check: go to the authoritative
  source/citator when reasonably possible, and use the honest status (`SCREENED` vs `CITATOR_CONFIRMED`)
  from `02-honesty-and-status-language.md`. For background claims, the free screen is enough unless the
  source is old, controversial, or central.

## Language discipline

Match the verb to what the source supports: "held/requires/controls" only for what the source actually
establishes; "states/notes" for what it merely says; "mentions/discusses" for a passing reference;
"suggests/screened" for weakly-verified. Avoid absolute framing ("settled", "always", "guaranteed",
"controlling") unless the saved source verbatim supports it.

## Output of the protocol

Each claim ends as one manifest row + one report block with: the claim, the source path + hash, the
verbatim located value (FIDELITY), the fitness/currency reasoning, and a status. Statuses and their
meaning are in `02-honesty-and-status-language.md`. The report is what a human signs off and what a
blind cross-checker independently reproduces (`03-blind-cross-check.md`).
