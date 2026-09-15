---
name: lamps
description: Run the fixed set of task-independent questions (the lamps) that light the regions a task-as-posed leaves dark - who decides and what they must find, what they default to, who argues against us, where the biggest expected loss is, the decision we lose in the decider's voice, what proves each finding, what paragraph the decider carries out, what here is not true, what the clock does, and the five questions the user did not ask. Trigger at four moments for any deliverable a person will decide on (a landing page, an offer, a proposal, a release, a client deliverable, a plan) - T0 intake ("we're about to build", "plan this", "prep for"), T-mid ("the draft is taking shape"), T-ship ("ready to ship/send", "final review"), T+outcome ("the answer/numbers came in"). Also on "run the lamps", "what am I not asking", "edge pass", "premortem", "who decides this", "what's the frame". Not for verification (verification-gate) or the paragraph (room-and-ground) - it tells those where to look.
---

# lamps: run the questions the task did not ask

The model does not know what it is not asked. Everything it could say is latent until a
prompt conditions it, so the regions nobody asked about stay dark, and the decider finds them
first. The lamps are a fixed set of questions, run blind and in parallel at fixed moments,
independent of the deliverable. Read `philosophy/lighting-the-abyss.md` (https://github.com/Traviseric/best-practices/blob/main/philosophy/lighting-the-abyss.md) once for why.

## The set

| Lamp | Question |
|---|---|
| DECIDER | Who decides this, and what are they required to find or do? List every required finding with its source. |
| FRAME | What does this decider default to when not moved? What category do they reach for? How long do they have? |
| ADVERSARY | Who fills the required findings against us, and with what question or fact? Write their examination or their pitch, from their side. |
| LOSS | For each issue: probability it goes against us times cost if it does. Rank. Name the one that should scream. |
| PREMORTEM | It is the day after. We lost. Write their decision in their voice. List which of our own sentences appear in it. |
| EVIDENCE | For each required finding: what proves it, do we have it, does it survive a skeptical reader? |
| STORY | What paragraph does the decider carry out about each person? Who wrote it, us or them? |
| TRUTH | Which sentences are unsourced, untrue, or not ours to say? |
| TIME | What is the clock, who set it, what pauses it, what happens the day after it runs? |
| EDGE | The five questions the user did not ask that would most change the outcome, ranked, one-line answers. |

## The moments

| Moment | Lamps | Output file (in the deliverable's folder) |
|---|---|---|
| T0 intake, before anything is built | DECIDER, FRAME, ADVERSARY, LOSS | `LAMPS_T0.md`: the map; the build's headings and slot sizes follow the LOSS ranking |
| T-mid, before drafting | PREMORTEM, EVIDENCE, STORY | `LAMPS_TMID.md`: trap list, proof plan, the paragraph |
| T-ship, before it goes out | TRUTH, TIME, EDGE | `LAMPS_TSHIP.md`: ground check, calendar, the five questions and what changed |
| T+outcome | all, scored | `LAMPS_SCORE.md`: each lamp's answer against what actually decided; a surprise log entry |

## How to run

1. **Name the moment and the deliverable.** State which of the four moments this is and point
   at the deliverable's folder and its sources.
2. **Run each lamp blind and in parallel.** One fresh agent per lamp, given only: the lamp
   question, the sources, and the deliverable if it exists. Never the drafter's notes,
   verification reports, or another lamp's answer. Blind is the whole measurement; a lamp
   that has seen the plan confirms instead of lighting. Each returns a short answer with its
   evidence. If you cannot spawn agents, run the lamps one at a time in fresh contexts.
3. **Reconcile.** Merge into the moment's output file. Where lamps disagree, keep both and
   mark CONFLICT. Where a lamp says "nothing found", say so; a dark region honestly reported
   is the point.
4. **Apply.** The file ends with "What this changes in the deliverable", numbered, each
   naming the artifact it changes. If nothing changes, say why.
5. **At T+outcome, score.** For each earlier lamp answer: HIT (it named what decided), MISS
   (it named something that did not matter), DARK (what decided was in no lamp's answer).
   Every DARK gets a line in a `LAMPS_LEDGER.md` you keep beside your projects: what surprised
   us, which lamp would have lit it, whether that lamp exists. A new lamp enters the set only
   from a DARK line.

## Rules

- Lamps are the same for every room. The deliverable changes; the instrument does not.
- A lamp's answer is a lead, not a verified fact. Truth goes through `verification-gate`;
  the paragraph goes through `room-and-ground`.
- EDGE runs on every substantive deliverable, moment or not. It is the lamp that looks for
  missing lamps.
- Answers prepared under ADVERSARY are true answers to foreseeable questions, never scripts
  toward a conclusion the person does not hold.
- Coverage is mechanical: a deliverable folder without `LAMPS_T0.md` and `LAMPS_TSHIP.md` is
  not done.

## Reference run

The first public run was on the funnel this repository sits in, at T0, with five blind
agents. It found a plugin hook firing on every shell command, a dead link on a page whose
thesis was verification, a paid product that was a public file with no lock on it, and a
paid step pointing at a free course. Three were fixed the same day; the fourth is named as
open. The reconciled map and what it changed are summarized in
`philosophy/lighting-the-abyss.md` (https://github.com/Traviseric/best-practices/blob/main/philosophy/lighting-the-abyss.md).

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `../room-and-ground/SKILL.md`, the skill STORY hands off to.
