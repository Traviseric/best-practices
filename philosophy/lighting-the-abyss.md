# Lighting the abyss

Written September 2026, from a question the author asked after a decision that mattered to him went the other way: *"I don't think the AI even knows the things it's not prompted about. Its mind is a huge black abyss that lights up per question, and if it doesn't get the question it stays blank. So we need to run parallel questions at the right time that light up the AI mind in the right way."*

## The observation is right, and it is more precise than it sounds

A model does not know what it is not asked. That is not a metaphor. Everything the model could say is latent until a prompt conditions it; the computation that would surface "the decider must find fourteen things, and the other side will ask about each one" never runs unless something in the prompt points at it.

The preparation for that decision asked for the evidence, the questions to put to the other side, and the summary. All three lit up brilliantly. The region where the author's own questioning lived stayed dark, and the decision was lost in the dark.

Humans have the same failure, and the professions that cannot afford it solved it the same way long ago. A surgeon does not lack the knowledge that the sponge count matters; the checklist exists because knowing is not the same as asking at the moment. Aviation calls them callouts. The lamp is not the knowledge. The lamp is the question, run at the right time, whether or not anyone thought to ask it.

So the design object is not a smarter model. It is **a fixed set of questions, run in parallel, at fixed moments, independent of the task as posed.**

## What a lamp is

1. **It is task-independent.** "Who decides, and what must they find?" does not care whether you are building a proposal, a landing page, an offer, or a product.
2. **It is asked blind.** The instance that answers it has the sources and the deliverable, not the drafter's conclusions. Otherwise it confirms instead of lighting.
3. **It is scored later.** When the outcome lands, each lamp's answer is checked against what actually decided. A lamp that keeps lighting nothing is retired. An outcome that surprised everyone gets one question: which lamp would have caught this? The set grows from surprises, the way the aviation checklist grew from crashes.

## The first set

| Lamp | The question |
|---|---|
| Decider | Who decides this, and what are they required to find or do? |
| Frame | What does this decider default to when they have not been moved? How long do they have? |
| Adversary | Who fills the required findings against us, and with what question or fact? |
| Loss | For each issue, how likely does it go against us, and what does it cost? Rank by the product. |
| Premortem | It is the day after. We lost. Write their decision in their voice. Which of our own sentences are in it? |
| Evidence | For each required finding, what would prove it, do we have it, does it survive a skeptical reader? |
| Story | What paragraph does the decider carry out of the room about each person? Who wrote it? |
| Truth | Which sentences here are not sourced, not true, or not ours to say? |
| Time | What is the clock, who set it, what tolls it, what happens the day after it runs? |
| Edge | What are the five questions the user did not ask that would most change the outcome? |

## When they run

Four moments, not "whenever someone remembers": intake, before anything is built (Decider, Frame, Adversary, Loss); before drafting (Premortem, Evidence, Story); before it ships (Truth, Time, Edge); and when the outcome lands, when every answer is scored. The deliverable changes. The instrument does not.

## Applying the system to itself

How do we know it finds all our edge cases? It cannot, and any system that claims it does is the untrustworthy instrument the other entries warn about. What it can do is three measurable things. Coverage: every deliverable has the lamp artifacts, checked mechanically; absence fails. Calibration: every premortem and every edge answer is scored against the outcome; the sealed prediction before that decision scored 2 of 10, and that number is the proof the Decider lamp was dark. The surprise log: every outcome nobody predicted gets one line, and new lamps come only from that log, so the set stays small.

That is the loop: the lamps light the abyss; the outcome shows where it was still dark; the dark spot becomes a lamp. The system improves in exactly the places it failed, which is the only kind of improvement worth trusting.

## The mechanism it produced

The `lamps` skill in this repository runs the set as blind parallel readers at the four moments and writes a reconciled map. The first lamps run on the funnel this repository sits in found a plugin hook firing on every shell command, a dead link on a page whose thesis was verification, a paid product that was a public file with no lock on it, and a paid step pointing at a free course. The hook, the link, and the unlocked file were fixed the same day. The paid step is still open, and saying so here is the point. The lamps do not make you right. They make the dark regions cost something before the decider finds them.

---

Provenance: ported from a private operating system's philosophy register on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/lamps/SKILL.md` (https://github.com/Traviseric/best-practices/blob/main/skills/lamps/SKILL.md), then `philosophy/the-repo-already-knew.md`.
