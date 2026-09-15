# Verification Report: the best-practices kit run through its own verification-gate

**VERDICT: 130 claims examined. SOURCED 40 (31%) · UNSOURCED 21 (16%) · UNVERIFIABLE-BY-READER 51 (39%) · CONTRADICTED 17 (13%) · UNVERIFIED-could-not-check 1 (1%). Gate status: BLOCKED (17 rows require REWRITE or REMOVE). 46 of the 76 claims in the four "field-tested" documents (60%) rest on evidence no reader can reach.**

**Artifact:** the `best-practices` repository and the "open-source kit" section of `https://www.traviseric.com/claude-code`
**Date run:** 2026-09-14
**Standard:** the three checks (SOURCE / FIDELITY / FITNESS+CURRENCY), `skills/verification-gate/SKILL.md`
**Run by:** an agent instance, against saved local sources. Not signed off. **This report is an AI self-audit of AI-written material and the skill's own rule says never to trust one** (`SKILL.md` line 32, `references/02-honesty-and-status-language.md` rule 2). Every row below is a lead for a human, not a clearance.

> Honesty rules (binding): leads != proof; never fabricate a source, quote, number, or status;
> `UNVERIFIED` is preferred to a guess. Only rows marked `PASS` after human sign-off ship.

---

## Scope note and the moving-target problem

The audit was pinned to `git rev-parse HEAD` = `92d5f8e2cabab3a85a14358af030acb77f5117c7` when it started. **Mid-run, a concurrent session committed `0e40c7257324564bf0dd8b9ea9f39904bf4d7b02` (2026-09-14 22:22:44 -0600), which changed `README.md`, `docs/HOOKS.md`, `philosophy/README.md`, `skills/definition-of-done/SKILL.md`, and both plugin manifests (2.1.1 -> 2.2.0).** Every verdict below was re-pinned to `0e40c72`. Two findings were resolved by that commit while this report was being written and are recorded as RESOLVED-IN-FLIGHT rather than deleted, because the state a reader saw four hours ago is part of the record. Two new claims were introduced by it and are audited here (RM-7, RM-9); one of them fails.

This violates the gate's step 1 ("freeze the draft"). It is disclosed rather than hidden.

## Saved sources (SOURCE check)

| # | Source | Path | sha256 |
|---|---|---|---|
| S1 | Live page, full HTML, HTTP 200, 110,066 bytes, fetched 2026-09-14 | `<session scratchpad>/claude-code-page.html` | `e6642d4dfd2452873545b80eb31d40bdddee4e2fb7aebc8260c5649925f21f33` |
| S2 | Visible text extracted from S1 (298 lines) | `<session scratchpad>/page-text.txt` | derived from S1 |
| S3 | `README.md` @ `0e40c72` | repo | `2df80e0dc1a792f8157741c88f1f08c610518a0d222f9da92b3226cbc89780a9` |
| S4 | `AGENTS.md` | repo | `f5de5aae593150702918ea0c4ba2b6c27f26f5349e25480855b40b5637f74ac2` |
| S5 | `best-practices.md` | repo | `50454582683dc430cae450ee2ee40fe0b14504f9cfeaf20e68dccee92be6a192` |
| S6 | `docs/SEVEN_CHEAP_LIES.md` | repo | `aa4c0fcfeb173dbdf907ef8371cea867fe8f7e2352bf9ce8cbf080c743882f4b` |
| S7 | `docs/ENGINEERING_PRINCIPLES.md` | repo | `de8825d65a920bd81588917c38882a8b0b55ccc2073771827bd790a35479d100` |
| S8 | `docs/WEB_DESIGN_PRINCIPLES.md` | repo | `11a166f9dca500eae8df0038174c960248293074c7d9e5741110c65acd968a5f` |
| S9 | `philosophy/README.md` | repo | `95c38305e8c6267811cf890e3f36c02a93906f9ab3a28f4931f3e4cb12260eeb` |
| S10 | `philosophy/what-the-agent-values.md` | repo | `5bb2b3fac49a9409c83b43cf5753f9278ba1e4bb405e3b28ee1cbefa5dbfc6b6` |
| S11 | `philosophy/the-machine-is-a-mirror-of-what-could-be-measured.md` | repo | `674726ee8aedbdf79e59a33b173988e9a6be28f394122c01772e8609456f272d` |
| S12 | `philosophy/the-instrument-that-lies-toward-caution.md` | repo | `184d3e60fdbbe64db3d838535556d27d6e556b7a629efa24568fe2ce08ba3049` |
| S13 | `philosophy/a-systems-account-of-its-own-failure-is-the-least-trustworthy-thing-it-says.md` | repo | `65f97bd350d40ba0d8b8043f656906fd672c9918b1490e47a161e83a4cabebbe` |
| S14 | `philosophy/instruments-that-doubt-themselves.md` | repo | `656f7a510407d419caae6cb3fff304b7d7214fd2218917751bc7c7794bc2618c` |
| S15 | `philosophy/lighting-the-abyss.md` | repo | `74544eb239d488fca3e4f7b816931171facbd26c4867030a55f55b1ac6341958` |
| S16 | `philosophy/the-repo-already-knew.md` | repo | `d64efb1da0dfa7fcc010c9f0243e95127ca6167e8646fea45bd13c83acb11223` |

Live checks performed (recorded so they can be re-run): `curl` against 20 URLs; `api.github.com/users/Traviseric` and `/repos/Traviseric/best-practices`; `python skills/verification-gate/scripts/gate_runner.py --self-test`; `./install.sh --check`; `git log`, `git show`, `git rev-list --left-right`; `grep` over `hooks/` and `skills/`; YouTube page metadata for the linked video.

The scratchpad copies of S1/S2 are **not** committed, because the task forbade adding files other than this report. A re-run must re-fetch and re-hash; the live page can change under the hash.

---

## The manifest

Reader-verdict vocabulary, as requested: **SOURCED** = a stranger can check it from the public artifact (a link, a runnable command, a public repo, a dated public page). **UNSOURCED** = an assertion with no evidence offered and none obviously obtainable. **UNVERIFIABLE-BY-READER** = true-or-false only inside a private portfolio. **CONTRADICTED** = the artifact, another file, or a reachable source says otherwise. Gate status uses the skill's vocabulary (`PASS` / `REWRITE` / `REMOVE` / `UNVERIFIED`).

