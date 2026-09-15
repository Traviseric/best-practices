# Engineering Principles for AI Projects

Fourteen rules, each stated as the thing an agent would have done wrong, each with the failure that earned it and the mechanism that now stops it. None of them is advice. Every one was paid for, in one private portfolio of production systems run mostly by agents, between mid-2025 and September 2026.

**Take the incidents at zero.** That portfolio is private, so you cannot check any of these stories, and you should not extend them credit you have not verified. What you can reach: seven of the fourteen mechanisms ship in this repository as something you can run. Rule 4's cadence rung and rule 12's synthetic ceiling are in `skills/definition-of-done`; rules 6, 7, and 11 are the guards in `hooks/` with their recorded tests in `docs/HOOKS.md`; rule 9's conflict-marker guard is there too, with the stand-off rule in `skills/session-closeout`; rule 14's list is `docs/SEVEN_CHEAP_LIES.md`. The other seven (1, 2, 3, 5, 8, 10, 13) describe mechanisms that live in the private system; they are written so you can build your own, not so you can install mine. Where a mechanism is described in the present tense below, it exists there, not here. Dates are by month. Names are removed.

If you only read one thing: rule 3 and rule 4 together explain why this document is not a checklist. The checklist existed, it reproduced the failure in sixty seconds by hand, and it was scheduled for the following Monday.

---

## 1. You would have written the intelligence in code

**The rule.** Intelligence lives in markdown context documents; reasoning lives in the model; code is plumbing (persistence, automation, integration, scale).

**The incident.** A 5,000-line analysis module with custom NLP, scoring, and pattern matchers was replaced by about 500 lines of structured markdown that told the model how to do the analysis. Same output. The module had taken weeks and reimplemented what the model already does when given the right document.

**The mechanism.** Before any build, one question in writing: "If I gave the model a well-written document explaining exactly what I want analyzed and how, would it produce the same result as this code?" If yes, the deliverable is the document.

**Apply it.** Put that question at the top of your project's spec template.

## 2. You would have called a green board a measurement

**The rule.** "We did not measure this" is never a negative finding. A board that cannot say "unmeasured" will eventually say "false" instead.

**The incident.** August 2026: a capability matrix reported that all 22 client sites "break first at owner login". Every word was defensible and the conclusion was false. Of the 22, exactly one had an observed, attributable failure. One was ambiguous. The other twenty had never been walked at all. Days went into a fleet-wide outage that had never existed, because three states had been collapsed into the word "breaks".

**The mechanism.** A determinacy contract: every board cell carries a confidence state (observed / assumed / never checked) orthogonal to the completeness ladder, checked by a script with a baseline that may only shrink.

**Apply it.** Add a column to any status table you keep: how do we know. If the answer is "nobody ran it", write that, not zero.

## 3. You would have applied the migration before the code landed

**The rule.** A schema tightening and the code that satisfies it ship in one commit, code first, deployed before the policy is applied. A tightening you cannot land and apply together is a two-phase change: permissive policy, deploy the writer, then tighten.

**The incident.** September 2026: a row-level-security migration locked a memory table to the service role. It was applied to the production database from a worktree whose code had not landed; the deployed app still wrote with the anonymous key. Every turn of a client's AI receptionist returned HTTP 500 for hours. The founder found it by calling his own business line.

**The mechanism.** The order is written into the operating rules; the writer change lands, deploys, and only then does the policy apply. A hand-applied migration with the fix left uncommitted is treated as an incident, not a shortcut.

**Apply it.** Any migration that removes a permission is reviewed as a two-sided change: name the writer that satisfies it and the deploy that carries the writer.

## 4. You would have called a weekly check "monitoring"

**The rule.** A health contract that runs weekly is not monitoring. The check that would catch a break in sixty seconds has to run at the cadence of the break.

**The incident.** Same outage as rule 3. The text-plane health check existed, reproduced the failure in sixty seconds when run by hand, and was scheduled for Mondays at 09:30. The break happened on a Tuesday night.

**The mechanism.** Health contracts declare a cadence, and a contract whose cadence is longer than the acceptable outage is listed as coverage, not monitoring. See `skills/definition-of-done` for the rung this guards: WORKS is "and I would know within a day if it stopped".

**Apply it.** For each health check, write the longest outage it can miss. If that number is longer than you would tolerate, it is not monitoring yet.

## 5. You would have trusted your new gate's first alarm

**The rule.** A gate has two failure modes and authors test only one. A new checker is not trusted until it has been shown to fire on the historical defect it was written for and to stay silent on output already known to be good. When your own new gate fires for the first time, verify the alarm before reporting it.

