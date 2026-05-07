# Project: Best Practices

## What This Is
A public, field-tested playbook for AI coding agents. Tool-agnostic foundation; deeper material lives in paid courses and consulting.

## Lookup Table
| Concept | Files | Search Terms |
|---------|-------|--------------|
| Flagship guide | best-practices.md | 10 principles, CLAUDE.md template, context budget |
| Repo entry point | README.md | start here, what's inside, quick wins |
| Pre-commit gate (highest-leverage) | docs/PRE_COMMIT_BUILD_GATE.md | settings.json, build hook, .claude |
| Tool-portable entrypoint | docs/AGENTS_MD_CONTRACT.md | AGENTS.md, Codex, pointer file |
| Project audit | docs/AUDIT_YOUR_PROJECT.md | scorecard, recommendations |
| MCP optimization | docs/MCP_OPTIMIZATION.md | CLI vs MCP, token costs |
| Doc organization | docs/DOC_ORGANIZATION.md | clean root, docs/ folder |
| Engineering principles | docs/ENGINEERING_PRINCIPLES.md | TDD, fresh context, moat |
| Patterns | docs/PATTERNS.md | Ralph loop, file-based state, handoffs |
| Web design | docs/WEB_DESIGN_PRINCIPLES.md | building sites with agents |
| Templates | templates/*.template | CLAUDE.md, .claudeignore, settings.json |

## Conventions
- Tool-agnostic when possible. Label tool-specific content (e.g., "Claude Code:") clearly.
- Short and concrete. One rule per section. No essays.
- Field-tested only. Don't add theoretical advice.
- Don't leak proprietary content (full 39 principles, Loom, Embedded Software Factory, production audit). Those stay in courses/consulting.

## Current Focus
Initial public release. Foundation playbook with light enhancements (pre-commit gate, AGENTS.md contract, no-content-loss rule).

## Going Deeper
The deeper material — full ruleset, advanced patterns, enterprise audit — is at https://traviseric.com.