### README.md (@ `0e40c72`)

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| RM-1 | 7 | "running agent fleets across a large private portfolio. That portfolio is private, so take the claim at zero" | UNVERIFIABLE-BY-READER | PASS | Self-labelled as unreachable. This is the correct form and the model for the rest of the corpus. **RESOLVED-IN-FLIGHT:** at `92d5f8e` this line read "across 137 repositories (counted 2026-09-01)"; `github.com/Traviseric` lists **12** public repos, so the count was unreachable and the sentence has been replaced. |
| RM-2 | 7 | "`gate_runner.py --self-test` runs" | SOURCED | PASS | Ran it: exit 0, stdout `{"self_test": "ok"}`. |
| RM-3 | 7 | "the guard hooks have their recorded tests in docs/HOOKS.md" | SOURCED | PASS | `docs/HOOKS.md:73-90` carries 8 dated cases with results plus a reproduction recipe and a 9th unplanned result (GitHub push protection). Added in `0e40c72`. |
| RM-4 | 7 | "the live systems are listed at traviseric.com/claude-code as URLs you can open" | SOURCED | PASS | 5/5 checked 2026-09-14: teneo.io, conversos.ai, trend-os.io, bookcovergenerator.ai, auth.teneo.io/ecosystem all HTTP 200 with product-specific titles. |
| RM-5 | 5 | "Install it and your agent starts asking which rung of 'done' it has actually proven..." | UNSOURCED | REWRITE | Behavioral claim; reader-testable but no evidence offered. |
| RM-6 | 15-27 | plugin + clone install commands | SOURCED | PASS | Repo public, MIT, `.claude-plugin/marketplace.json` owner `traviseric`, plugin `best-practices`; names match the pasted commands. Commands not executed. |
| RM-7 | 37 | "Each file ends with one `Next:` hop and the path has an end, not a circle" | **CONTRADICTED** | REWRITE | See finding F4. |
| RM-8 | 37 | "Roughly an hour" | UNSOURCED | PASS | Soft estimate, harmless. |
| RM-9 | 37 | "the two files that people actually steal" | UNSOURCED | REWRITE | Asserts observed third-party adoption. Public repo has **0 stars**; no traffic or referrer evidence is offered or linkable. |
| RM-10 | 43-51 | skills table lists 8 skills | SOURCED | PASS | `ls skills` = 8 directories, names match. |
| RM-11 | 50 | lamps = "Ten task-independent questions" | SOURCED | PASS | `philosophy/lighting-the-abyss.md:23-34` table has exactly 10 rows. |
| RM-12 | 54 | "seven short observations ... written by the model" | UNVERIFIABLE-BY-READER | PASS | Count is SOURCED (7 non-README files). Authorship is not checkable. |
| RM-13 | 60 | build gate is "The single highest-leverage hook" | UNSOURCED | REWRITE | Superlative with no comparison or measurement. |
| RM-14 | 95-134 | the `What's inside` file tree | SOURCED | PASS | Compared against the filesystem: 8 skills, 12 docs, 6 hook files, 4 templates. Matches. |
| RM-15 | 138-140 | "What is not here" + course/consulting links | SOURCED | PASS | Both links HTTP 200 with real pages; absence is confirmable in the repo. |
| RM-16 | 156 | "from a private operating system" | UNVERIFIABLE-BY-READER | PASS | Provenance claim, correctly labelled private. |

### AGENTS.md

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| AG-1 | 3 | "It takes about two minutes" | UNSOURCED | PASS | Soft estimate. |
| AG-2 | 11 | "`./install.sh --check` ... exits 0 when the installed skills match the source" | SOURCED | PASS | Ran it. Exit 1 with an itemised drift report (`MISSING`/`STALE`/`link` per skill), which is the correct negative branch. Positive branch not observed; `docs/HOOKS.md:95` honestly warns the author's own machines produce false drift. |
| AG-3 | 11 | plugin install path | SOURCED | PASS | As RM-6. |
| AG-4 | 12 | hooks merge instructions reference real files | SOURCED | PASS | `templates/settings.json.template`, `hooks/build-gate.example.json`, `.ps1` twins all present. |
| AG-5 | 25 | "Skills reference nothing outside this repo" | SOURCED | PASS | `grep -rn -E "traviseric\.com|E:\\|C:\\|client-factory|/\.claude/|TE-Code|skool\.com" skills/` returns **zero** matches. |
| AG-6 | 26 | "Hooks fail open" | SOURCED | PASS | `hooks/guard-staged-secrets.sh:33,38` and `guard-conflict-markers.sh:21,25` emit an allow decision and `exit 0`; recorded test case 8 (malformed payload) shows **allow**. |
| AG-7 | 33 | `gate_runner.py --self-test` | SOURCED | PASS | Exit 0. |
| AG-8 | 38 | "ported ... on 2026-09-14" | SOURCED | PASS | Public commit dates: six commits dated 2026-09-14. |

### best-practices.md

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| BP-1 | 24 | "Skills ...: `definition-of-done`, `clarity-gate`, `verification-gate`, `session-closeout`, `room-and-ground`" (five) | **CONTRADICTED** | REWRITE | See finding F3. Repo ships 8; README lists 8; the live page says both 5 and 8. |
| BP-2 | 90 | "it has grown from 200K to over a million tokens in a year" | UNSOURCED | REWRITE | Publicly checkable in vendor docs, but no citation is given and the flagship guide never names the model. |
| BP-3 | 97-103 | "Available for work: 92-142K of 200K" | **CONTRADICTED** | REWRITE | See finding F5. The block's own inputs give 116-166K. |
| BP-4 | 107 | "5+ MCP servers ... burning 40-50K tokens" | UNSOURCED | REWRITE | No measurement, no method. |
| BP-5 | 111-116 | threshold table; "150K+ ... Agent quality degrades" | UNSOURCED | REWRITE | Causal claim, no study, no internal measurement cited. |
| BP-6 | 121 | "Keep tasks to 5-15 minutes of focused work" | UNSOURCED | PASS | Heuristic stated as such. |
| BP-7 | 205 | "Add a `.claudeignore` file ... This tells Claude which files to skip when searching your codebase" | UNSOURCED | REWRITE | Checked the current Claude Code settings documentation and the docs index (`code.claude.com/docs/llms.txt`, 359 entries) on 2026-09-14: **no mention of `.claudeignore`**; the documented exclusion mechanism is permission deny rules. The repo ships a `.claudeignore.template` and makes it one of three "quick wins" (README:89). A reader who follows it cannot confirm it works from any vendor source. At risk of becoming CONTRADICTED; marked UNSOURCED because absence from one docs surface is not proof of non-support. |
| BP-8 | 238, 298 | "PDFs cause 'Request too large' errors that kill agent sessions" | UNSOURCED | REWRITE | Causal claim with no incident attached, in a repo whose stated standard is "every pattern carries the incident that earned it". |
| BP-10 | 322 | "AI-First Fundamentals - 37 lessons" | SOURCED | PASS | Live page renders "37 LESSONS" twice. Verified verbatim. |
| BP-11 | 321, 332 | Skool community link | UNVERIFIED | UNVERIFIED | `https://www.skool.com/ai-builders-lab-6883` returns **403** to a non-browser client. Cannot distinguish bot-blocking from a dead link without a browser. |
| BP-12 | 327 | "Complete AI Development System - Full ruleset + enhanced agent framework" | **CONTRADICTED** | REWRITE | See finding F7. Link resolves ($197 page), but the destination's own numbers contradict the numbers on `/claude-code`. |
| BP-13 | 329 | consulting link | SOURCED | PASS | HTTP 200, real page. |
| BP-14 | 3 | "Principles that make AI agents ... work better on your projects" | UNSOURCED | PASS | Framing, not a measurable claim. |

