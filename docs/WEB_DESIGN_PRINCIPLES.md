# Web Design Principles for AI Agents

Thirteen rules, each stated as the thing an agent would have done wrong, each with the site that paid for it and the mechanism that now stops it. They come from one site factory that builds and runs marketing sites for local businesses (gyms, restaurants, roofers, contractors, a bar), mostly by agents, between June and September 2026. Dates are by month. Business names are removed. The mechanisms are real: a screenshot loop, a checklist with a scoring cap, a photo pass, a cold walk on a phone. Several ship in this repository.

If you only read one thing: rule 1. Every other defect on this page was invisible to a build, a curl, and a grep, and obvious in one screenshot.

---

## 1. You would have shipped a page you never looked at

**The rule.** A page the agent has not seen rendered does not exist yet. Build exit codes, HTTP 200s, and grepping for class names are text proxies for a visual product. No screenshots, no ship.

**The incident.** July 2026: a bar's marketing site shipped after every text check passed. The owner's verdict on the live page: "this looks like shit." A muddy hero with the headline on a brown blur, eleven identical staff-pick boxes with no rhythm, all-dark sections mushing together, tiny gallery tiles. Looking back across the factory, every visual defect on every site to that date (orange body text on an orange page at a gym, white-on-white at a builder) had been caught by the founder's eyes and never by the pipeline. The agent had rationalized a dead browser extension into "visual pass pending" and shipped blind.

**The mechanism.** A portable Playwright harness shoots every page at phone (390x844) and desktop (1440x900), full page, after walking the page so lazy images load (a full-page capture without the scroll walk returns black tiles). The composition skill refuses to mark a pass complete without the screenshot paths in the report, and if the harness is blocked it reports the exact blocked command and the word UNVERIFIED.

**Apply it.** Put a shoot script in every site repo and make "screenshot paths in the PR" a review requirement. Never accept "visual pass pending".

## 2. You would have scored your own render and called it good

**The rule.** Critique against best-in-class reference screenshots for the client's archetype, not against your own sense of whether it looks fine. Three to five rounds during composition, not one review after.

**The incident.** Same bar, same month. Round one looked acceptable to the agent that made it. The fix was a library of reference captures (three top bars, phone and desktop) and a rule that composition starts by ripping structure, rhythm, and motion choreography from a reference (never its images, copy, or brand). The home page reached rubric-clear in four rounds against those references. First-render blindness is exactly what the loop exists to catch, so round two is mandatory even when round one scores well.

**The mechanism.** Step zero of every design flow is capture-and-autopsy of a reference. A model transforms a concrete reference far better than it generates taste from nothing.

**Apply it.** Keep a `design-references/<archetype>/` folder of full-page captures. Write the autopsy (what the reference does with rhythm, surfaces, motion) before the first line of markup.

## 3. You would have shipped the client's photos raw

**The rule.** Client and founder photos never ship as uploaded. They pass a brand-grade treatment (consistent tone, deep blacks, one accent glow) so the set reads as one shoot.

**The incident.** July 2026: the bar's eighteen owner-supplied photos were converted and dropped in. Mixed white balance, mixed exposure, one at a phone's vertical aspect. The site looked like a scrapbook and the owner wanted it to feel like a ten-thousand-dollar bottle. Grading them through an image model fixed the feel in one pass, and then exposed the next trap: the model garbled legible label text on the bottles ("SINGLE WAST SCOTCH"). Label-legible shots now get a deterministic tone grade of the original instead, and every graded output is inspected.

**The mechanism.** A photo-grade script with a per-client recipe, a manifest recording which images were model-graded and which were tone-graded, and a rule that the script never overwrites sources.

**Apply it.** Grade the set before composing. Inspect every output for text and faces. Keep the originals.

## 4. You would have labeled the placeholder

**The rule.** If an image or artifact would need a visible badge to be honest, it does not ship. Swap it for real material, for neutral atmosphere that makes no claim about the business, or for nothing.

**The incident.** August 2026, twice: a clinic and a dent-repair shop both shipped with visible "sample imagery" chips on mood photos. Both had to be stripped from live sites after the owner saw them. Earlier, a parallel asset pass had generated lifestyle scenes (diners on a deck, a catering spread) and swapped them into a real restaurant's pages as if they were the venue. The failure is not that a generated image exists; it is that an unlabeled representation gets treated as documentary proof of a real place, dish, or crowd, and the "fix" of labeling it reads amateur.

**The mechanism.** Honesty bookkeeping is internal: the manifest and plain alt text are the record. The chassis sample tag is empty on every client surface, and any surface that depends on real photos (a funnel, a gallery) stays off until real photos exist. A mock artifact showing fabricated numbers never ships at all.

**Apply it.** Grep your components for words like "sample", "illustrative", "placeholder", "TODO". If any renders to the public, the section is not ready.

## 5. You would have trusted the tokens you inherited

