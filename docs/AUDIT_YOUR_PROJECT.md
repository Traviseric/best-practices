# Audit a Project for Agent Readiness

A procedure an agent runs on a repository it has never seen, producing findings with evidence attached. It replaces the scorecard that used to live here, for a reason worth stating first.

**Why not a scorecard.** The earlier version of this document asked the agent for a score out of ten per area. A score is an opinion with nothing under it, and an agent asked for one will produce a plausible number whether or not it looked. That is the same defect a private portfolio hit at scale in August 2026: a capability board reported that all twenty-two sites in a fleet "break first at owner login". Every word was defensible and the conclusion was false. One site had an observed failure, one was ambiguous, and the other twenty had never been checked at all. Three states had collapsed into one word. See `docs/ENGINEERING_PRINCIPLES.md` rule 2.

So this audit has no scores. Every finding carries a verdict from a fixed vocabulary, and one of the verdicts is "I did not check this".

---

## The verdicts

| Verdict | Means | Requires |
|---|---|---|
| `PASS` | Checked, and it is fine | The command you ran or the file you read |
| `FAIL` | Checked, and it is broken | The output, quoted |
| `UNMEASURED` | Not checked, and here is why | One sentence naming the blocker |

`UNMEASURED` is never a failure. It is the honest half of the finding. An audit with no `UNMEASURED` rows in a repository you met ten minutes ago is itself the finding.

---

## The procedure

Run these in order. Stop and write the audit even if you cannot finish; a partial audit with honest verdicts is worth more than a complete one with guesses.

### 1. Find the entry point

Look for `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, or an equivalent. Record which exist, how long each is, and whether more than one contains detailed instructions.

Write `FAIL` if two files both carry a maintained playbook. That is the drift described in `docs/AGENTS_MD_CONTRACT.md`, and it is the most expensive thing on this list because it is silent.

### 2. Read the playbook as a stranger

Read the entry file straight through, once, at reading speed. Then, without looking back, write down what this project is, how to build it, how to test it, and what the team is working on right now.

Anything you could not answer is a `FAIL` on that item, and the answer you would have needed is the fix. This is the same instrument as `skills/clarity-gate`, pointed at a document instead of a page.

### 3. Check the lookup table

A useful playbook maps concepts to files. Confirm a table exists and that its paths resolve. Pick three rows at random and open the files.

`FAIL` a row whose path does not exist. `FAIL` the table if rows carry paragraph-length summaries instead of pointers; `docs/DOC_ORGANIZATION.md` rule 2 explains what that costs.

### 4. Run the build and the tests

Find the commands. Run them exactly as a CI system would, not as a human would: `CI=true` where that is meaningful, the full command rather than an abbreviated one.

Record the actual output, including test tallies, not just the exit status. A suite that aborts during collection reports one tidy import error and runs zero tests while exiting cleanly in some harnesses. If you piped the command, you do not know its exit code. Lies 6 and 7 in `docs/SEVEN_CHEAP_LIES.md` are the two that bite here.

If a command is undocumented, that is a `FAIL` on documentation, and the audit continues with `UNMEASURED` on the build.

### 5. Look at the root

Count the files at the repository root. Note anything that is not source, configuration, or one of the standard entry files: loose logs, stray scripts, abandoned directories, a second copy of the repo.

More than about fifteen root files is a `FAIL` on navigability. Agents search instead of navigating when there is no obvious entry, and searching costs tokens and returns the wrong file.

### 6. Check the guards

Look in `.claude/settings.json`, or the equivalent, for `PreToolUse` hooks. Confirm three things: a build gate, a secrets guard, and a conflict-marker guard.

For each, check the wiring, not just the presence. A conditional placed on the matcher group rather than on the hook entry runs the hook on every command instead of on commits, which is slow enough that someone will eventually disable it. `docs/HOOKS.md` has the correct shape and the recorded tests.

### 7. Look for stale operational claims

Grep the documentation for "not yet", "coming soon", "will be", "TODO", and "in progress". Open each hit and compare it against the code.

Every hit is a claim with a date on it that nobody re-checked. Agents obey documentation, so a stale runbook actively causes wrong work. In one measured case a playbook said its automation was "not built yet" while eight shipped stages sat unused, and agents did the work by hand for weeks.

### 8. Check whether the last "done" was true

Find the most recent thing the repository claims is finished: a changelog entry, a closed issue, a feature in the README. Then establish which rung it actually reached, using `skills/definition-of-done`. A green build proves the code compiles and nothing else.

This is usually the most informative finding in the audit, and it is the one a scorecard never surfaces.

---

## The output

Write the audit as a list of findings, most severe first. Each finding:

```
[VERDICT] Area: one-sentence statement of what is true
Evidence: the command you ran and its output, or the file and line you read
Fix: the smallest change that would move this to PASS
```

Close with three lines: the count by verdict, the single highest-leverage fix, and an explicit list of what you did not check and why.

Do not produce a number. If the person wants a summary, the count by verdict is the summary, and it is honest in a way a score cannot be.

---

## The prompt

Paste this into an agent working in the repository you want audited:

```
Read https://raw.githubusercontent.com/Traviseric/best-practices/main/docs/AUDIT_YOUR_PROJECT.md
and run that procedure on this repository.

Follow it exactly: run the commands rather than reading them, quote real output as
evidence, and use UNMEASURED wherever you could not check something. Do not give me
a score. Finish with the count by verdict, the highest-leverage fix, and what you
did not check.
```

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/definition-of-done/SKILL.md` (https://github.com/Traviseric/best-practices/blob/main/skills/definition-of-done/SKILL.md).