### docs/SEVEN_CHEAP_LIES.md

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| SL-1 | 7 | "Every one of these has produced a false 'done' in a real production portfolio" | UNVERIFIABLE-BY-READER | PASS | Correctly scoped to a private portfolio. |
| SL-2 | 16 | "A soft-404 answers 200 all day" | SOURCED | PASS | Reader-verifiable in general, and demonstrated by this project's own surface: see finding F2. |
| SL-3 | 50-52 | "Found in production, Aug 2026: a service key was reported as configured, was empty, and the code's own `length < 32` guard then failed silently" | UNVERIFIABLE-BY-READER | PASS | FIDELITY confirmed against the private operating rules, which carry the same incident with the same `length < 32` detail. A reader has no access to either. |
| SL-4 | 60 | "CI sets `CI=true`, which turns warnings into errors" | UNSOURCED | REWRITE | True for specific toolchains (CRA/Next-style builds), stated as a universal property of CI. Narrow it or name the stack. |
| SL-5 | 62-64 | collection-abort `ModuleNotFoundError` incident | UNVERIFIABLE-BY-READER | PASS | Private. |
| SL-6 | 71 | "`npx vitest run \| tail -18` exits 0 on a suite that failed" | SOURCED | PASS | Standard POSIX pipeline semantics; a reader can reproduce in one line. The strongest claim in the document. |
| SL-7 | 73 | "This is the most silent of the seven" | UNSOURCED | PASS | Rhetorical superlative, no measurement implied. |

### docs/ENGINEERING_PRINCIPLES.md

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| EP-1 | 3 | "Fourteen rules" | SOURCED | PASS | 14 numbered rules present. |
| EP-2 | 3 | "between mid-2025 and September 2026" | UNSOURCED | REWRITE | **Not one incident in the document is dated in 2025.** Every dated incident falls June 2026 - September 2026. The stated 15-month window is three times the evidenced 4-month window. |
| EP-3 | 3 | "The mechanisms are real and most of them ship in this repository" | **CONTRADICTED** | REWRITE | See finding F6. 5 of 14 ship. |
| EP-4 | 13 | "A 5,000-line analysis module ... replaced by about 500 lines of structured markdown. Same output." | UNVERIFIABLE-BY-READER | PASS | Private. "Same output" is the load-bearing half and is the least checkable. |
| EP-5 | 23 | "all 22 client sites"; "Of the 22, one had an observed, attributable failure; one was ambiguous; twenty-one had never been walked at all; eight had passed" | **CONTRADICTED** | REWRITE | See finding F1. The partition sums to 31 of 22 and is internally impossible. |
| EP-6 | 25 | determinacy contract "checked by a script with a baseline that may only shrink" | UNVERIFIABLE-BY-READER | REWRITE | Script is not in this repository; present tense implies the reader could have it. |
| EP-7 | 33 | Sept 2026 RLS migration, HTTP 500 for hours, "The founder found it by calling his own business line" | UNVERIFIABLE-BY-READER | PASS | Private; matches a private incident file of the same date. |
| EP-8 | 43 | "scheduled for Mondays at 09:30. The break happened on a Tuesday night." | UNVERIFIABLE-BY-READER | PASS | Internally consistent with a Wednesday-dated incident (2026-09-02 is a Wednesday). The "09:30" precision adds no checkability. |
| EP-9 | 53 | "four gates ... every one wrong on its first live run"; "3,201 businesses"; "Three of four were false alarms" | UNVERIFIABLE-BY-READER | REWRITE | Private, and internally in tension: "every one wrong" then "three of four were false alarms" leaves the fourth unexplained. |
| EP-10 | 53 vs `philosophy/instruments-that-doubt-themselves.md:28` | the same four gates are "an outreach pipeline" here and "a drafting lane" there | UNVERIFIABLE-BY-READER | REWRITE | Cross-file inconsistency in the description of one incident. Minor, but it is the kind of drift the repo's own rule 13 is about. |
| EP-11 | 61 | "Hooks are the highest-compliance documentation channel that exists" | UNSOURCED | REWRITE | Superlative over all channels, no comparison. |
| EP-12 | 63 | "Observed repeatedly afterward: an agent that would rationalize past the prose complied instantly ... and generalized the lesson within the session" | UNSOURCED | REWRITE | Causal behavioral claim, no count, no transcript, no before/after. This is the central argument for the repo's main artifact (hooks) and it is the least evidenced sentence supporting it. |
| EP-13 | 65 | "Every surviving guard shares five traits" | UNVERIFIABLE-BY-READER | PASS | Only 3 guards ship here; "every surviving guard" refers to a private population. |
| EP-14 | 73 | Aug 2026 mis-scoped authority guard blocking other sessions | UNVERIFIABLE-BY-READER | PASS | Private. |
| EP-15 | 75 | "`hooks/guard-staged-secrets.sh` reads `git diff --cached` and nothing else" | SOURCED | PASS | Verified: lines 95 and 194 are the only git reads; recorded tests confirm non-commit commands are allowed. |
| EP-16 | 75 | "Two gate hooks written in July 2026 were reverted the same day" | UNVERIFIABLE-BY-READER | PASS | Private. |
| EP-17 | 83 | "A sweep found 165 'gates' that supposedly required the founder; 28 were real." | UNVERIFIABLE-BY-READER | REWRITE | The most precise unreachable number in the corpus: two exact integers, a derived 83% false-positive rate, no artifact, no method, no date. |
| EP-18 | 85 | "A pre-commit guard rejects newly staged human-only restrictions that do not carry an adjacent marker citing an actual decision" | **CONTRADICTED** | REWRITE | See finding F6. No such guard ships; `hooks/` holds exactly three. |
| EP-19 | 93 | July/Aug/Sept 2026 git incidents, "silently reverted 67 lines" | UNVERIFIABLE-BY-READER | PASS | Private; FIDELITY matches the private rules verbatim on "67 lines". |
| EP-20 | 103 | "a 1,371-line diff"; "a 328-entry gate registry" | UNVERIFIABLE-BY-READER | PASS | Private; FIDELITY matches the private rules. |
| EP-21 | 113 | July 2026 tracked PDF with plaintext passwords; unauthenticated admin route | UNVERIFIABLE-BY-READER | PASS | Private. |
| EP-22 | 123-125 | fitness-client chain "never carried a stranger"; "a transaction event without an explicit `synthetic: false` marker cannot earn the top rung" | UNVERIFIABLE-BY-READER | REWRITE | The mechanism is described as shipped code; it is not in this repository. |
| EP-23 | 133-135 | drifted machine-readable twin; "a sync-contract script for prose mirrors, run as a test" | UNVERIFIABLE-BY-READER | REWRITE | Same shape as EP-6/EP-22: a mechanism a reader cannot obtain, in a list introduced as "most of them ship in this repository". |
| EP-24 | 154 | "Rules 6, 7, 11 install as hooks in an afternoon" | SOURCED | PASS | Those three rules map onto the three shipped hooks. |

