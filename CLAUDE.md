# Project: Best Practices

## What This Is
A public, field-tested playbook and Claude Code plugin for AI coding agents: skills, guard hooks, templates, and short docs. Tool-agnostic foundation; deeper material lives in paid courses and consulting.

## Lookup Table
| Concept | Files | Search Terms |
|---------|-------|--------------|
| Repo entry point | README.md | start here, install, what you get |
| Flagship guide | best-practices.md | 10 principles, CLAUDE.md template, context budget |
| Plugin manifests | .claude-plugin/plugin.json, marketplace.json | plugin install, marketplace, version bump |
| Skill installer | install.sh, install.ps1 | link vs copy, drift check, ~/.claude/skills |
| Done ladder | skills/definition-of-done/ | BUILT DEPLOYED WORKS FED, rung verdicts, completion claim |
| Clarity gate | skills/clarity-gate/ | first five seconds, wall of text, reader simulation |
| Verification gate | skills/verification-gate/ | fact-check, claim manifest, three checks |
| Session closeout | skills/session-closeout/ | handoff, wrap up, explicit-path commits |
| Room and ground | skills/room-and-ground/, docs/ROOM_AND_GROUND.md | persuasive writing, two documents, hedges |
| Seven cheap lies | docs/SEVEN_CHEAP_LIES.md | fake verification, HTTP 200 is not content, piped exit code |
| Hooks | hooks/, docs/HOOKS.md, templates/settings.json.template | secrets guard, conflict markers, build gate, fail open |
| Insights loop | docs/INSIGHTS.md | /insights, Already Partial Gap, ledger |
| Pre-commit gate | docs/PRE_COMMIT_BUILD_GATE.md | settings.json, build hook |
| Tool-portable entrypoint | docs/AGENTS_MD_CONTRACT.md | AGENTS.md, Codex, pointer file |
| Project audit | docs/AUDIT_YOUR_PROJECT.md | scorecard, recommendations |
| MCP optimization | docs/MCP_OPTIMIZATION.md | CLI vs MCP, token costs |
| Doc organization | docs/DOC_ORGANIZATION.md | clean root, docs/ folder |
| Engineering principles | docs/ENGINEERING_PRINCIPLES.md | TDD, fresh context, moat |
| Patterns | docs/PATTERNS.md | Ralph loop, file-based state, handoffs |
| Web design | docs/WEB_DESIGN_PRINCIPLES.md | building sites with agents |
| Templates | templates/*.template | CLAUDE.md, AGENTS.md, .claudeignore, settings.json |

## Conventions
- Tool-agnostic when possible. Label tool-specific content (e.g., "Claude Code:") clearly.
- Short and concrete. One rule per section. No essays. Plain ASCII punctuation.
- Field-tested only. Every pattern carries the incident that earned it, anonymized.
- Privacy: no client, prospect, or case names; no private paths or machine names; no secrets, not even as examples. Test fixtures use obviously fake values and never ship.
- Skills are self-contained. A skill may reference another skill in this repo by its folder name and nothing outside the repo.
- Hooks fail open. A guard that cannot run must never block a commit.
- Do not leak the paid tier: the full principle set, the autonomous runner, fleet-scale worktree discipline, the skill-authoring loop, the Business Brain, and transcript mining stay in courses and consulting.

## Verify
- `./install.sh --check` or `.\install.ps1 -Check` exits 0 when installed skills match the source.
- `python skills/verification-gate/scripts/gate_runner.py --self-test` passes.
- Each hook script has a recorded local test in docs/HOOKS.md; re-run it after editing a guard.
- Bump `version` in both `.claude-plugin/*.json` on any change users should receive.

## Current Focus
September 2026 refresh: plugin packaging, five skills, three hooks, the seven cheap lies, room and ground, the insights loop.

## Going Deeper
The deeper material is at https://traviseric.com/claude-code.
