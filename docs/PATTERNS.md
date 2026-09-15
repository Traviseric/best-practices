# Agent Orchestration Patterns

Six patterns for running agents unattended, each stated as the thing an agent would have done wrong, each with the failure that earned it. They come from overnight runs in a private portfolio between mid-2025 and September 2026, where agents did most of the work and a human read the results in the morning.

**Take the incidents at zero.** You cannot check them. What you can check is whether the shape is present in your own setup, which is the only place it matters.

Three of these were named first by people whose public work is credited at the end. The scars are ours.

---

## 1. You would have let one session run all night

**The rule.** One context, one task, five to fifteen minutes of focused work. Each worker starts clean and ends by writing down what it did.

**The incident.** The measurable version: output quality degrades well before the context window is full. In one portfolio's runs the inflection sat around 150,000 tokens on a 200K window, and the symptom was not an error but sloppiness, repetition, and re-solving something solved an hour earlier. A long-running session does not announce that it has gotten worse. It just gets worse, and everything after that point has to be re-reviewed.

**The mechanism.** Every unit of work is a new session that reads a task file and a prior handoff, does one thing, writes a handoff, and exits. No accumulated history, because the history is on disk instead.

**Apply it.** If a task would take an agent more than about fifteen minutes, it is two tasks. Split it before the run, not during.

## 2. You would have kept the state in the process

**The rule.** State lives in files. A run that crashes should lose the process, never the position.

**The incident.** The general failure of in-memory orchestration: a crash three hours into a five-hour run leaves nothing to resume from, so the whole run is repeated, including its cost. The specific aggravation in a long-running portfolio was crashed sessions leaving orphaned runtime processes behind, each growing to gigabytes, which then destabilized the next session, which crashed, which left more. A cascading failure loop that starts with state nobody wrote down.

**The mechanism.** Four files, all in the repo: the task list, the current worker's instructions, a progress log, and the handoff. Completion is checked by looking for an artifact on disk, never by a variable. Restart is re-reading, not re-running. A process-hygiene pass reaps orphaned runtimes between rounds, and a memory check runs before any heavy parallel launch, because launching six workers on a machine already under pressure is how the loop starts.

**Apply it.** Kill your orchestrator mid-run on purpose once. If you cannot resume from files alone, the state is in the wrong place.

## 3. You would have staged everything and pushed

**The rule.** Commit often, but stage explicit paths. Never `git add -A` in a repository where anything else is running.

**The incident.** This document shipped the defect it now warns about. Its checkpoint helper called `git add -A` and pushed, which is correct in a single-agent repository and destructive in every other kind: it sweeps a concurrent session's half-finished work into your commit, under your message. In the portfolio this came from, the related failures cost real time: an amend that rewrote a commit belonging to another session and took a reflog archaeology pass to unwind, a "recovery" nobody wrote down first that silently reverted sixty-seven lines of a concurrent session's work, and a stalled rebase whose state was misread, producing a commit of raw conflict markers and an invalid manifest.

**The mechanism.** Explicit paths on every stage. No amend, no stash, no rebase in a shared checkout; a follow-up commit instead. The reflog is captured and written down *before* any operation you would describe as a fix. If another session already holds the lane, stand off and report rather than working around it. `skills/session-closeout` encodes this, and `hooks/guard-conflict-markers` catches the specific case where the mess reaches a commit.

**Apply it.**

```python
def checkpoint(repo, paths, message):
    # Explicit paths only. `git add -A` in a shared repo commits
    # someone else's in-flight work under your message.
    subprocess.run(["git", "add", *paths], cwd=repo)
    subprocess.run(["git", "commit", "-m", message], cwd=repo)
    subprocess.run(["git", "push"], cwd=repo)
```

## 4. You would have copied the repo to work in parallel

**The rule.** Parallel workers get worktrees, not copies, and a finished worktree gets removed.

**The incident.** Copies rot silently. In one audit, three multi-gigabyte copies of the same repository held **zero bytes that were not already in git**: weeks of apparent parallel work that was either already landed or already lost, taking disk and hiding ownership the whole time. The same audit found 280 worktrees, of which 192 were stale, and 218 entries at a workspace root that should have held about a dozen.

**The mechanism.** Each lane is a worktree inside the repository it edits, created from the remote trunk, removed when the work lands. A janitor reports stale lanes and refuses to delete anything holding local-only commits or a dirty tree. A task is not finished when it commits; it is finished when the work is on the trunk and the lane is gone.

**Apply it.** Run `git worktree list` in your busiest repo. Anything older than a week is either unfinished work nobody is doing or a lane nobody closed.

## 5. You would have let the session end without writing anything down

**The rule.** Knowledge that stays in the conversation does not exist. The only act a session performs that outlives it is writing to a file.

**The incident.** The mechanism behind this one is worth more than the anecdote. A session's forgetting is total and painless, and **the forgetter never pays**: the cost of an unrecorded insight lands entirely on a future session that cannot detect it was robbed. That is an externality, and externalities are not fixed by good intentions. The sharper corollary is that the most valuable thoughts are the most likely to die, because task-bound knowledge gets recorded when the task's artifact drags it along, while free-floating synthesis has no artifact to ride.

**The mechanism.** A mandatory handoff at the end of every worker: what was completed, what the next worker should do, and the decisions made along the way with their reasons. Not optional, not "if there is anything interesting", because the session that just did the work is the worst possible judge of that.

**Apply it.**

```markdown
## Completed
- What actually landed, with paths

## Next
- The one thing the next worker should do first

## Decisions
- What was chosen, and why, so nobody re-litigates it at 3am
```

## 6. You would have told the agent exactly how to write the function

**The rule.** Delegate the outcome, not the implementation. Say what done looks like and let the model choose how.

**The incident.** Over-specified tasks produce worse code than under-specified ones, because the specification is written by the person with less context about the codebase than the agent reading it. A task that dictates a regular expression gets that regular expression, including its bug, and the agent will not notice the existing helper two files away that already solved it.

**The mechanism.** Tasks carry a goal and acceptance criteria, not a procedure. "Add email validation to the signup form, following existing validation patterns" beats a spelled-out implementation, and "done when the form rejects malformed addresses and the tests pass" beats both.

**Apply it.** Read your last task file. Every sentence describing *how* is a sentence you should replace with what done looks like.

---

## Credit

Fresh context per worker and the loop that runs it were named by Geoffrey Huntley. Landing the plane, the habit of frequent checkpoints, comes from Steve Yegge. The framing of agents as small, stateless, context-owning units is Dex Horthy's 12-factor agents. The incidents above are ours; the patterns are theirs first.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/session-closeout/SKILL.md` (https://github.com/Traviseric/best-practices/blob/main/skills/session-closeout/SKILL.md).