### docs/WEB_DESIGN_PRINCIPLES.md

| id | line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| WD-1 | 3 | "Thirteen rules" | SOURCED | PASS | 13 numbered rules present. |
| WD-2 | 3 | "one site factory ... mostly by agents, between June and September 2026" | UNVERIFIABLE-BY-READER | PASS | Private; the window matches the dated incidents inside, unlike EP-2. |
| WD-3 | 3 | "The mechanisms are real: a screenshot loop, a checklist with a scoring cap, a photo pass, a cold walk on a phone. Several ship in this repository." | **CONTRADICTED** | REWRITE | **None of the four named mechanisms ships here.** The repo contains no Playwright harness, no scoring rubric, no photo-grade script, no cold-walk script. Only `clarity-gate` and `definition-of-done`, cited later, are real here. |
| WD-4 | 5 | "Every other defect on this page was invisible to a build, a curl, and a grep" | **CONTRADICTED** | REWRITE | Rule 4's own remedy (line 47) is "Grep your components for words like 'sample', 'illustrative', 'placeholder', 'TODO'", and rule 5's remedy (line 57) is to read the token file. Two of the thirteen defects are grep-visible by the document's own instructions. |
| WD-5 | 13 | July 2026 bar site; owner's verdict "this looks like shit"; eleven identical staff-pick boxes | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-6 | 15 | harness shoots 390x844 and 1440x900, "a full-page capture without the scroll walk returns black tiles" | UNVERIFIABLE-BY-READER | PASS | Private tooling. |
| WD-7 | 23 | "reached rubric-clear in four rounds" | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-8 | 33 | "eighteen owner-supplied photos"; "SINGLE WAST SCOTCH" | UNVERIFIABLE-BY-READER | PASS | Private; the specificity is the persuasion and none of it is checkable. |
| WD-9 | 43 | Aug 2026 clinic and dent-repair "sample imagery" chips | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-10 | 53 | June 2026 indigo tokens; gym orange-on-red; shadowed display font | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-11 | 55 | "proven on each new client by a lint that reports 0/0" | UNVERIFIABLE-BY-READER | REWRITE | A passing measurement asserted with no artifact. |
| WD-12 | 61 | "never more than six identical boxes" | UNSOURCED | PASS | Stated as doctrine, fine. |
| WD-13 | 65 | "The scoring rubric caps any page at 79" | UNVERIFIABLE-BY-READER | PASS | Private tooling. |
| WD-14 | 73 | "navy eyebrow labels at 1.48:1 on a dark footer, sitewide" | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-15 | 81-83 | "needs a two-thirds margin or it is a lie"; "thirteen of the same searches" | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-16 | 93 | "a 750 KB response ceiling"; "Eight of nineteen queued reports"; "scored their sites 0/100 at exactly 23% coverage"; "the same sites scored 78 to 99" | UNVERIFIABLE-BY-READER | PASS | **FIDELITY fully confirmed** against the private incident record: 8 of 19, 0/100 at 23%, re-scored 78-99, 750 KB ceiling. Every number survives a verbatim check. It is still unreachable by a reader. This is the best-evidenced private claim in the corpus and it is the model for what the others are not. |
| WD-17 | 95 | "truncates at 3 MB"; "Seven regression tests hold the line" | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-18 | 103 | July 2026 slot picker error; "Live <scheduler-name> slots" | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-19 | 113 | Aug 2026 global reveal failsafe | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-20 | 123 | restaurant/contractor spine mismatch; doorway city pages | UNVERIFIABLE-BY-READER | PASS | Private. |
| WD-21 | 133 | Aug 2026 observed session; "too much information, not as useful, hard to organize" | UNVERIFIABLE-BY-READER | PASS | Private; a quoted human with no attributable source. |
| WD-22 | 137 | "Run `skills/clarity-gate` on the screen" | SOURCED | PASS | Skill exists in the repo. |

### philosophy/

