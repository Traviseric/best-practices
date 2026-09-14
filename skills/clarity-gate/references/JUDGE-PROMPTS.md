# Judge prompts

Three passes. Run blind: a judge is never told what the page is trying to say, never
sees your style guide, and never sees another judge's output. The moment a judge
knows the intended message it starts confirming it instead of discovering it.

Fill the braces from what you actually know about the reader. If you do not know
something, leave it out rather than inventing it.

---

## Pass A: The Five-Second Reader

**Input:** `first-screen.png` only. Not the full page, not the text file. If the
reader has to scroll to answer, the answer is no.

**Run three times with three different personas.** Personas are built from the real
audience, not invented.

```
You are {NAME}, {AGE}, {WHO THEY ARE AND WHAT THEY DO}. {HOW THEY SPEND THEIR
DAY}. {WHAT THEY ARE PROUD OF}. {WHAT THEY ARE DEFENSIVE ABOUT}. {WHAT THEY
ALREADY BELIEVE ABOUT THIS TOPIC}.

You did not ask anyone to send you this. Someone you have never met just put
it in front of you. You are between tasks and you are looking at it on your
phone.

Look at this image for five seconds. Then answer as yourself, plainly, in your
own words, the way you would talk. Do not analyze the design. Do not be polite.
If you do not know, say you do not know.

1. Who is this for? Say the name or the kind of person if you can tell.
2. What is the one thing it says is wrong, or the one thing it offers?
3. What would you go do about it?
4. Would you reply, click, or keep reading? Why or why not?
5. Was anything confusing, insulting, or wrong?
6. Did anything make you sit up, a moment where you thought "huh, I didn't
   know that"? What exactly?

Then, separately and honestly:
- subject_understood: true/false
- point_understood: true/false
- action_named: the action in your words, or null
- would_engage: 0-5 (0 = close it, 5 = act on it today)
- aha_moment: what caused it, or null
```

**Read the output for what they did not say.** A reader who describes the page ("it's
some kind of page about a software tool") instead of its content has failed question
2 even if they sound satisfied.

**`aha_moment: null` across all three readers is a BLOCK on its own** for any page
whose job is to earn a reply or a click. A page that surprises nobody has no reason
to exist.

---

## Pass B: The Line Editor

**Input:** `text.txt` + `full.png`.

```
Below is every line of text from a page written for {READER}, who did not ask
for it.

For EVERY sentence, classify it:

  THEM        about the reader: their problem, their situation, their money,
              their outcome
  US          about the writer: our process, our tools, our thoroughness,
              our scoring, our story
  SCAFFOLDING transitional or explanatory text that carries no information
              (section preambles, "this page is organized around...", labels
              describing other labels)

For every US and SCAFFOLDING line, decide one of:
  DELETE            nothing is lost
  MOVE_TO_METHOD    real, but belongs behind a "how this works" link
  REWRITE           there is a fact for the reader buried in it

If REWRITE, write the replacement. Plain words. Something the reader would say
to a friend at dinner. Never longer than the original.

Then, separately:

NUMBERS: list every number shown to the reader. For each: does it carry a
unit AND something to compare it to? If not, either supply the comparator
from the page's own content, or mark it MOVE_TO_METHOD. A bare score out of
100 with nothing beside it is always a failure.

TERMS: list every word or phrase this reader would not use themselves
(jargon, internal names, product names, metrics, acronyms). For each: is it
defined in plain language in the same sentence? If not: DEFINE_IN_PLACE
(write the definition) or CUT.

DENSITY: if the first screen has more than three paragraphs before the first
sentence about the reader, say so, and write the one sentence that should
come first.

Return only the findings, each with the exact original string. No summary.
```

---

## Pass C: The Skeptic

**Input:** the page, plus what the writer actually knows about the reader (their real
situation, market, competitors, what was actually measured or done).

This is the pass that catches the failures that matter most, and the only one that
needs the background data.

```
You are {READER}, and you are already skeptical. You get pitched constantly
and you assume this was generated.

You know your own situation better than anyone. Here is what the page says
about you or to you, and here is the background behind it.

Find every place where:

1. WRONG TARGET: it measures, compares, or judges you against work you do not
   do, people you do not serve, or problems you do not have. You would spot
   this instantly and it would end the conversation.

2. GENERIC: a sentence that would be equally true of anyone in any situation.
   If it could be pasted onto a competitor's page unchanged, flag it.

3. AUTOMATED TELLS: anything that reveals a machine wrote this without
   understanding you: placeholder phrasing, an empty finding presented as a
   real one, a category that does not fit, a comparison that is not a
   comparison.

4. UNEARNED: a claim, ranking, or judgment the background does not actually
   support.

For each: quote it, say what you would think when you read it, and say
whether it alone would make you stop reading.
```

**A Pass C finding is never a majority vote.** One judge raising a real relevance
error is enough. Verify the claim against the background, and if it holds, it blocks.

---

## Scoring note

Do not average these into a single number. A page that reads beautifully and
addresses the wrong reader is not a 7/10; it is unsendable. Pass A and B produce
improvements. Pass C produces vetoes.
