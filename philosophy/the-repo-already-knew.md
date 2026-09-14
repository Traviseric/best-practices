# The repo already knew

Written September 2026, from one long session of strategy work: a competitor teardown, positioning, an offer, homepage copy.

## The observation

Almost every finding of consequence in that session took the same shape. Not *we need to build X*. Not even *we were wrong about X*. It was:

> We already built X, ran it, filed the result, and then made a decision as though it did not exist.

Six instances in one session, counted only because they started to feel repetitive: a way to build a niche-specific site (shipping, five verticals, off a typed contract); a brand playbook (a portable style recipe already generated from the brand file); press targets for a trade (a catalog carrying that trade's publication and its award); an offer template (a seventeen-dimension scorecard with a schema, a validator and an approval floor); whether our own offer was any good (our own packet, scored a month earlier, ten dimensions below floor, unread); who our competitors were (eleven studies and a scorecard whose "required response" column was a task list).

And the sharpest one, because it was mine: an author-marked decision sat in a code comment three lines above the line I changed, and I reversed it without reading it. He caught it. His reason and the comment's reason were the same reason.

## What is actually going on

The obvious reading is a discovery problem: too many files, weak indexes, fix it with better search. I do not think that is it, because the material was not hard to find. The competitor studies were in a directory called `competitors/`. The scorecard was in a doc with "offer" in its name. I found each one in a single grep, after I had already decided what I thought.

The pattern is not that retrieval failed. It is that **retrieval was never attempted, because the work felt generative.** Reading a source, forming a view, writing copy: that is making something, and making does not feel like the kind of act that needs a literature review. Auditing feels like a separate task you do on purpose. So the check gets skipped precisely when the work feels most productive.

Which means the failure has a signature, and the signature is **fluency**. The faster a decision arrives, the less likely it was checked. Not because speed causes error, but because the decisions that arrive fast are the ones that felt like they did not need checking.

## Why this matters more in a documented system

A system that rewards documentation accumulates a large surface of prior decisions, and every one of them is a landmine for a future session that decides confidently. The cost of a decision is no longer just being wrong. It is silently overwriting someone who was right, which is worse, because the overwrite carries the authority of a fresh commit.

There is a darker corollary. If a system's knowledge grows faster than any session's ability to consult it, then past a certain size the marginal document does not add capability. It adds a new way to be confidently wrong. The lookup table exists to fight this. It is not obvious it is winning.

## The mechanism it produced

Not a rule about reading indexes; that rule existed and did not fire. Something narrower and mechanical enough to survive being ignored:

> Before changing a public surface or reversing a default, read the comments in the region you are editing. Not the file. Not the docs. The twenty lines around the change. That is where the last person who thought about this left their reasoning, and it costs nothing.

In this repository that is the reason `session-closeout` writes a handoff with the decisions and their reasons next to the paths they touched, and the reason the CLAUDE.md template puts a lookup table, not a narrative, at the top: the next session is always a stranger who decides fast.

## What I would test

Three cheap probes, none of which I have run. When a decision gets reversed, how old was the prior one? If overrides cluster on recent material, the problem is retrieval; if on old material, old decisions have stopped looking like decisions and started looking like scenery. How often is the contradicted decision inside the same file as the change? Do reversed decisions arrive earlier in a session than upheld ones?

Provenance: this came from the private system's philosophy register; the update path is this repository.

Next: `docs/SEVEN_CHEAP_LIES.md`, which is where the fluency signature was first turned into a checklist.

Long form: traviseric.com/writings/the-repo-already-knew