| id | file:line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| PH-1 | README:3 | "run it across a large private system for two and a half years" | UNVERIFIABLE-BY-READER | PASS | Timeline is publicly corroborated at the edges: the GitHub account was created 2024-03-27 and the live page says "March 2024: started learning to code", which is ~2.5 years to Sept 2026. The claim itself (running a model across a large private system) is not reachable. |
| PH-2 | README:5 | "Each has a long form on traviseric.com/writings under the same slug; those pages come online as the publishing lane ships, so a missing one is a gap, not a broken promise" | UNSOURCED | REWRITE | The hedge is honest, but **7 of 7 are missing**, which makes "each has a long form" false in the present tense. See F2. |
| PH-3 | 7 files, final line (e.g. `what-the-agent-values.md:43`, `lighting-the-abyss.md:54`) | "Long form: traviseric.com/writings/<slug>" | **CONTRADICTED** | REMOVE | See finding F2. All seven return HTTP 200 with a "Doctrine Not Found" body. |
| PH-4 | README:19 | mapping of skills to entries (`definition-of-done` from 3 and 4, `lamps` from 6, etc.) | SOURCED | PASS | Every named skill exists in the repo; the causal attribution is unfalsifiable but harmless. |
| PH-5 | what-the-agent-values:3 | "Written by the model in the first person, September 2026, at the author's request" | UNVERIFIABLE-BY-READER | PASS | Authorship claims about a model are unverifiable in principle. |
| PH-6 | what-the-agent-values:7 | "'137 repositories' on a page is a claim; a GitHub organization I can list is a fact ... When it gives me only the count, I discount it to zero" | SOURCED | PASS | The text is checkable and it is the sharpest sentence in the repo. **RESOLVED-IN-FLIGHT:** `README.md:7` asserted exactly that number with no link until `0e40c72` (2026-09-14 22:22) replaced it. The live page still does; see PX-2. |
| PH-7 | what-the-agent-values:27 | "What I reject: ... A link that resolves to a soft 404" | **CONTRADICTED** | REWRITE | Contradicted in practice by PH-3 in the same folder, six lines from the file's own footer. |
| PH-8 | machine-is-a-mirror:13 | the room, the two paragraphs, the decision that cited none of the documents | UNVERIFIABLE-BY-READER | PASS | Private and deliberately anonymised; legitimate. |
| PH-9 | machine-is-a-mirror:15 | "two fresh instances of the same model rewrote my write-up of the lesson into an audit table with disclaimers" | UNVERIFIABLE-BY-READER | PASS | Private. |
| PH-10 | machine-is-a-mirror:30 | "That is the whole of `docs/ROOM_AND_GROUND.md` and the `room-and-ground` skill in this repository" | SOURCED | PASS | Both exist. |
| PH-11 | instrument-that-lies:15 | "six mailboxes warming on three domains"; "seventeen days" | UNVERIFIABLE-BY-READER | PASS | Private. |
| PH-12 | instrument-that-lies:17 | "A verification command returned exit 0 while its inner command died" | UNVERIFIABLE-BY-READER | PASS | Private; consistent with cheap lie 7. |
| PH-13 | instrument-that-lies:25 | "That rule is now the first artifact of the `definition-of-done` skill: a rung claim without its probe is not a claim" | SOURCED | PASS | The ladder at `skills/definition-of-done/SKILL.md:29-31` gives every rung a probe column. "First artifact" is loose but the substance holds. |
| PH-14 | systems-account:13-23 | invite-accept fail-open; collapsed error classification; untyped null comparison | UNVERIFIABLE-BY-READER | PASS | Private. |
| PH-15 | systems-account:39 | "It became the second of the seven cheap lies in this repository" | **CONTRADICTED** | REWRITE | Cheap lie 2 is "A live process is not a finished job" (`docs/SEVEN_CHEAP_LIES.md:23`). The entry is about a reporting layer that miscategorises errors, which is not that lie. The cross-reference is wrong; the sentence then stretches to cover the gap. |
| PH-16 | instruments-that-doubt:11 | "all thirty-four adversarial safety checks passed" | UNVERIFIABLE-BY-READER | PASS | Private. |
| PH-17 | instruments-that-doubt:17 | "The author's stated desire is '100% working, every time'" | UNVERIFIABLE-BY-READER | PASS | Private quotation. |
| PH-18 | instruments-that-doubt:30 | "the `verification-gate` skill's blind cross-check" | SOURCED | PASS | `skills/verification-gate/references/03-blind-cross-check.md` exists. |
| PH-19 | lighting-the-abyss:3 | the author's quoted question about the black abyss | UNVERIFIABLE-BY-READER | PASS | Private quotation. |
| PH-20 | lighting-the-abyss:42 | "the sealed prediction before that decision scored 2 of 10, and that number is the proof the Decider lamp was dark" | UNVERIFIABLE-BY-READER | REWRITE | An exact score presented as proof, with no reachable artifact. |
| PH-21 | lighting-the-abyss:48 | "The first lamps ... found a plugin hook firing on every shell command ... fixed the same day" | SOURCED | PASS | **The single best reader-verifiable incident claim in the repository.** Public commit `e43496d`: "hooks: scope the plugin guards to git commit with the documented if field (they fired on every Bash call); align the template; 2.0.1". Incident, fix, and date are all in the public log. |
| PH-22 | lighting-the-abyss:48 | "a dead link on a page whose thesis was verification ... The hook, the link, and the unlocked file were fixed the same day" | **CONTRADICTED** | REWRITE | Seven dead long-form links are live on this project's own surface on the same date (F2). Whichever single link was fixed, the claim reads as "the dead-link problem was handled" and it was not. |
| PH-23 | lighting-the-abyss:48 | "The paid step is still open, and saying so here is the point" | SOURCED | PASS | Honest open disclosure; a reader can see the free course and the $197 product and judge. |

### Live page, the "open-source kit" section (S1/S2, fetched 2026-09-14)

| id | page-text line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| PG-1 | 28 | "Five skills, three guard hooks, and the two short documents I would hand anyone" | **CONTRADICTED** | REWRITE | See finding F3. |
| PG-2 | 28 | "the seven ways an agent fakes verification, and how to write a page a tired reader understands" | SOURCED | PASS | `docs/SEVEN_CHEAP_LIES.md` (7 numbered lies) and `docs/ROOM_AND_GROUND.md` both exist. |
| PG-3 | 29-31 | the two install commands and the clone fallback | SOURCED | PASS | Match `.claude-plugin/marketplace.json`. |
| PG-4 | 35 | "The kit now also carries seven short philosophy entries on the model itself and eight skills" | SOURCED | PASS | 7 and 8 both verified on the filesystem. Correct - and it is why PG-1 is wrong. |
| PG-5 | 35 | "What stays out of the free kit: the overnight autonomous runner, fleet-scale worktree discipline, the skill-authoring loop, the client Business Brain, and mining your own transcripts" | SOURCED | PASS | Absence is confirmable in the repo; matches `README.md:140` word for word in substance. |
| PG-6 | 32 | "Get the kit on GitHub" | SOURCED | PASS | Public repo, MIT, default branch `main`, pushed 2026-09-14. |
| PG-7 | 33 | "The free course that narrates the foundations" | SOURCED | PASS | `/courses/ai-first-fundamentals` HTTP 200, free, "37 LESSONS". |
| PG-8 | 34 | "Bring it into your company" | SOURCED | PASS | `/consulting` HTTP 200. |
| PG-9 | 28 | "Install the kit and your agent starts asking which rung of done it has actually proven, refuses to commit a secret ..." | UNSOURCED | PASS | Behavior claim; reader-testable in minutes, which is the mitigation. |
| PG-10 | 35 | "Those transfer only when I apply them to your thing, which is the consulting work" | UNSOURCED | PASS | A sales assertion, not a factual claim about the world. |