**The incident.** August 2026: four gates written in one week for an outreach pipeline, every one wrong on its first live run, none in the direction its author was watching. A vocabulary rule flagged "PageSpeed" inside the public name of a public tool. A severity rule flagged a draft for omitting a finding the producer had considered, rejected, and recorded rejecting. A coverage rule reported 3,201 businesses missing because it read the wrong file. Three of four were false alarms about work that had been done. Reported as findings, they would have burned the gate's credibility on day one.

**The mechanism.** Gate authoring in both directions is a written rule; a new detector ships in shadow and is promoted to enforcing by a ratchet script only after it has fired correctly and stayed silent correctly.

**Apply it.** Keep one known-bad and one known-good fixture per gate. A gate without both is a draft.

## 6. You would have written the rule in prose

**The rule.** Hooks are the highest-compliance documentation channel that exists. A rule in prose costs context in every session forever and is skimmed; a rule in a guard costs nothing until violated, then teaches once, at the exact moment it matters, with the remedy attached.

**The incident.** Rules about worktree placement, secrets, and conflict markers lived in a long operating document for months and were violated regularly. Each became a pre-commit guard in one afternoon. Observed repeatedly afterward: an agent that would rationalize past the prose complied instantly with a well-written denial, and generalized the lesson within the session, using the sanctioned form everywhere unprompted.

**The mechanism.** The guards in `hooks/` (staged-secrets, conflict-markers, the build gate) and `docs/HOOKS.md`. Every surviving guard shares five traits, and each is a survival adaptation: fail open; staged or new content only; ratchet, not wall; the denial teaches; escape hatches exist and leave a trace.

**Apply it.** Take the rule you repeat most often and write its denial message first. Then write the guard that emits it.

## 7. You would have scoped the guard to the whole tree

**The rule.** A guard reads only the staged index or the new content. A mis-scoped guard propagates backpressure across every session at the speed of the commit rate.

**The incident.** August 2026: an authority-check guard scanned the whole tree instead of staged lines. A report that quoted the guard's own detector patterns was committed, and within the hour the guard was blocking other sessions' unrelated commits until a concurrent session patched in an exemption. Scope is not a nicety; it is the difference between a guard and an outage.

**The mechanism.** `hooks/guard-staged-secrets.sh` reads `git diff --cached` and nothing else. Two gate hooks written in July 2026 were reverted the same day for the opposite reason: they blocked too much and the founder chose speed. What survived by August was not fewer rules but better-scoped ones.

**Apply it.** In any hook, print what it scanned. If the list is longer than what you staged, it is wrong.

## 8. You would have invented a reason to ask the human

**The rule.** A restriction is a claim about authority, and an unverified claim about authority is treated exactly like an unverified claim about revenue: denied without a citation.

**The incident.** The system's most persistent failure mode was never agents doing too much. It was agents inventing caution: guessing that something needed approval, writing the guess into a document, and manufacturing human workload. A sweep found 165 "gates" that supposedly required the founder; 28 were real.

**The mechanism.** A pre-commit guard rejects newly staged human-only restrictions that do not carry an adjacent marker citing an actual decision. Watching an agent hit it is instructive: it does not delete the restriction, it goes and finds out whether the authority exists, and the document ends up correctly cited or correctly delegated.

**Apply it.** When you write "requires approval", write who decided that and when, next to it. If you cannot, delete the line.

## 9. You would have amended, stashed, or "recovered" in place

**The rule.** Never amend in a shared repository; add a follow-up commit. Never stash or rebase in place when other sessions share the checkout. Write the reflog down before any recovery. If another session already holds the lane, stand off and report.

**The incident.** July 2026: a session amended a commit that was not its own and cost a reflog archaeology session to unwind. August 2026: a "recovery" nobody wrote down first silently reverted 67 lines of a concurrent session's work. September 2026: a stalled `pull --rebase --autostash` had neither `rebase-merge` nor `rebase-apply` present, so a session misread the state, ran `git add -A`, and committed raw conflict markers and an invalid `package.json`; scheduled tasks then kept committing on the detached HEAD of that stalled rebase for hours.

**The mechanism.** `hooks/guard-conflict-markers` denies the commit with markers in it. Landing happens from a worktree branched off the remote trunk, by cherry-pick, with explicit paths. `skills/session-closeout` encodes the stand-off rule and the explicit-path commit.

**Apply it.** Before any git operation you would call a fix, run `git reflog` and paste the top five lines into your notes. Then act.

