---
kind: session-closeout
version: 1
status: {{READY | PARTIAL | BLOCKED}}
closed_at_utc: {{YYYY-MM-DDTHH:MMZ}}
scope: {{short scope, e.g. "billing webhook retry"}}
repositories: {{comma-separated repo names}}
---

# Session closeout: {{scope}}

## Outcome

{{Two to five sentences. What this session set out to do, what actually landed, and the one-line
state it leaves things in. No hedging language; the truth ladder below carries the caveats.}}

## Landed receipts

| Repository | Branch | Commit | Remote trunk | Remote parity |
|---|---|---|---|---|
| {{repo}} | {{branch}} | {{full sha}} | origin/{{trunk}} | {{ancestor check passed / not pushed}} |

## Verification

{{Exact commands you ran in this closeout and their results. One line each, e.g.
`npm test > out.log 2>&1; echo EXIT:$?` -> EXIT:0, 42 passed. A gate you did not run is listed as
NOT RUN with the reason.}}

## Truth ladder

| Surface | BUILT | DEPLOYED | WORKS | FED | Evidence |
|---|---|---|---|---|---|
| {{feature or seam}} | {{yes/no}} | {{yes/no/n-a}} | {{yes/no/UNKNOWN}} | {{yes/no/UNKNOWN}} | {{what proves it}} |

## Loose ends

| Priority | Owner | Issue | Exact next action | Blocker or dependency |
|---|---|---|---|---|
| P1 | {{who}} | {{what is unfinished}} | {{the first command or edit}} | {{what stands in the way}} |

## Human-only actions

{{"None." or one line per action: why a model cannot do it, the recommended action, the exact
steps, and what evidence shows it is complete.}}

## Preserved workspace state

{{Foreign or unknown-ownership files, branches, worktrees, and running processes you deliberately
left alone, with their paths. "None." if the workspace is clean.}}

## Resume

- First file: {{path to read first}}
- Command: `{{the one command that rebuilds working context, e.g. git status / npm test}}`
- Restart prompt: {{one paste-ready sentence that tells the next session what to do}}