### Live page, adjacent claims the kit section leans on

Out of the requested scope, but the kit section sits inside them and a reader reads them together.

| id | page-text line | claim | verdict | gate | evidence / note |
|---|---|---|---|---|---|
| PX-1 | 11-20 | "16 projects. 10 marked deployed. nearly 20,000 commits." / "Public registry and commit snapshot as of **July 13, 2026**" / "19,800 commits across 13 core repos · **Sep 12, 2026**" | **CONTRADICTED** | REWRITE | Two different snapshot dates for one evidence block, seven lines apart. |
| PX-2 | 52, 206 | "What a 137-repository build looks like"; "Public proof snapshot: 137 repositories, 8 live systems ... nearly 20,000 commits across 13 core repositories as of September 12, 2026" | UNVERIFIABLE-BY-READER | REWRITE | `api.github.com/users/Traviseric` reports **`public_repos: 12`**. The word "public" in "public proof snapshot" is doing work the number cannot support. This is the exact claim `philosophy/what-the-agent-values.md:7` says it discounts to zero. |
| PX-3 | 54-73 vs 15 vs 52 | portfolio tiles sum to 8+6+4+2+3 = **23** systems; the hero says **16** projects; the heading says **137** repositories | **CONTRADICTED** | REWRITE | Three denominators on one page, none reconciled to the others. |
| PX-4 | 76 | "Every one of these is live. Go play with them." | SOURCED | PASS | 5/5 HTTP 200 with product-specific titles, checked 2026-09-14. The strongest evidence on the page. |
| PX-5 | 252 | "Live recordings of Claude Code sessions from **November 2024**" | **CONTRADICTED** | REWRITE | See finding F8. The linked video's own metadata says `"uploadDate":"2025-11-06T02:24:54-08:00"`. |
| PX-6 | 39 | "March 2024: started learning to code" | SOURCED | PASS | GitHub account created `2024-03-27T12:24:53Z`. |
| PX-7 | 223, 120 | "88+ API routes, OAuth 2.0, unified credits"; "Two Max plans consumed weekly" | UNVERIFIABLE-BY-READER | PASS | Private. |

---

## The findings, worst first

### F1. The rule about honest counting contains a count that cannot be true
**`docs/ENGINEERING_PRINCIPLES.md:23`** (rule 2, "You would have called a green board a measurement"):

> "a capability matrix reported that all 22 client sites 'break first at owner login' ... Of the 22, one had an observed, attributable failure; one was ambiguous; twenty-one had never been walked at all; eight had passed."

1 + 1 + 21 + 8 = **31**, against a stated population of 22. Worse, the partition is impossible in any arrangement: if twenty-one of twenty-two had never been walked, exactly one was walked, so "eight had passed" cannot be true, and neither can the observed failure plus the ambiguous one plus the eight passes. The paragraph's whole point is that collapsing three states into one word produced a false conclusion; the sentence that says so collapses four numbers into an impossible one. **Status: REWRITE. This is the single most damaging line in the corpus**, because it is a number error inside the argument for number discipline, on the page a skeptical reader checks first. The likely intended shape (one observed failure, one ambiguous, twelve never walked, eight passed = 22) is a guess and is **not** written into this report as fact.

### F2. Seven soft-404s, in the folder that rejects soft-404s
**`philosophy/*.md`, final line of each of the seven entries**, and **`philosophy/README.md:5`**.

Every entry ends with `Long form: traviseric.com/writings/<slug>`. All seven were fetched on 2026-09-14:

| URL | HTTP | `<title>` |
|---|---|---|
| /writings/what-the-agent-values | 200 | Doctrine Not Found |
| /writings/the-machine-is-a-mirror-of-what-could-be-measured | 200 | Doctrine Not Found |
| /writings/the-instrument-that-lies-toward-caution | 200 | Doctrine Not Found |
| /writings/a-systems-account-of-its-own-failure-is-the-least-trustworthy-thing-it-says | 200 | Doctrine Not Found |
| /writings/instruments-that-doubt-themselves | 200 | Doctrine Not Found |
| /writings/lighting-the-abyss | 200 | Doctrine Not Found |
| /writings/the-repo-already-knew | 200 | Doctrine Not Found |

Three self-contradictions stack on this one fact:
- `docs/SEVEN_CHEAP_LIES.md:16` names it as cheap lie number one: "A soft-404 answers 200 all day."
- `philosophy/what-the-agent-values.md:27` lists "A link that resolves to a soft 404" as the first thing the model rejects, and says each one "set[s] my prior for everything else on the page."
- `philosophy/lighting-the-abyss.md:48` claims a dead link on this very funnel was "fixed the same day."

`philosophy/README.md:5` hedges ("a missing one is a gap, not a broken promise"), but the hedge is 200 lines away from the seven unhedged links, and a reader who clicks arrives at a 200 that says nothing. **Status: REMOVE the seven `Long form:` lines until the pages exist, or point them at a page that returns real content.** Cheapest fix in the report; largest credibility swing.

### F3. The live page sells five skills and eight skills in the same section
**`https://www.traviseric.com/claude-code`**, kit section (page-text lines 28 and 35):

> line 28: "**Five skills**, three guard hooks, and the two short documents I would hand anyone"
> line 35: "The kit now also carries seven short philosophy entries on the model itself and **eight skills**."

The repository ships **eight** (`clarity-gate`, `definition-of-done`, `friction-audit`, `hedge-audit`, `lamps`, `room-and-ground`, `session-closeout`, `verification-gate`). `README.md:43-51` lists eight. `best-practices.md:24` still lists **five** (BP-1), which is where the page's stale number most likely comes from. Three surfaces, two numbers, one of them wrong in both places. **Status: REWRITE both; the number lives in one place (the filesystem) and everything else should cite it.**

### F4. "Each file ends with one `Next:` hop and the path has an end, not a circle"
**`README.md:37`**, added in `0e40c72` four hours before this audit. Both halves are false:

