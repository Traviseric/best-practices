---
name: room-and-ground
description: Use this skill whenever a piece of writing has to move a person rather than only inform one - a homepage, a landing page, a pitch, a proposal, a cover letter, a report an owner or a judge will read, a difficult email. Trigger on "this reads like a wall of text", "make this land", "write the story", "it says everything and nothing", "help me write the paragraph they will actually read", "room and ground", or any request to write something persuasive that must also stay true. It loads the drop-in pack in docs/ROOM_AND_GROUND.md and enforces its one rule - two documents, never one - so the verifiable ground never overwrites the paragraph a person carries out of the room. Do NOT use it for pure reference documentation, code, or anything with no human decider.
---

# Room and ground

Read `docs/ROOM_AND_GROUND.md` in the repo (https://github.com/Traviseric/best-practices/blob/main/docs/ROOM_AND_GROUND.md) in full before writing a word. It is short and it is
the whole method. This file only says how to run it.

## The one rule

Every deliverable that has to move a person is two documents:

- **The room**: one paragraph per person in the story. Who they are, what they want, what is
  in their way, what they have done about it, what happens next and by when. In a voice. No
  hedges, no disclaimers, no table where a paragraph belongs.
- **The ground**: everything verifiable, as cold and complete as you can make it. Sources,
  numbers that reconcile, caveats, the audit.

Write the room first. Then build the ground under it and check every sentence of the room
against it. Never merge them. Never let the ground rewrite the room.

## How to run it

1. Ask which person decides, and what they compress the story into (a buyer: is this for me,
   do they get my problem, will it work; a judge: is this person trying, carrying something,
   do they have a plan; a friend: what do you want me to do).
2. Write the room in that person's language before opening the evidence. One paragraph per
   person. Bold, specific, true.
3. Build the ground: every fact in the room gets a line with its source. Where a sentence has
   no ground, fix the sentence, not the story around the person.
4. Cold read: someone who knows nothing hears the room once. Did they get it, feel it, know
   what to do. Any no and it is not done.
5. Deliver both, clearly labelled, as separate sections or separate files. The room goes on
   the page, in the email, at the top. The ground goes below the fold, in the appendix, in the
   linked doc.

## Marking a room document

Put an HTML comment containing `ROOM:` on the first line of any file that is a room document,
and keep its ground in a sibling file with the same name plus `.ground.md`. Then when a later
session, or a later you, is tempted to add a hedge or a correction banner to the room, the
marker says where that sentence belongs instead.

## What you will catch yourself doing

Hedging inside the room. Turning a narrative into a table. Splitting the audience into two so
the ledger survives. Handing the taste decision back to the human. Each time: stop, ask which
document you are in, file the sentence in the other one.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/ENGINEERING_PRINCIPLES.md`.