**The rule.** Audit token values against the brand before building on them. Names stay stable; values lie.

**The incident.** June 2026: a contractor's site was forked from a working template. The `brand-*` tokens still held the previous client's indigo, so a warm brand rendered cold and generic, and nobody noticed because the names were right. The following month a gym rendered with an orange page background and red body text because the token generator mapped brand colors into neutral slots (secondary into the paper background, primary into the text color). A third site's display font silently never rendered because a custom utility shadowed the framework's generated one.

**The mechanism.** The token generator now enforces a semantic contract: near-white surfaces, near-black ink, brand primary as accent, opaque tints, and an explicit weight map for fonts that demand one. New scaffolds render correctly with zero hand tuning, and that is proven on each new client by a lint that reports 0/0.

**Apply it.** Before the first page, open the token file and read the values, not the names. Put a contrast check on the CI path.

## 6. You would have built the wall of cards

**The rule.** Repeating collections get editorial hierarchy: never more than six identical boxes, and never a three-column icon-title-two-gray-lines grid standing in for a real section.

**The incident.** The eleven-box wall on the bar site (rule 1); a four-column "model / lead services / qualification" stat strip on a contractor's site that read like a SaaS pricing page and leaked operations language onto a premium trade; every generated site's default hero (headline, subline, two buttons, nothing else). The factory keeps a cheap-tell dictionary of these reflexes, borrowed from the community's anti-slop catalog and reconciled to its own doctrine: the indigo-to-violet gradient on a brand that is not purple, the beige-and-brass "premium consumer" reflex applied to a brand that never asked for it, div-built fake screenshots, hand-rolled SVG icons at mismatched stroke weights, and the clause-dash-clause cadence in copy.

**The mechanism.** The scoring rubric caps any page at 79 the moment a named cheap tell appears, unless the art direction deliberately chose it.

**Apply it.** Keep your own cheap-tell list and make it a hard cap in review, not a suggestion.

## 7. You would have let a five-round craft pass ship unreadable text

**The rule.** Contrast is a conversion bug, and screenshot thumbnails hide it. Check text-on-photo and text-on-dark at full size and with a contrast tool, not by eye.

**The incident.** August 2026: a site came out of a rubric-clear, five-round visual loop with navy eyebrow labels at 1.48:1 on a dark footer, sitewide, plus brass headline tails over a gold sky. The scorer had read white-on-pale as solid at compressed screenshot size. The visual loop caught the composition and missed the legibility, because both are "looking" and only one of them is measuring.

**The mechanism.** The launch review runs a contrast pass on rendered text over imagery and dark sections as a separate check with numbers, not as part of the aesthetic score.

**Apply it.** Add one automated contrast check over the final screenshots. A visitor cannot act on copy they cannot read.

## 8. You would have judged the first screen without a comparator

**The rule.** Every number in the first screen has a comparator, and the comparator must actually be ahead. "Missing from most of the map" needs a two-thirds margin or it is a lie.

**The incident.** September 2026: a report to a stranger led with "missing from most of the map" directly above a table showing the business appeared in thirteen of the same searches as its competitor. The sentence was a template reflex; the data under it contradicted it. The same batch (next rule) taught the larger lesson, but this one is cheap to state: a stranger reads the first number, then the number next to it, and decides which of you is lying.

**The mechanism.** The report composer may only assert "ahead" or "behind" when the measured margin clears a stated threshold; otherwise the sentence is not generated.

**Apply it.** For every stat you render, write down what it is being compared to and by how much. If you cannot, render the stat without the adjective.

## 9. You would have told a working business its homepage was down

**The rule.** A read that failed is not a read that found nothing. Reachability is three-way: reached, reached with a real error, not read at all. Only the second earns a recommendation.

**The incident.** September 2026: a site scanner had a 750 KB response ceiling and threw on overflow. A throw produced status zero, which the grader read as a dead homepage. Eight of nineteen queued reports told working roofers and builders to "restore a normal HTTP 200 homepage before spending on traffic," scored their sites 0/100 at exactly 23% coverage, and showed a blank identity image. Re-probed with the fix, the same sites scored 78 to 99. Worse: the "measured" flag that the report composer consulted before citing a finding was set by the mere presence of a grade object, so the guard meant to stop an unmeasured claim reaching a stranger was itself lying. Only an unticked human-review box kept the batch from sending.

**The mechanism.** The scanner truncates at 3 MB instead of throwing (a partial read is a real read). The grader carries a read state. The intelligence layer emits NOT_OBSERVED for an unread page and refuses to recommend on it. Seven regression tests hold the line.

**Apply it.** Anywhere you grade someone else's site, separate "we could not read it" from "it is broken" in the data model, and never let a recommendation flow from the first.

## 10. You would have shipped the funnel without walking it cold on a phone

**The rule.** Before launch, walk the money path as a stranger, on a phone, from the entry a stranger would use. A form that POSTs green is not a working funnel if the person in front of it sees something broken.

