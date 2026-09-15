# Documentation Organization for Agents

Seven rules, each stated as the thing an agent would have done wrong, each with the failure that earned it and the mechanism that now stops it. Documentation is the only thing a session leaves behind, so its organization is not housekeeping. It is the difference between a system that compounds and one that relearns.

**Take the incidents at zero.** They come from a private portfolio of agent-run systems between mid-2025 and September 2026. You cannot check them. They are written so you can recognize the shape in your own repo, which is the only place the rule matters.

---

## 1. You would have put the index in the file that loads every session

**The rule.** Externalize lookup. Never externalize behavior. An index exists to be searched; a convention exists to fire. Preloading an index into every session is paying, forever, for something `grep` does better on demand.

**The incident.** August 2026: the root instruction file of a multi-repository system reached **236,000 characters**, past the harness limit, auto-loaded into every session on every machine. The breakdown was the lesson. The lookup table was 78% of the file, and its keyword-dense search-terms column alone was **93,000 characters, about 23,000 tokens per session**. Those keywords existed to be searched. Every session on every machine paid to have them in context instead.

**The mechanism.** The full index moved out verbatim to a separate registry file, byte-identical, where it is now more useful because it is greppable. What stayed behind is a routing stub: a hard rule to grep the index before answering where anything lives, plus only the few highest-priority front doors. Result: 236k to 36k, zero content loss.

**Apply it.** If your agent instruction file is mostly a table, move the table to `docs/INDEX.md` and leave a rule that says to grep it. Keep the conventions where they are; a behavioral rule in a file nobody opens is not a rule.

## 2. You would have written the conclusion into the index row

**The rule.** A row owns a title, a path, and search terms. The document it points at owns the verdict. A row longer than about two sentences is an essay in the wrong organ.

**The incident.** One day after the cut above, the same table started regrowing. Research rows were carrying 300 to 500 words of inline synthesis each: verdicts, rejected claims, adopted lenses, all in the row rather than in the filed document the row pointed at. Why it happened is the interesting part. A session that has just finished something wants its conclusion seen, and the index row is the only surface it knows every future session will load. Inlining is locally rational and diffusely expensive: every session on every machine pays for every inlined verdict forever, and the table's signal-to-index ratio falls, which quietly weakens the grep-first discipline the table exists to serve.

**The mechanism.** A row diet, run periodically: any row body longer than two sentences moves into its target document, leaving the search terms. The fix is not a rule against writing conclusions. It is a home for them.

**Apply it.** Read your own index. Any row you would describe as "a good summary" is the defect.

## 3. You would have trimmed the file and lost the content

**The rule.** Every section removed from an agent instruction file must survive in a linked document. New sessions see that file automatically and nothing else. Unlinked content is deleted content, whatever the filesystem says.

**The incident.** This is the failure the "keep it under 100 lines" advice causes when followed literally. Roadmap tables, file maps, and brand guides get cut for length, land nowhere, and the next session rebuilds them from scratch with different values.

**The mechanism.** A five-step trim: identify every section being removed, verify each has a home, create the home if it does not exist, link it from the lookup table, and link it from the documentation index so the master list stays complete. The lookup table is the bridge; it tells future sessions where everything that was trimmed went.

**Apply it.** Before deleting a section, paste it into its new file and link it. Then delete.

## 4. You would have trusted the runbook

**The rule.** Stale operational documentation is worse than none, because models obey it. A document that tells an agent what to run carries a verified date, and a superseded document gets a tombstone in the same commit that supersedes it.

**The incident.** July 2026: a canonical onboarding playbook still said its automation was "not built yet". Eight pipeline stages had been built and shipped in the meantime. Agents read the playbook, believed it, and hand-cloned an old project by hand while the tooling sat unused. Nobody had lied; the document had simply stopped being re-read by the people who changed the code. This is the single most reliable way a cheaper or faster model fails in a mature system: it trusts the document.

**The mechanism.** Two rules, both enforced as part of the change that causes them. First, a tombstone on supersession: the same commit that supersedes a document's operational content adds a loud banner at the top naming what replaced it and the exact path, and saying which one wins on disagreement. Second, a verified stamp: runbooks and contracts carry a `Status: ... (verified against code YYYY-MM-DD)` line, re-verified whenever the document is touched. A stamp older than the code it describes is a signal to re-verify before obeying.

**Apply it.** Grep your `docs/` for the words "not yet", "coming soon", and "will be". Each hit is a claim with a date attached that nobody checked.

## 5. You would have written "run these steps in order"

**The rule.** Where a document's job is sequencing, prefer an instrument to prose. A status script that reads the actual artifacts and prints the next command cannot go stale the way a list of steps does.

**The incident.** The same failure as rule 4, one level deeper. The stale playbook was stale precisely in its ordering. A script that read the pipeline's own artifacts and printed the next command would have been correct on the day the automation shipped, without anyone remembering to edit prose.

**The mechanism.** Sequencing documents get replaced by a status command plus a one-line pointer. The prose describes intent; the instrument describes state.

**Apply it.** If you catch yourself numbering steps in a document, ask whether a fifteen-line script could print step N by looking at the repo.

## 6. You would have created the document and told nobody

**The rule.** A new document that nothing points at will not be found. Registration is part of creating it, not a follow-up task.

**The incident.** The general case behind every "we already had a doc for that" discovery. In a system where sessions do not persist, an unregistered document is indistinguishable from one that was never written; the next session writes a second one, and now the two disagree.

**The mechanism.** A registration step with two surfaces: a row in the nearest index, and a row in the lookup table with five to twelve comma-separated search terms. The search terms are the actual discovery signal, so they are written as the words an agent reaching for the capability would type, not as a description of the file.

**Apply it.** When you add a document, add its index row in the same commit. If your repo has no index, the document you just wrote is the reason to make one.

## 7. You would have let the root fill up

**The rule.** A clean root and a `docs/` folder with an index. Fewer than about fifteen files at the root, everything else in a folder with a reason.

**The incident.** The milder, more common version of rule 1: documentation scattered at the root, no entry point, inconsistent naming, important material buried. Agents then search instead of navigating, and searching costs tokens and returns the wrong file. The severe version, measured in one cleanup: 218 root entries, about 25 GB of abandoned scratch, and 280 worktrees of which 192 were stale.

**The mechanism.** A root-hygiene rule naming exactly what may live at the root, plus a janitor script that reports drift and refuses to delete anything holding uncommitted work.

**Apply it.**

```
your-project/
  CLAUDE.md          agent entry point: conventions and the lookup table
  AGENTS.md          stable pointer for other agents (see docs/AGENTS_MD_CONTRACT.md)
  README.md          human entry point
  src/  tests/
  docs/
    INDEX.md         the index every other doc registers into
    guides/          how to do a thing
    specs/           what a feature is supposed to do
    architecture/    why the system is shaped this way
```

Naming: pick `kebab-case.md` for guides and reserve `UPPER_CASE.md` for the handful of files convention already names. Consistency matters more than which one you pick.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `best-practices.md` (the lookup-table pattern).
