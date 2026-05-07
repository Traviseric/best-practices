# Best Practices for AI Coding Agents

A field-tested playbook for getting better results from AI coding agents — Claude Code, Codex, Cursor, Aider, and friends.

Built by [Travis Eric](https://traviseric.com) from running production agent fleets across a 55+ project portfolio. This is the public foundation; the deeper material lives in [consulting](https://traviseric.com) and [paid courses](https://traviseric.com/courses/ai-first-fundamentals).

> **Tool-agnostic.** The principles apply to any agent. Examples use Claude Code because that's what I run, but the patterns transfer.

---

## Start Here

| If you want to... | Read this |
|---|---|
| Get the principles fast | [best-practices.md](best-practices.md) |
| Audit your existing project | [docs/AUDIT_YOUR_PROJECT.md](docs/AUDIT_YOUR_PROJECT.md) |
| Add the #1 highest-leverage hook | [docs/PRE_COMMIT_BUILD_GATE.md](docs/PRE_COMMIT_BUILD_GATE.md) |
| Set up a new project right | [templates/](templates/) + [best-practices.md](best-practices.md) |
| Cut MCP token bloat | [docs/MCP_OPTIMIZATION.md](docs/MCP_OPTIMIZATION.md) |
| Organize messy docs | [docs/DOC_ORGANIZATION.md](docs/DOC_ORGANIZATION.md) |
| Build sites with agents | [docs/WEB_DESIGN_PRINCIPLES.md](docs/WEB_DESIGN_PRINCIPLES.md) |

---

## What's Inside

```
best-practices/
├── README.md                          # You are here
├── CLAUDE.md                          # Pin for agents working on this repo
├── best-practices.md                  # The flagship guide — 10 principles
├── docs/
│   ├── PRE_COMMIT_BUILD_GATE.md       # The single highest-leverage hook
│   ├── AGENTS_MD_CONTRACT.md          # Stable entrypoint for tool-portable repos
│   ├── MCP_OPTIMIZATION.md            # CLI > MCP, token costs, config switching
│   ├── DOC_ORGANIZATION.md            # Clean root, docs/ structure
│   ├── AUDIT_YOUR_PROJECT.md          # Run an agent audit on your project
│   ├── ENGINEERING_PRINCIPLES.md      # Core principles for AI-first development
│   ├── PATTERNS.md                    # Fresh context, file-based state, handoffs
│   └── WEB_DESIGN_PRINCIPLES.md       # Building sites with agents
└── templates/
    ├── CLAUDE.md.template
    ├── AGENTS.md.template
    ├── .claudeignore.template
    └── settings.json.template          # The pre-commit build gate, ready to drop in
```

---

## The Quick Wins (90 seconds each)

If you only do three things in your project today:

1. **Add a `CLAUDE.md`** with a lookup table. Use [the template](templates/CLAUDE.md.template). Keeps your agent oriented.
2. **Add a `.claude/settings.json` pre-commit build gate.** Use [this template](templates/settings.json.template). Stops broken commits cold. See [PRE_COMMIT_BUILD_GATE.md](docs/PRE_COMMIT_BUILD_GATE.md).
3. **Add a `.claudeignore`.** Use [this template](templates/.claudeignore.template). Stops the agent choking on PDFs and `node_modules/`.

---

## How To Audit Any Project

Open your agent in your project and paste:

```
Read the best practices guide at:
https://raw.githubusercontent.com/Traviseric/best-practices/main/best-practices.md

Then audit THIS project against those practices. Check:
1. CLAUDE.md — exists? under 100 lines? has a lookup table?
2. Structure — feature-based? root clean (< 15 files)?
3. Documentation — docs/ folder? clear README?
4. Testing — tests present? test command documented?
5. Pre-commit hooks — .claude/settings.json with build gate?

Give me a scorecard (1-10 per area) and specific recommendations to improve.
```

Full prompt and scoring rubric: [docs/AUDIT_YOUR_PROJECT.md](docs/AUDIT_YOUR_PROJECT.md).

---

## Going Deeper

This repo is the public foundation. For the production version with the full ruleset, advanced patterns (Loom, Embedded Software Factory, parallel agent orchestration), and the full enterprise audit framework:

- **[AI-First Fundamentals](https://traviseric.com/courses/ai-first-fundamentals)** — 37-lesson course on engineering principles for AI-first development
- **[Complete AI Development System](https://traviseric.com/products/ai-development-system)** — Full ruleset + enhanced agent framework
- **[AI Orchestra Method](https://traviseric.com/courses/ai-orchestra-method)** — Scale to many parallel agent instances
- **[Travis Eric — Consulting](https://traviseric.com)** — For teams adopting AI-first development
- **[AI Builders Lab on Skool](https://www.skool.com/ai-builders-lab-6883)** — Free community

---

## Contributing

Found a pattern that works? PRs welcome. Keep additions:
- **Tool-agnostic** when possible (or label tool-specific clearly)
- **Field-tested** (not theoretical)
- **Short** (one concrete rule per file/section, not essays)

---

## License

MIT. Use it however you want. Attribution appreciated but not required.
