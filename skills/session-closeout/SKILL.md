---
name: session-closeout
description: >-
  Close a work session or agent window safely and leave it restartable: finish or honestly stop
  in-scope work, collect results from any running subagents, run the repo's gates, reconcile docs
  that describe current truth, commit and push only the files this session owns (explicit paths,
  never `git add -A`), clean only this session's worktrees and temp files, and write a durable
  handoff with commit SHAs, verification evidence, loose ends, and exact resume instructions.
  Trigger whenever the user says "close out", "wrap up", "wrap this session", "hand off", "finish
  and hand off", "I'm shutting down", "I'm restarting", "commit everything and leave it clean", or
  "leave it clean for the next session".
---

# Session Closeout

Turn the current conversation and workspace into landed work plus a durable restart point. A closeout
is not permission to deploy, charge, message, publish, or mutate anything outside the work already
authorized in this session.

## The one outcome

End in exactly one of three states, and say which:

- **READY**: every session-owned change is verified, pushed, documented, and resumable.
- **PARTIAL**: useful work is pushed, but named loose ends remain, each with an exact next action.
- **BLOCKED**: a safe landing is impossible; the work is preserved and the exact blocker is recorded.

Never report READY while a required gate, push, doc update, or handoff is missing. A remembered green
is not evidence; only a gate you ran in this closeout counts.

## 1. Freeze and inventory

1. Read the repo's `AGENTS.md` and `CLAUDE.md`, then its maintained handoff or roadmap file if one
   exists.
2. List every repository this conversation touched.
3. Collect results from any subagents still running. Wait a bounded time for safe in-flight work;
   do not kill useful work just to make the window look clean. Record anything still running.
4. Classify every changed path:
   - `OWNED`: created or edited by this session.
   - `FOREIGN`: another person's or agent's in-progress work.
   - `RUNTIME`: generated state, logs, caches.
   - `UNKNOWN`: ownership cannot be proven.
5. Stage, revert, move, or delete only `OWNED` paths. Name `FOREIGN` and `UNKNOWN` paths in the
   handoff and leave them alone. Never run `git add .`, `git add -A`, `git reset --hard`, `git
   commit --amend`, or a broad cleanup in a checkout that other people or agents also use.

## 2. Reconcile truth before landing

1. Finish safe, already-authorized work when an obvious next step remains. Do not expand scope.
2. For every completion claim, use the `definition-of-done` skill in this repo
   (`skills/definition-of-done`). Record BUILT, DEPLOYED, WORKS, and FED separately. An unknown or
   unrunnable rung stays loud in the handoff; it is never rounded up.
3. Run the repo's declared health check plus proportional build, test, and lint gates. Save the exact
   commands and their outcomes. Do not pipe a gate's output into another command and trust the exit
   code; redirect to a file and read the tallies.
4. Update the maintained handoff, roadmap, spec, and `CLAUDE.md` lookup entries when this session
   changed current truth: architecture, commands, dependencies, or human gates. Replace stale claims
   in place. Do not append a contradictory status paragraph under the old one.
5. Sweep the conversation for knowledge that exists only in chat: a workaround, a gotcha, a rule you
   discovered, a decision the user made. File each one in its proper home in this same closeout. A
   lesson that stays in the transcript does not exist for the next session.
6. If three or more actions can only be done by a human (credentials, consent, spend, a physical
   step), list them in one place in the handoff with why a model cannot do them, the recommended
   action, and what evidence shows completion.

## 3. Land each repository

For each touched repo, in dependency order:

1. Inspect `git status --short --branch`, the current branch, the remote, and how far `HEAD` is
   from `origin/<trunk>`.
2. If the shared checkout carries foreign dirt or another session is active in it, land from an
   isolated worktree branched off fresh remote truth instead of committing in place.
3. Fetch, replay your changes onto the fresh trunk, rerun the affected gates, and stage an explicit
   allowlist of `OWNED` files by path.
4. Commit with a scoped conventional message and push. Never force-push a shared branch.
5. Verify the landed SHA is an ancestor of the remote trunk (`git merge-base --is-ancestor <sha>
   origin/<trunk>`). Record both the SHA and that check.
6. Remove only this session's merged branch, worktree, and disposable artifacts, after resolving
   their exact paths. Preserve unrelated runtime state.

If contention prevents landing, retry once from fresh remote truth. On a second failure, stop,
preserve the branch or worktree, record the exact recovery command, and report BLOCKED or PARTIAL.

## 4. Write the restart record

Always leave a durable record once the commits are known:

1. If the repo has a maintained `HANDOFF.md` (or equivalent resume front door), update it there.
2. Otherwise create a timestamped file from `assets/HANDOFF-TEMPLATE.md`, for example
   `docs/handoffs/2026-09-14T2100Z-<short-scope>.md`, and fill every field. Delete any placeholder
   you did not fill; a `{{FIELD}}` left in the file is a lie about completeness.
3. The record must state: the outcome, each repository with branch, SHA, and remote parity, the
   verification commands and results, the truth ladder per surface, prioritized loose ends with an
   exact next action each, human-only actions, preserved foreign or unknown state, and the first
   file, command, and paste-ready prompt for resuming after a reboot.
4. Never store credentials, tokens, or connection strings in the record. Reference them by name.
5. Commit and push the record last, with the same explicit-path discipline.

## 5. Final audit and response

Before yielding:

- fetch and prove each landed SHA is on its remote trunk;
- confirm no session-owned uncommitted file, worktree, branch, or temp artifact remains;
- confirm foreign and unknown changes are untouched and listed;
- confirm the handoff has no placeholders and is pushed;
- report READY, PARTIAL, or BLOCKED, the SHAs, the gates you ran, the loose ends, and the one
  resume entrypoint.

Do not say "everything is committed" when the workspace still holds preserved foreign files. Say
exactly what was landed and exactly what was deliberately left alone.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `skills/definition-of-done/SKILL.md`.