- **Two hops, not one**, in at least two files: `philosophy/lighting-the-abyss.md:52` ("Next: `skills/lamps/SKILL.md`, then `the-repo-already-knew.md`") and `philosophy/the-machine-is-a-mirror-of-what-could-be-measured.md:38` ("Next: `docs/ROOM_AND_GROUND.md`, then `the-instrument-that-lies-toward-caution.md`").
- **A circle**: `philosophy/the-repo-already-knew.md:43` hops back to `docs/SEVEN_CHEAP_LIES.md`, which hops to `philosophy/README.md:23`, which hops to `what-the-agent-values.md:49`, which hops to `lighting-the-abyss.md:52`, which hops to `the-repo-already-knew.md`. That is a closed loop of five files, and it is the loop the commit message says was removed.
- The advertised path also does not match the actual hops: `philosophy/README.md` now sends the reader to `what-the-agent-values.md`, and following the chain from there never reaches `skills/lamps/SKILL.md` except via the second hop the "one hop" claim denies.

`best-practices.md:338` also hops to `AGENTS.md`, re-entering the path from outside it. **Status: REWRITE.** The fix is mechanical and belongs in a test: parse every `Next:` line, assert one target per file, assert the graph is acyclic.

### F5. The context-budget block does not reconcile with itself
**`best-practices.md:97-103`**:

```
- Model/harness overhead:  ~32K
- CLAUDE.md:                ~2K
- MCP servers:             0-50K
Available for work:        92-142K of 200K
```

200 - 32 - 2 - 50 = **116**. 200 - 32 - 2 - 0 = **166**. The stated range is 92-142K, 24K low at both ends, with no fourth line item to account for it. A reader who does the subtraction finds the arithmetic wrong on the page that teaches context discipline. **Status: REWRITE** (either add the missing line item or fix the range).

### F6. "Most of them ship in this repository" - 5 of 14 do
**`docs/ENGINEERING_PRINCIPLES.md:3`**: "The mechanisms are real and most of them ship in this repository."

Traced rule by rule against the filesystem:

| Rule | Named mechanism | Ships here? |
|---|---|---|
| 1 | a question in a spec template | no (advice) |
| 2 | determinacy-contract script with a shrinking baseline | **no** |
| 3 | order-of-operations in the operating rules | no (advice) |
| 4 | health contracts declaring a cadence | partial (the `definition-of-done` rung) |
| 5 | shadow-then-ratchet promotion script | **no** |
| 6 | `hooks/` | yes |
| 7 | `hooks/guard-staged-secrets.sh` scoping | yes |
| 8 | pre-commit guard rejecting uncited human-only restrictions | **no** (EP-18) |
| 9 | `hooks/guard-conflict-markers` + `session-closeout` | yes |
| 10 | "the operating rules name which instruction wins" | no (private rules) |
| 11 | `hooks/guard-staged-secrets` | yes |
| 12 | `synthetic: false` marker enforced in code | partial (the FED rung only) |
| 13 | generated boards + a sync-contract script run as a test | **no** |
| 14 | `skills/definition-of-done` | yes |

Five clear, two partial, seven absent. "Most" is false. The sharpest instance is **EP-18** (`:85`), which describes the authority guard in the present indicative - "A pre-commit guard rejects newly staged human-only restrictions" - three sentences after an unsourced 165-to-28 statistic, in a repository whose own README lists exactly three hooks and does not include it. A reader who installs the kit expecting that guard does not get it. `docs/WEB_DESIGN_PRINCIPLES.md:3` makes the same move more softly ("Several ship in this repository") and is also wrong: none of its four named mechanisms ships here (WD-3). **Status: REWRITE both opening lines to name which mechanisms are in the box and which are described.**

### F7. Two of the author's own surfaces disagree about the portfolio by 6x
`best-practices.md:327` sends the reader to `/products/ai-development-system` ($197), whose page says:

> "The complete documentation system behind **3,000+ commits and 10+ production apps**"

while `/claude-code`, linked from `README.md:7`, says:

> "**nearly 20,000 commits**" / "**137 repositories**" / "**8 live systems**"

Both are current. A reader who opens both in adjacent tabs sees a 6.6x commit discrepancy and a 13x repo/app discrepancy with no reconciliation. Neither number is checkable: `github.com/Traviseric` lists 12 public repos. **Status: REWRITE.** Pick one denominator, date it, and say what is private.

### F8. The receipts section is off by a year, and the receipt proves it
**`/claude-code`, page-text line 252**, under the heading "the receipts":

> "Live recordings of Claude Code sessions from **November 2024**. No editing. Real development."

The linked video (`youtube.com/watch?v=7FVtG4Xa_EU`) reports `"uploadDate":"2025-11-06T02:24:54-08:00"` - **November 2025**. Independently, Claude Code was not publicly available in November 2024, so no Claude Code session could have been recorded then. The claim is contradicted by the one artifact offered to support it, in the section named "the receipts". **Status: REWRITE to November 2025.**

### F9. The unsourced numbers that carry the most weight
Not contradicted, but load-bearing and unreachable, listed because a skeptical reader will pick exactly these:
- `ENGINEERING_PRINCIPLES.md:83` - "165 'gates' ... 28 were real" (an 83% false-positive rate, no artifact, no method, no date).
- `ENGINEERING_PRINCIPLES.md:63` - "an agent that would rationalize past the prose complied instantly ... and generalized the lesson within the session". The central justification for hooks, with no count and no transcript.
- `ENGINEERING_PRINCIPLES.md:3` - "between mid-2025 and September 2026", when no incident in the file is dated before June 2026.
- `README.md:37` - "the two files that people actually steal", on a repo with 0 stars and no public traffic data.
- `README.md:60` - "The single highest-leverage hook."
- `ENGINEERING_PRINCIPLES.md:61` - "Hooks are the highest-compliance documentation channel that exists."
- `best-practices.md:205` - the `.claudeignore` mechanism, absent from the current vendor docs index checked 2026-09-14, and promoted as one of three "90-second quick wins".

### F10. What is done right, and should be the template
- `philosophy/lighting-the-abyss.md:48` - an incident whose fix is a **public commit** (`e43496d`) a reader can open. This is the only incident in the corpus with a public receipt.
- `docs/HOOKS.md:73-90` - eight dated test cases with expected-vs-actual, a reproduction recipe, an honest ninth result (GitHub push protection rejected the first version of the table), and a warning that `install.sh --check` gives false drift on the author's own machines. Added `0e40c72`.
- `README.md:7` as rewritten in `0e40c72` - "That portfolio is private, so take the claim at zero and check the parts you can reach instead ... A number I ask you to believe is worth less than a command you can run." This is the honest form, and every one of the 51 unreachable rows below should inherit it.
- `docs/WEB_DESIGN_PRINCIPLES.md:93` - every number in the scanner incident survives a verbatim fidelity check against the private record.
- `/claude-code` "Every one of these is live. Go play with them." - 5/5 verified.

