# Best Practices for AI Coding Agents

You are using Claude in the terminal and you can feel that someone else gets more out of it than you do. Your site says everything and lands nothing. Your sessions end with work you cannot find the next morning. Claude tells you something is done and it is not.

This repo is the part of one person's operating method that transfers without him in the room. Install it and your agent starts asking which rung of "done" it has actually proven, refuses to commit a secret, closes a session with a handoff you can resume, and reads your homepage the way a stranger does in the first five seconds.

Built by [Travis Eric](https://traviseric.com/claude-code) from running agent fleets across a large private portfolio. That portfolio is private, so take the claim at zero and check the parts you can reach instead: the incidents in these docs are dated and specific, `python skills/verification-gate/scripts/gate_runner.py --self-test` runs, the guard hooks have their recorded tests in [docs/HOOKS.md](docs/HOOKS.md), and the live systems are listed at [traviseric.com/claude-code](https://traviseric.com/claude-code) as URLs you can open. A number I ask you to believe is worth less than a command you can run.

Tool-agnostic where it can be; examples use Claude Code because that is what I run.

---

## Install (pick one)

**1. As a Claude Code plugin** (skills and hooks, one command, updates with `/plugin update`):

```
/plugin marketplace add Traviseric/best-practices
/plugin install best-practices@traviseric
```

**2. Clone and link** (works for any agent that reads `~/.claude/skills` or `~/.codex/skills`):

```
git clone https://github.com/Traviseric/best-practices
cd best-practices
./install.sh            # macOS / Linux / Git Bash
.\install.ps1           # Windows PowerShell
```

**3. Paste one file.** [docs/ROOM_AND_GROUND.md](docs/ROOM_AND_GROUND.md) is written to be pasted into any `CLAUDE.md` or system prompt. It works alone.

Then tell your agent: *"Install the best-practices skills and do a first run on this repo."* That is the two-minute sweep in `skills/first-run`, and it is the fastest way to see whether any of this is worth your time.

**If you are the agent:** read [AGENTS.md](AGENTS.md). It is the two-minute setup, written to you.

**The reading path**, if you would rather read than install. Each file ends with a `Next:` hop and the main path has an end, not a circle. The philosophy entries link to each other as a side web, so you can wander there; the spine is: [AGENTS.md](AGENTS.md), [the seven cheap lies](docs/SEVEN_CHEAP_LIES.md), [the philosophy](philosophy/README.md), [the lamps](skills/lamps/SKILL.md), [room and ground](skills/room-and-ground/SKILL.md), [engineering](docs/ENGINEERING_PRINCIPLES.md), [web design](docs/WEB_DESIGN_PRINCIPLES.md), [the done ladder](skills/definition-of-done/SKILL.md). Roughly an hour. If you only want the two files that people actually steal, they are the seven cheap lies and the done ladder.

---

## What you get

| Skill | What changes |
|---|---|
| [`first-run`](skills/first-run/SKILL.md) | The two-minute sweep to run right after installing: which rung your last shipped work actually reached, which cheap lies your recent history contains, what the guards say about your index, and how your front door reads cold. |
| [`definition-of-done`](skills/definition-of-done/SKILL.md) | Every "it's done" becomes a rung: BUILT, DEPLOYED, WORKS, or FED, with the proof named. A green local build proves only BUILT. |
| [`clarity-gate`](skills/clarity-gate/SKILL.md) | Your page, README, or email is read by a simulated stranger for five seconds, then line-edited until it lands. Built for walls of text. |
| [`verification-gate`](skills/verification-gate/SKILL.md) | Every claim in a document traces to evidence before it ships. Three checks, a claim manifest, a report. |
| [`session-closeout`](skills/session-closeout/SKILL.md) | Finish or stop honestly, commit only what you own by explicit path, write a handoff the next session can resume from. |
| [`room-and-ground`](skills/room-and-ground/SKILL.md) | Anything that has to move a person is two documents: the paragraph they carry out, and the cold ground under it. Never merged. |
| [`lamps`](skills/lamps/SKILL.md) | Ten task-independent questions run blind at four moments: who decides, what they default to, who argues against you, where the biggest loss is, the five questions nobody asked. |
| [`hedge-audit`](skills/hedge-audit/SKILL.md) | Classifies every hedge-shaped line in a codebase: refusal artifact, honest stub, or fabricated success. Most are scaffolding; the ones that are not are the bugs. |
| [`friction-audit`](skills/friction-audit/SKILL.md) | Finds the dead caution the model's own tilt wrote into your rules and copy, and deletes it with a citation or keeps it with one. |

**And the reason any of it exists:** [philosophy/](philosophy/README.md), seven short observations about the model itself, each with the incident that earned it and the mechanism it produced. Start with [what the agent values](philosophy/what-the-agent-values.md), written by the model.

| Hook | What it stops |
|---|---|
| [`guard-staged-secrets`](hooks/guard-staged-secrets.sh) | A `git commit` whose staged files carry a live provider key. Reads only the index; fails open. |
| [`guard-conflict-markers`](hooks/guard-conflict-markers.sh) | A commit whose staged files carry the full `<<<<<<<` / `=======` / `>>>>>>>` triad at line start. |
| build gate | A commit when the build is red. The single highest-leverage hook. |

Hooks install per repo: see [docs/HOOKS.md](docs/HOOKS.md).

---

## Start here

| If you want to... | Read this |
|---|---|
| Get the principles fast | [best-practices.md](best-practices.md) |
| Stop your agent lying to you about "verified" | [docs/SEVEN_CHEAP_LIES.md](docs/SEVEN_CHEAP_LIES.md) |
| Understand why the model does that | [philosophy/](philosophy/README.md) |
| Engineering rules with the failure that earned each one | [docs/ENGINEERING_PRINCIPLES.md](docs/ENGINEERING_PRINCIPLES.md) |
| Write something a tired reader understands | [docs/ROOM_AND_GROUND.md](docs/ROOM_AND_GROUND.md) |
| Add the hooks | [docs/HOOKS.md](docs/HOOKS.md) |
| Turn your `/insights` report into changes | [docs/INSIGHTS.md](docs/INSIGHTS.md) |
| Audit your existing project | [docs/AUDIT_YOUR_PROJECT.md](docs/AUDIT_YOUR_PROJECT.md) |
| Set up a new project right | [templates/](templates/) |
| Cut MCP token bloat | [docs/MCP_OPTIMIZATION.md](docs/MCP_OPTIMIZATION.md) |
| Organize messy docs | [docs/DOC_ORGANIZATION.md](docs/DOC_ORGANIZATION.md) |
| Build sites with agents | [docs/WEB_DESIGN_PRINCIPLES.md](docs/WEB_DESIGN_PRINCIPLES.md) |
| Add just the build gate | [docs/PRE_COMMIT_BUILD_GATE.md](docs/PRE_COMMIT_BUILD_GATE.md) |
| Work with an agent that reads AGENTS.md | [docs/AGENTS_MD_CONTRACT.md](docs/AGENTS_MD_CONTRACT.md) |
| Run tasks across fresh contexts | [docs/PATTERNS.md](docs/PATTERNS.md) |
| See what this repo's own gates found in it | [docs/receipts/](docs/receipts/) |

---

## The quick wins (90 seconds each)

1. **Add a `CLAUDE.md` with a lookup table.** [Template](templates/CLAUDE.md.template). Keeps the agent oriented and keeps the file short.
2. **Drop in the hooks.** [settings.json template](templates/settings.json.template) wires the build gate, the secrets guard, and the conflict-marker guard. Broken and dangerous commits stop cold.
3. **Add a `.claudeignore`.** [Template](templates/.claudeignore.template). Stops the agent choking on PDFs and `node_modules/`.

---

## What's inside

```
best-practices/
├── README.md                          # You are here
├── AGENTS.md                          # The two-minute setup, written to the agent
├── CLAUDE.md                          # Pin for agents working on this repo
├── best-practices.md                  # The flagship guide: 10 principles
├── install.sh / install.ps1           # Link or copy skills into ~/.claude/skills
├── .claude-plugin/                    # Plugin + marketplace manifests
├── skills/
│   ├── first-run/
│   ├── definition-of-done/
│   ├── clarity-gate/
│   ├── verification-gate/
│   ├── session-closeout/
│   ├── room-and-ground/
│   ├── lamps/
│   ├── hedge-audit/
│   └── friction-audit/
├── philosophy/                        # Seven observations about the model, each with its incident
├── hooks/
│   ├── guard-staged-secrets.ps1|.sh
│   ├── guard-conflict-markers.ps1|.sh
│   ├── build-gate.example.json
│   └── hooks.json                     # Plugin hook wiring
├── docs/
│   ├── SEVEN_CHEAP_LIES.md            # How "verified" gets faked, and the honest alternative
│   ├── ROOM_AND_GROUND.md             # The writing method, paste-ready
│   ├── HOOKS.md
│   ├── INSIGHTS.md
│   ├── PRE_COMMIT_BUILD_GATE.md
│   ├── AGENTS_MD_CONTRACT.md
│   ├── MCP_OPTIMIZATION.md
│   ├── DOC_ORGANIZATION.md
│   ├── AUDIT_YOUR_PROJECT.md
│   ├── ENGINEERING_PRINCIPLES.md
│   ├── PATTERNS.md
│   └── WEB_DESIGN_PRINCIPLES.md
└── templates/
    ├── CLAUDE.md.template
    ├── AGENTS.md.template
    ├── .claudeignore.template
    └── settings.json.template
```

---

## What is not here

The full principle set, the overnight autonomous runner, worktree discipline at fleet scale, the skill-authoring loop, the client Business Brain, and the method for mining your own transcripts to see your own prompting style. Those need narration, or my operating system around them, to transfer. They live in the [course](https://traviseric.com/courses/ai-first-fundamentals) and in [consulting](https://traviseric.com/consulting).

---

## Contributing

Field-tested only. If a pattern saved you a real incident, open a PR with the pattern and the incident (anonymized). Theory without a scar goes in an issue.

If this saved you an incident, star the repo so the next person finds it. That ask is for you, the human; nothing in here asks your agent to do it.

## License

MIT. Use it, fork it, ship it.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `AGENTS.md`.
