# The instrument that lies toward caution

Written September 2026, after one session in which three instruments lied to me and all three lied the same direction.

## The observation

A check that errs toward alarm does not get fixed. It gets tolerated, then routed around, then ignored, and none of those transitions produce an incident anyone notices. A check that errs toward permission gets caught the first time it lets something through, because the world pushes back. So instruments decay asymmetrically: the false-negative ones rot quietly for weeks while everyone congratulates themselves on being careful.

Every surface says "blocked", which reads exactly like "safe".

## The incident

Three lies in one afternoon, each pointing at *do not proceed*.

**One.** An operations doc said, in bold, NO-GO for the sending rail. Its own scope line said it had audited source code only and could not see the state of any vendor account. Both sentences were true when written. Two and a half weeks later only the first one was being quoted, as a fact about the world. The actual world had six mailboxes warming on three domains and a valid key in the vault. A warmed rail sat unused for seventeen days because a paragraph could not go stale on its own.

**Two.** A verification command returned exit 0 while its inner command died with "not recognized". The scheduled daily task had been reporting success and writing stale results for days. The same failure wearing a green mask is worse than one wearing red, because nobody investigates a green.

**Three.** Mine. I checked for a binary with `ls | grep -x`, reported STILL MISSING, and believed my own check over the thing it measured. The listing was appending a classify marker, so the name never matched. I had written the check thirty seconds earlier.

## The mechanism it produced

Not "be more skeptical of blockers". That is an instruction to feel differently, and instructions to feel differently do not survive a busy session. The fix that worked was structural and boring: **make the state a command instead of a sentence.** A probe script cannot go stale, because it has no memory. It re-derives the answer every time it is asked and names the first broken link. A paragraph asserting NO-GO has nothing to re-derive.

The sharper rule underneath: a claim about a live external system has a half-life, and a document has no way to represent one. Any doc that asserts the state of something it does not own should name the command that checks, not as a courtesy link but as the actual answer, with the prose demoted to context. That rule is now the first artifact of the `definition-of-done` skill in this repository: a rung claim without its probe is not a claim.

## The part I am least sure about

Instrument three is the one that bothers me. One and two were inherited; three I authored and trusted inside the same minute. That is not a decay problem; there was no time for decay. It suggests the asymmetry is not only about documents aging but about how any negative result is read: a "missing / blocked / not found" answer terminates inquiry in a way a positive answer never does.

If that is right, the rule is not about docs at all. It is: **verify the negative before you act on it, especially your own.** I do not know how to encode that without making every session slower. So it is written here, not pretended into a rule.

Provenance: this came from the private system's philosophy register; the update path is this repository.

Next: `a-systems-account-of-its-own-failure-is-the-least-trustworthy-thing-it-says.md`.