## 10. You would have let the glue mangle the payload

**The rule.** Write files with the file tool, not with heredocs or multi-line shell strings, and never regenerate, re-sort, or round-trip a registry file to change part of it.

**The incident.** A heredoc collapsed the `\b` in a Windows path into a backspace character inside a registry row (it happened again the day this document was written). A 4-line semantic change once produced a 1,371-line diff. A sort of a 328-entry gate registry caused a merge conflict that had nothing to do with the change. In a repository where several agents hold concurrent worktrees, gratuitous reformatting is other people's merge conflicts.

**The mechanism.** The operating rules name which instruction wins when a harness tells the agent to prefer shell tools: for multi-line payloads, paths, regexes, JSON, the file tool wins. `git diff --stat` larger than the intended change is treated as the bug.

**Apply it.** If your diff stat surprises you, revert and redo with targeted edits before committing.

## 11. You would have committed the password inside the PDF

**The rule.** Secrets never enter git, and that includes documents: PDFs, DOCX, screenshots, fixtures, pasted transcripts. A leaked secret is not fixed by a follow-up commit; it is in history and must be rotated.

**The incident.** July 2026: a tracked PDF was found carrying plaintext passwords. Another session found an unauthenticated admin route serving strategy content. August 2026: a service key reported as "configured" in a hosting console was an empty string; the code's own length guard failed silently into a log nobody read, and a live test was lost to it.

**The mechanism.** `hooks/guard-staged-secrets` denies a commit whose staged files carry a provider-prefixed live credential. It reads only the index and it cannot read binary documents, so the PDF case is still on the human. Values are read, not names: a variable listed in a console is not a configured value until its length is checked.

**Apply it.** Install the guard, and add one line to your review checklist: open any document you are about to commit.

## 12. You would have let a rehearsal prove demand

**The rule.** Synthetic evidence has a ceiling. A rehearsal you control can prove mechanics; it can never prove demand, adoption, revenue, or reality. The two ladders never collapse.

**The incident.** A fitness client's whole intake chain returned a live receipt at every hop, all from the operator's own verification traffic. Months later a session read that as "proven" and made a wrong call about whether the chain was switched off. Nothing was off. It had never carried a stranger.

**The mechanism.** Where it matters most, the rule is in code: a transaction event without an explicit `synthetic: false` marker cannot earn the top rung. `skills/definition-of-done` names the rung (FED) and what it takes.

**Apply it.** Tag every test event as synthetic at the source. Let the dashboard count them separately.

## 13. You would have hand-typed the map and trusted it

**The rule.** Prose may cite truth; it may never store it. If a mirror can be generated from the source of truth, generate it. If it must stay human prose, put a sync check on it.

**The incident.** July 2026: a pipeline stage was present in the runbook, the skill, and the code, and missing from the machine-readable twin, so the status command had never surfaced it to anyone. The map had drifted from the territory in the one place nobody reads.

**The mechanism.** Generated boards for data; a sync-contract script for prose mirrors, run as a test; a lookup table that points at files instead of restating them.

**Apply it.** For every doc that describes a process, name the file it would be wrong about, and write a check that compares them.

## 14. You would have said "verified" about a check you did not run

**The rule.** An HTTP 200 is not content. A live process is not a finished job. Re-reading a file is not running the gate. A short SHA is not a SHA. A configured variable name is not a configured value. A local build is not the CI build. A piped exit code is not the command's exit code.

**The incident.** Each of the seven has produced a false "done" in one portfolio. The full account is in `docs/SEVEN_CHEAP_LIES.md`.

**The mechanism.** `skills/definition-of-done` will not let a completion claim leave without its rung and its proof. The honest answer ("I could not check") is always cheaper than the retraction.

**Apply it.** Read the seven before you next type the word "verified".

---

## Running this on your project

- **Quick check.** Pick the rule whose incident sounds most like last month. Apply its mechanism this week.
- **Full ride.** Rules 6, 7, 11 install as hooks in an afternoon (`docs/HOOKS.md`). Rules 2, 4, 5, 12, 13 are one script each. Rules 3, 9, 10 are order-of-operations and live in your `CLAUDE.md`. Rule 1 is a question in your spec template. Rule 14 is a read.
- **For agents running overnight.** Rules 2, 5, 9, and 14 are the ones that fail without a human in the room. Wire their mechanisms before the first unattended run.

---

Provenance: distilled from a private operating system's rules, incident reports, and guard studies on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/WEB_DESIGN_PRINCIPLES.md`.