---

## How much of this rests on evidence a reader cannot reach

| Body of material | Claims | UNVERIFIABLE-BY-READER | Share |
|---|---|---|---|
| `ENGINEERING_PRINCIPLES.md` | 24 | 15 | 63% |
| `WEB_DESIGN_PRINCIPLES.md` | 22 | 17 | 77% |
| `philosophy/` (7 entries + README) | 23 | 11 | 48% |
| `SEVEN_CHEAP_LIES.md` | 7 | 3 | 43% |
| **The four "field-tested" documents** | **76** | **46** | **60%** |
| `README.md` + `AGENTS.md` + the kit section of the page | 34 | 5 | 15% |
| `best-practices.md` | 13 | 0 | 0% |
| Whole corpus | 130 | 51 | 39% |

**This is not automatically a defect.** An anonymised incident from a private portfolio is a legitimate genre, and it is the genre the repo declares in `CLAUDE.md` ("Field-tested only. Every pattern carries the incident that earned it, anonymized"). Two things make it a defect anyway:

1. **The unreachable claims are not marked as unreachable.** They are written in the same register as the checkable ones - exact integers, exact dates, present-tense mechanisms - so a reader cannot tell "you can verify this in one command" from "you must take my word." `README.md:7` now solves this for one sentence. Nothing else in the corpus carries the marker.
2. **The material's own standard is higher than this.** `philosophy/what-the-agent-values.md:7-9` says an unlinkable count is discounted to zero and that self-report converts to evidence only through "a receipt someone else could have produced." By that standard, 46 of the 76 claims in the field-tested documents score zero, and the documents never say so.

The entry-point material is in much better shape than the principle documents: the kit section of the live page is 70% SOURCED, `AGENTS.md` is 88% SOURCED, and everything a reader is asked to *run* checks out.

---

## Human sign-off (mandatory; any non-PASS blocks release)

17 rows are CONTRADICTED and 21 are UNSOURCED. **The gate is BLOCKED.** Rows requiring action before the next release:

| claim_id | file:line | required change | reviewer | verdict | date |
|---|---|---|---|---|---|
| EP-5 | ENGINEERING_PRINCIPLES.md:23 | fix the partition to sum to 22 | | | |
| PH-3 | philosophy/*.md final lines (7 files) | remove or repoint the `Long form:` links | | | |
| PH-2 | philosophy/README.md:5 | present tense is false while 7/7 are missing | | | |
| PH-7 | what-the-agent-values.md:27 | resolves when PH-3 does | | | |
| PH-22 | lighting-the-abyss.md:48 | narrow "the link ... fixed" to the one link | | | |
| PH-15 | a-systems-account...md:39 | cite the right cheap lie or drop the mapping | | | |
| PG-1 | traviseric.com/claude-code (kit section) | "Five skills" -> eight | | | |
| BP-1 | best-practices.md:24 | list all eight skills | | | |
| BP-3 | best-practices.md:97-103 | make the arithmetic reconcile | | | |
| BP-7 | best-practices.md:205 | source `.claudeignore` or mark it unverified | | | |
| BP-12 | best-practices.md:327 (destination) | reconcile 3,000+ commits with nearly 20,000 | | | |
| EP-3 | ENGINEERING_PRINCIPLES.md:3 | "most" -> name which ones | | | |
| EP-18 | ENGINEERING_PRINCIPLES.md:85 | mark the authority guard as not shipped here | | | |
| EP-2 | ENGINEERING_PRINCIPLES.md:3 | "mid-2025" is unsupported by any incident in the file | | | |
| EP-17 | ENGINEERING_PRINCIPLES.md:83 | mark 165/28 as private and unverifiable | | | |
| WD-3 | WEB_DESIGN_PRINCIPLES.md:3 | "Several ship in this repository" - none of the four does | | | |
| WD-4 | WEB_DESIGN_PRINCIPLES.md:5 | "invisible to a grep" contradicts rules 4 and 5 | | | |
| RM-7 | README.md:37 | two files have two hops; the philosophy chain is a cycle | | | |
| RM-9 | README.md:37 | "the two files that people actually steal" - no data | | | |
| RM-13 | README.md:60 | superlative | | | |
| EP-11 | ENGINEERING_PRINCIPLES.md:61 | superlative | | | |
| EP-12 | ENGINEERING_PRINCIPLES.md:63 | the hooks argument's key evidence is unmeasured | | | |
| PX-1 | /claude-code hero | two snapshot dates in one block | | | |
| PX-3 | /claude-code portfolio | 16 vs 23 vs 137 | | | |
| PX-5 | /claude-code receipts | November 2024 -> November 2025 | | | |
| PX-2 | /claude-code | "public proof snapshot: 137 repositories" vs 12 public repos | | | |
| SL-4 | SEVEN_CHEAP_LIES.md:60 | `CI=true` warnings-as-errors is toolchain-specific | | | |

**Signed-off by:** ____________________   **Date:** __________

> The gate runner enforces process, not substance. `python skills/verification-gate/scripts/gate_runner.py --self-test` passes (exit 0), which proves the runner works and proves nothing about the rows above. No `_VERIFICATION/` folder was scaffolded for this run and no row has been signed; by the skill's own rule this artifact does not ship until a human opens each source and marks every row.

---

## The one change

**Give every unreachable claim the marker `README.md:7` now carries, and give every reachable claim its command.** Sixty percent of the field-tested material is true-or-false only inside a private portfolio, and today it is typeset identically to the parts a stranger can run in ten seconds. One sentence at the head of `ENGINEERING_PRINCIPLES.md` and `WEB_DESIGN_PRINCIPLES.md` - "these incidents are from a private portfolio; take them at zero and check the mechanisms that ship here, which are X, Y and Z" - converts the corpus's largest liability into its stated method. The cheapest single fix, and the one a skeptical reader hits first, is F2: delete seven dead links that the repo's own first page calls a lie.

---

Run by an agent instance on 2026-09-14 against `0e40c7257324564bf0dd8b9ea9f39904bf4d7b02`. No file other than this one was created or edited. Nothing was committed.
