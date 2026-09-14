---
name: clarity-gate
description: Judge whether a page or document actually communicates to a stranger in the first five seconds. Works on any homepage, landing page, README, report, proposal, or email that a person who did not ask for it has to understand. Uses reader simulation and line-editing passes run by a model, not a banned-word list. Trigger when someone says a page is a "wall of text", "says nothing", "is this clear?", "does my homepage make sense?", "first five seconds", "review this copy for clarity", "it reads generic", or before sending any page or report to a real person who has never seen it.
---

# Clarity Gate: does this page say anything?

A page can be accurate, load fast, have every button working, and still leave the
reader with no idea what they were just told. Tests and fact checks cannot see that
failure. Only a judge that reads the page as the intended person can.

This gate pairs with two siblings that may also live in your repo:

- `verification-gate` proves the facts are true.
- Your functional tests prove the page works.
- **This gate proves the page means something to the person reading it.**

## Why not a linter

A banned-word list optimizes word choice when the problem is meaning. It passes a
page that says nothing, fails a page that communicates perfectly, and is blind to the
failure that actually loses the reader: content that is accurate but about the wrong
thing. A window installer graded on "general contractor" searches passes every lint
rule ever written and loses the customer in four seconds. Only a judge that understands
who the page is for catches that.

Use word lists as a hint to the judge, never as the gate.

## Run it

### 1. Capture the surface as the reader meets it

Screenshot, do not read source. This gate is about what a page communicates visually
in five seconds; the DOM cannot prove that. Capture:

- `first-screen.png`: the viewport only, no scrolling. This is the five-second crop.
- `full.png`: the whole page.
- `mobile.png`: the first screen at phone width.
- `text.txt`: every line of visible text, in order.

Any screenshot tool works (a browser automation script, a headless browser, or a
manual screenshot). For a README or email, the "first screen" is what fits above the
fold in the reader's client without scrolling.

### 2. Build the reader

Not "a small business owner" or "a developer". The specific person. Who they are,
what they were doing when this landed in front of them, what they already believe,
what they are proud of, what they would be defensive about, and whether they asked
for this. A judge simulating a real person gives real reactions. A judge simulating a
demographic gives marketing copy.

If the reader is returning (a customer logging in for the third time, a teammate who
read the last version) carry that state into the persona.

### 3. Three passes

Run them blind and independent. Never tell a judge what the page is trying to say;
that is the whole measurement. Never let one judge see another's output.

Prompts are in `references/JUDGE-PROMPTS.md`.

| Pass | Input | Answers |
|---|---|---|
| A. Five-Second Reader | `first-screen.png` only | Did they learn who this is for, what it offers or says is wrong, and what to do next? Would they act? |
| B. Line Editor | `text.txt` + `full.png` | Which sentences are about the writer instead of the reader? Which numbers have no comparator? A rewrite for each. |
| C. Skeptic | everything + what the writer actually knows about the reader | What is wrong, generic, or automated-looking enough to make the reader dismiss it? |

### 4. Consensus, not one score

A single model's judgment of the same page varies noticeably between runs. Run Pass A
with three different personas and keep only findings that two or more raise
independently. Pass C findings are kept if any judge raises them and the claim
survives a check against what you actually know; a real relevance error is not a
majority question.

### 5. Verdict

**PASS** requires all of:

- Two of three readers correctly state who the page is for and what it offers or
  says is wrong.
- Two of three name the same first action.
- Zero surviving Pass C relevance errors (content about the wrong reader, market, or
  problem).
- Every number in the first screen has a comparator, or is not in the first screen.

Anything else is **BLOCK**, with the rewrites attached. A page that blocks is not sent
to a real person.

## What good output looks like

Not "the copy is vague." Every finding names the exact string, why it fails, and the
replacement:

```
BLOCK . relevance
  "0 of 27 map positions"  was measured on "general contractor" searches
  for a window-and-door company. The verdict may be false and the reader
  will know it. Re-measure on their trade before this goes out.

REWRITE . about-us
  was: "92/100 across 100% of the rubric; 17 explainable checks."
  now: "Your site loads fast and Google can read every page."

REWRITE . no-comparator
  was: "Reviews 79/100"
  now: "12 reviews behind the three companies showing up above you."

REWRITE . wall-of-text
  was: four paragraphs of background before the first sentence about the reader
  now: one sentence that names the reader's problem, then the offer, then the button.
```

## Applies to

Homepages and landing pages. READMEs. Reports and audits sent to the person they are
about. Proposals and pitch emails. Dashboards a customer sees. Any page where you
report a judgment or make an offer to someone who did not ask for it.

Trigger it automatically when finishing any of those, and whenever someone says a
page is confusing, generic, "says nothing", or a wall of text.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/room-and-ground/SKILL.md`.
