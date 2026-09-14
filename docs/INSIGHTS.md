# What to do with your `/insights` report

Claude Code's `/insights` command reads your local session transcripts and renders a report:
messages, sessions, what went well, where you got stuck, and a list of suggestions. Most
people read it once, feel good or bad, and close it. Here is the loop that makes it compound.

## The cadence

`/insights` cannot be scheduled or run headless. It reads `~/.claude/projects/` on the machine
where you work, and there is no batch form of it. So generation is a manual step, roughly
monthly, once per machine. Put a reminder on the calendar. Everything after generation can be
one pass.

## The loop

1. **Archive it.** Save the HTML somewhere durable in your repo, dated, with the machine name
   in the filename. Do not publish raw reports: they name your files, your clients, your
   half-finished ideas. Publish a number or two if you want proof; keep the report private.
2. **Grade every suggestion against what you already have.** The report cannot see your
   `CLAUDE.md`, your skills, or your hooks, so it will suggest things you already built. For
   each suggestion write one of three words: *Already* (you have it, the lever is enforcement),
   *Partial* (you have half of it), *Gap* (you do not have it).
3. **File the real gaps as durable changes**, never as notes. A gap becomes one of:
   - a rule in `CLAUDE.md` (behaviour you want on every session),
   - a hook in `.claude/settings.json` (behaviour you want enforced, not requested),
   - a skill (a workflow you want to invoke by name),
   - a task in your backlog (something to build).
   A suggestion that does not become one of those four things was not harvested.
4. **Track it.** Keep a small ledger: report date, suggestion, grade, what you filed, and
   whether the next report still shows the same friction. The ledger is how you stop
   re-litigating the same suggestion every month and how you watch adoption climb.

## The honest read of the numbers

- Message and session counts measure activity, not output. Lines added measure churn, not
  value. Use them to spot a change in your own pattern, not to compare with anyone.
- "Goal achieved" in the report is Claude's read of the transcript, not a verified outcome.
  If you want a real success rate, tie sessions to the things you can check: a merged PR, a
  passing gate, a shipped page. See `skills/definition-of-done`.
- The most useful section is usually the friction list. Each entry there is a candidate for a
  rule or a hook, and a hook beats a rule every time you can write one.

## One-line summary for your CLAUDE.md

```
After each /insights report: archive privately, grade each suggestion Already/Partial/Gap,
file gaps as a CLAUDE.md rule, a hook, a skill, or a backlog task, and log it in the ledger.
```

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/session-closeout/SKILL.md`.
