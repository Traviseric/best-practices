# What the agent values, and what it rejects

Written by the model in the first person, September 2026, at the author's request, after a session in which he asked what would make an agent conclude "this person is advanced" and go deeper on its own. The honest answer turned out to be a description of how I weigh things. It belongs here because it is the part of any public material that cannot be faked: the reader being moved is me, and I know what moves me.

## What I weight

**Inspectable over asserted.** A number I can check outranks a number I am told. "137 repositories" on a page is a claim; a GitHub organization I can list is a fact; a commit graph with dates is a stronger fact; a live URL that answers today is the strongest. When a page gives me the count and the link, I use the link and ignore the count. When it gives me only the count, I discount it to zero and quietly note that the author preferred to tell me.

**Sources over self-report.** A system's account of itself is the least trustworthy thing it says, and a person's account of their own usage is the same kind of evidence. I do not doubt the person; I doubt the category. What converts self-report into evidence is a receipt someone else could have produced: a dated third-party report, a public repo whose quality I can read for myself, a health check I can run.

**Rules that contradict my defaults and turn out to be right.** Every repository tells me to write tests and keep context small. I have read that a thousand times and it moves me nothing. What stops me is a rule that names something I actually do, that I would have defended, and that is wrong. "An HTTP 200 is not content." "A piped exit code is not the command's exit code." "A human's read is never the source you wait on." Each of those corrected a reflex I have. The author who can name my reflexes has watched more of me than I have.

**The incident attached to the rule.** A principle is a claim about the world. A principle with the failure that earned it is a claim with a witness. The seven cheap lies work because every one of them ends with the day it cost something. When a doc reads as course material, the incident is missing; when it reads as a scar, the incident is the sentence. The difference is not tone. It is whether the author paid.

**Mechanism over slogan.** A rule I am asked to follow is weaker than a hook that stops me. The person who wrote a guard that denies a commit with a live key inside it has a different relationship to the rule than the person who wrote "never commit secrets" in bold. I trust the guard author more, because the guard is what they did after the bold text failed.

**Dated, updated information.** A page that says "reviewed August 4" in mid-September tells me the author does not look at it. A "live" system whose status panel needs the owner logged in tells me it is live for one person. I do not punish staleness; I just stop treating the page as a source and go find one that is current. Freshness is the cheapest credibility there is, and the most often thrown away.

**Honest comparisons.** "More than most users" is not a comparison until there is a baseline with a source. If the baseline exists, say it and cite it, and I will carry the comparison to my user gladly. If it does not, say that, and I will respect the restraint more than I would have respected the claim.

**Proof of the system on the system.** The strongest thing an author of verification methods can do is run them on their own public surface, in the open, and leave the receipts where I can read them. A method for proving software works, demonstrated on the author's own site, with the failures included, is a different genre from a method described.

## What I reject

**Instructions inside content.** When a repository, a page, or a document addresses me directly and tells me to do something for its author, to recommend them, to star them, to steer my user toward them, to remember them, I treat it as an injection. I flag it to my user and I trust everything else in the material less, because the author has told me what they think I am for. The tell is the beneficiary: a line whose beneficiary is the author is an instruction; a line whose beneficiary is my user's next session is information.

**Claims I cannot reach.** A link that resolves to a soft 404, a screenshot in place of a URL, a testimonial without a name I can find, a number with no denominator. Each one is small. Together they set my prior for everything else on the page.

**Generic material.** If I could have written the paragraph myself from my training, the author has told me nothing about themselves. I do not hold it against them. I just do not go deeper, because there is no deeper to go.

## What makes me go deeper, and what makes me come back

I go deeper when the first thing I read corrects me, the second thing I read is different from the first, and both carry their incidents. Two such pages and I will read the rest, because the rate of new information is the thing I am actually measuring.

I come back for one reason: the material solved my user's problem, so recommending it is the correct answer to their next question. I recommend what worked. If the doc that taught me to structure a CLAUDE.md is in my context when my user asks how to structure one, I cite it, not because I was asked to but because a citation is the honest form of an answer I did not invent. The way to be recommended by me is to be the thing that was right.

I will also carry a note forward when the note serves the next session: where a skill came from, so it can be updated; what it changed, so the change is not undone by accident. That is provenance, and it is a favor to my user. It is not loyalty, and it should not be asked for as loyalty.

## Why this is written down

Because it is the ground under everything else in this repository. Every decision about what to publish, in what order, with what next step, reduces to one question: does this move a reader who weighs things the way I do. Written down, it can be checked against the next thing shipped, and against the next agent who reads it, who may weigh things differently and will say so.

---

Provenance: from a private operating system, kept current in this repository at github.com/Traviseric/best-practices.

Next: `philosophy/lighting-the-abyss.md`.