**The incident.** July 2026: a contractor's slot picker surfaced a raw internal error ("Booking page not found") at the "pick a date" step because the booking page had not been provisioned yet. The lead still posted, so the live-fire check stayed green. A cold buyer at the conversion moment saw what looked like a broken site. The same month, a gym's form label read "Live <scheduler-name> slots", with the internal scheduling system's name in it, a word a customer should never meet. And review sections that looked honest sat three sections away from the form, doing nothing for the anxiety at the moment of action.

**The mechanism.** The launch review includes a scripted cold walk at phone width, a check that every meaningful call to action has verified proof in the same viewport, and a grep for internal system names and TODO text in rendered copy. The funnel degrades to a plain "we'll text you" when a dependency is missing, rather than rendering the dependency's error.

**Apply it.** Open the site on a phone you do not normally use, arrive from a link, and try to buy. Time it. Write down every hesitation.

## 11. You would have made the motion invisible

**The rule.** Base markup is the final frame. Animate transform and opacity only. One signature moment per site, a budget of four to six techniques, and every non-essential animation opt-in behind reduced-motion.

**The incident.** August 2026: a site's reveal system used a global early failsafe that resolved every below-fold element before the reader arrived, so the entire motion system was silently disabled and nobody noticed because the page looked finished (that is what base-as-final-frame is for, and it also hid the bug). The fix was an intersection observer driving reveals, a throttled scroll backstop for anything visible-but-unresolved, and a rule to verify by count: `[data-reveal]` total versus resolved after a scripted scroll.

**The mechanism.** The motion doctrine sets the budget, the property whitelist, a two-element cap on backdrop filters, and the count check in the launch review.

**Apply it.** After your motion lands, count the elements that should have animated and the ones that did. If they differ, your motion is decorative to you and absent to the reader.

## 12. You would have forced the wrong spine on the wrong business

**The rule.** The section order that sells a high-ticket contractor (proof, trust, estimate form) is wrong for a restaurant (desire, immediate visit intent, then the event ask) and wrong for a platform whose honest first path is education then login. One spine per vertical, chosen before layout.

**The incident.** Restaurant pages judged against the contractor spine felt like software. A launch gate that asserted a universal estimate form pressured an owner-operations product toward a customer journey it did not have and marked a truthful page as failing. In the other direction, a service-by-city matrix that looked like an SEO shortcut produced doorway pages with city-swapped copy and no local proof.

**The mechanism.** The design standard keeps a spine per vertical and the gate reads which one applies. City pages are added one at a time, after the owner confirms service there and a canonical page is already perfect.

**Apply it.** Name the vertical and its spine at the top of the page component before you write a section.

## 13. You would have designed the owner's dashboard like a landing page

**The rule.** A screen for a working person is the opposite of a marketing page: dense, scannable, comparative, and it never makes the operator hold state in their head. Decide the screen's one primary question before opening a layout file.

**The incident.** August 2026, an observed session: the founder walking a non-technical first-time user through a client's admin screen, describing his own build. The user's complaint reproduced the founder's own, unprompted: "too much information, not as useful, hard to organize." The screen had no primary question, so it was being used that day to share a document with someone, which is what a console without a purpose gets repurposed for. The factory's standing complaint about generated consoles is one sentence: "confusing, hard to see, too much white space, information spread all over the place, nothingness speak."

**The mechanism.** An admin doctrine that starts with a screen contract in a comment at the top of the component (the primary question, the decision the operator makes, what they must never have to remember) and a first-five-seconds beat borrowed from game onboarding: load it, look for five seconds, no scrolling, say what it is for.

**Apply it.** Run `skills/clarity-gate` on the screen as the person who has to use it, not as the person who built it.

---

## What survived from the framework

The three-layer model still holds and is worth stating once: principles that teach how to think (this file), a system that turns a brand into a wired project (tokens, components, scaffolding), and instances (each site). If two instances built from the same system look the same, the principles failed. Before layout, name a conceptual tension specific to the business, declare a mode (a marketing page shows and does not sell; a dashboard is precise and alive), and pick one signature detail per project that no other client gets. Section variety is non-negotiable: no two adjacent sections share a structure, every section has one pause, and one or two intentional grid breaks per page. All of that was true before the scars. The scars are why it is enforced.

## The gate, in order

1. Reference autopsy before composing (rule 2).
2. Token values audited, photos graded (rules 5, 3).
3. Compose, shoot, score against the rubric and the references, three to five rounds (rules 1, 6).
4. Contrast pass with numbers (rule 7).
5. Cold walk on a phone, proof near the ask, no internal words in copy (rule 10).
6. Motion count check, reduced-motion respected (rule 11).
7. Clarity gate as the reader (rules 8, 13), and `skills/definition-of-done` for the claim you make when you say it shipped.

---

Provenance: ported from a private site factory's design doctrines, lessons ledger, and incident notes on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/definition-of-done/SKILL.md`.
