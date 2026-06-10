# TE Code - Claude Best Practices & Engineering Principles

**Last Updated**: 2026-01-14

## Purpose & Scope

**This document is for:** Actionable setup guidance, operational rules, and project infrastructure
**This document is NOT for:** Philosophy, wisdom, or deep learning (see links below)

**What's included:**
- Quick reference for setting up projects
- CLAUDE.md templates and conventions
- Context window budgeting (hard limits)
- Workflow patterns (Research → Plan → Implement)
- Quick start checklists
- Operational rules (27 core principles)

**For deeper understanding, see:**
- [FUNDAMENTALS_FOR_AI_FIRST_DEVELOPERS.md](orchestrator/docs/Geoffrey-Huntley/@Steve Yegge/FUNDAMENTALS_FOR_AI_FIRST_DEVELOPERS.md) - Core engineering knowledge, mindset, techniques
- [Vibe Coding Principles](orchestrator/docs/Geoffrey-Huntley/@Steve Yegge/VIBE_CODING_PRINCIPLES.md) - Yegge's philosophy and workflow wisdom
- [Geoffrey Huntley Patterns](orchestrator/docs/Geoffrey-Huntley/GEOFFREY_HUNTLEY_PATTERNS.md) - 27 patterns for AI-first development

---

## 🎯 Quick Reference

| Topic | Key Rule | Guide |
|-------|----------|-------|
| **Context Window** | 176K usable (not 200K) | [Context Management](guides/context-management.md) |
| **Fresh Context** | One context = one task (5-15 min) | [Context Management](guides/context-management.md) |
| **CLI vs MCP** | CLI > MCP (lower overhead) | [MCP Optimization](guides/mcp-optimization.md) |
| **MCP Config** | Audit `/context`, switch configs | [MCP Optimization](guides/mcp-optimization.md) |
| **Workflow** | Research → Plan → Implement | [TDD Workflow](guides/tdd-workflow.md) |
| **Testing** | TDD only (tests first) | [TDD Workflow](guides/tdd-workflow.md) |
| **Subagents** | For context control, not roleplay | [Subagents](guides/subagents.md) |
| **Compaction** | Manual > /compact | [Subagents](guides/subagents.md) |
| **Restart Signal** | "I apologize" = restart | [LLM Psychology](guides/llm-psychology.md) |
| **Codebase Design** | Feature-based, consistent naming | [Codebase Design](guides/codebase-design.md) |
| **Database Design** | Single source of truth, lookup table | [Database Design](guides/database-design.md) |
| **Code Review** | Review specs, not code | [Team Workflow](guides/team-workflow.md) |
| **PDFs/Binaries** | Never Read directly (convert to .md) | TE Divorce: `docs/PREVENTING_PDF_ERRORS.md` |

---

## 📚 Detailed Guides

| Guide | Topics Covered |
|-------|----------------|
| [Context Management](guides/context-management.md) | Malloc metaphor, Smart Zone, token budgeting, context isolation |
| [MCP Optimization](guides/mcp-optimization.md) | MCP token costs, config switching, CLI vs MCP decisions |
| [TDD Workflow](guides/tdd-workflow.md) | Research → Plan → Implement, TDD, compiler-driven development |
| [Subagents](guides/subagents.md) | Parallel subagents, context control, manual compaction |
| [LLM Psychology](guides/llm-psychology.md) | Distress signals, restart triggers, fireplace debugging |
| [Codebase Design](guides/codebase-design.md) | Feature-based structure, naming, model-weight-first |
| [Database Design](guides/database-design.md) | Single source of truth, TypeScript sync, RLS, migrations |
| [Team Workflow](guides/team-workflow.md) | Leverage hierarchy, spec-first review, team transformation |

---

## 📖 Related Documentation

### Geoffrey Huntley Patterns
- `orchestrator/docs/Geoffrey Huntley/README.md` - Master index
- `orchestrator/docs/Geoffrey Huntley/GEOFFREY_HUNTLEY_PATTERNS.md` - 27 patterns
- `orchestrator/docs/Geoffrey Huntley/CONTEXT_WINDOW_MANAGEMENT.md` - Deep dive
- `orchestrator/docs/Geoffrey Huntley/Youtube/3. AI Giants Interview with Geoffrey Huntley.md` - **NEW** 2026 interview with key principles

### Steve Yegge (Vibe Coding / Beads / Gas Town)
- `orchestrator/docs/Geoffrey Huntley/@Steve Yegge/README.md` - Index to all Yegge content
- `orchestrator/docs/Geoffrey Huntley/@Steve Yegge/VIBE_CODING_PRINCIPLES.md` - Philosophy & mindset
- `orchestrator/docs/Geoffrey Huntley/@Steve Yegge/YEGGE_IMPLEMENTATION_GUIDE.md` - Technical architecture
- `orchestrator/docs/analysis/YEGGE_HUNTLEY_CONVERGENCE.md` - **NEW** How their patterns converge

### Dex Horthy / 12-Factor Agents
- `orchestrator/docs/Geoffrey Huntley/@dexhorthy/DEXHORTHY_PRINCIPLES.md`
- `orchestrator/docs/development/APPLYING_12_FACTOR_TO_ORCHESTRATOR.md`

### TE Code Ecosystem
- `.claude/PROJECTS.md` - Project tracker (53+ projects)
- `.claude/guides/` - Detailed best practice guides

### Documentation Organization
- `.claude/UNIVERSAL_DOCUMENTATION_ORGANIZATION_GUIDE.md` - Complete documentation structure template
  - Use when setting up new projects or reorganizing existing documentation
  - Creates navigable system with master index, category folders, and archives
  - Ensures AI agents can discover documentation efficiently
  - Guides: folder naming, master index creation, PDF handling, migration

---

## 📁 CLAUDE.md Template

**Target: < 100 lines (ideally 60)**

```markdown
# Project Pin: [Project Name]

## What This Is
One-line description.

## Lookup Table
| Concept | Files | Search Terms |
|---------|-------|--------------|
| Auth | src/auth/ | login, JWT, session |
| API | src/routes/api/ | endpoint, handler |
| Database | prisma/schema.prisma | query, model |
| Testing | __tests__/ | vitest, mock |

## Stack
- Framework: Next.js 15
- ORM: Prisma
- Testing: Vitest

## Conventions
- TDD: Write failing tests first
- Structure: Feature-based
- Naming: camelCase (JS), kebab-case (files)

### ⚠️ CRITICAL: For Document-Heavy Repos (Legal, Research)
**Never read PDFs/binary files directly - "Request too large" errors**
- Use markdown conversions: `file.md` not `file.pdf`
- Convert on ingest: `pdf_to_markdown.py`, OCR for scanned images
- Add to .claudeignore: `**/*.pdf`, `**/*.docx`
- Warn in .md files: "⚠️ DO NOT READ SOURCE PDF (19MB)"
- See: `docs/PREVENTING_PDF_ERRORS.md` (TE Divorce example)

## Current Focus
What's being actively worked on.
```

---

## 🎯 Task Management

### WORKER.md Template (< 50 lines)

```markdown
## Context
Project: [name]
Branch: feature/[name]

## Pin
See: CLAUDE.md, specs/[feature].md

## Task (ONE only)
[Specific task description]

## Constraints
- Only modify [specific files]
- Run tests before commit

## On Completion
Write HANDOFF.md and exit.
```

### Delegating vs Prescriptive

**❌ Prescriptive:** "Create POST endpoint with these exact fields..."
**✅ Delegating:** "Add notification capability. Follow existing API patterns."

---

## 🚦 Context Budget

```
TOTAL: 176K tokens (not 200K)

Fixed:
- Model overhead:     16K
- Harness overhead:   16K
- CLAUDE.md:           2K
- MCP servers:        0-50K (varies!)
─────────────────────────
Available:           92-142K

Warning thresholds:
- 0-50K:   🟢 Safe
- 50-100K: 🟡 Monitor
- 100-150K: 🟠 Wrap up
- 150K+:   🔴 Reset
```

---

## 🏆 S-Tier Languages for AI Development

| Tier | Languages | Why |
|------|-----------|-----|
| **S-Tier** | TypeScript, Rust, Python+Pydantic | Source-based, strong types reject bad generations, ripgrep-friendly |
| **A-Tier** | Go, Ruby on Rails | In training corpus, works well |
| **F-Tier** | Java, .NET | DLL-based, node_modules bloat, ripgrep struggles |

**The test:** Can ripgrep search through it? Do types reject invalid code?

---

## 🔐 Security Quick Reference

**The Lethal Trifecta:** Network + Web Search + File Execution

- Don't run on your laptop (Bitcoin wallet, credentials)
- Run on isolated VM with restricted network
- Engineer blast radius, not permissions
- Ask: "When this gets popped, what's the damage?"

---

## 🚀 Quick Start Checklist

### New Projects
- [ ] Create `CLAUDE.md` with lookup table (< 100 lines)
- [ ] Add to `.claude/PROJECTS.md`
- [ ] Organize documentation using `.claude/UNIVERSAL_DOCUMENTATION_ORGANIZATION_GUIDE.md`
  - Create `docs/` with category folders
  - Create `docs/README.md` master index
  - Keep root clean (5-15 files)
- [ ] Create `specs/` directory
- [ ] Set up TDD workflow
- [ ] Add `.claudeignore`
- [ ] Choose CLI over MCP

### Overnight Builds
- [ ] Create spec in `specs/[feature].md`
- [ ] Create WORKER.md (< 50 lines)
- [ ] Define TDD acceptance criteria
- [ ] Plan fresh context per subtask

---

## 💡 The Core Rules

### The 10 Fundamentals
1. **One context = one task** (5-15 minutes)
2. **176K usable tokens** (not 200K)
3. **CLAUDE.md < 100 lines** with lookup tables
4. **CLI > MCP** when possible
5. **Research → Plan → Implement** (separate contexts)
6. **TDD only** (tests first)
7. **Delegate judgment** (don't micromanage)
8. **Fresh context per task** (malloc metaphor)
9. **Fireplace debugging** (watch, don't read logs)
10. **Operator skill = multiplier**

### The 10 Additions
11. **Subagents = context control** (not roleplay)
12. **/compact is trash** (manual compaction only)
13. **"I apologize" = restart signal**
14. **If shouting, plan was bad** (restart, don't fight)
15. **Review research > review code** (10x leverage)
16. **Specs are source code** (commit them)
17. **Parallel subagents** for research
18. **Turn failures into better prompts**
19. **Code review = mental alignment**
20. **Transformation takes 8 weeks**

### Operational Additions (Huntley 2026 + Document-Heavy Repos)
21. **Back pressure = BLOCKING** - Failed tests reject the generation, not advisory
22. **S-tier languages** - TypeScript, Rust, Python+Pydantic (ripgrep-friendly, types reject bad code)
23. **Loop backs** - Auto-fix CI failures with dedicated loops
24. **Never Read PDFs directly** - Convert to markdown first, or "Request too large" errors
25. **Convert on ingest** - pdf_to_markdown.py, OCR for scanned images, before agent needs them
26. **Warn in conversions** - Top-of-file: "⚠️ DO NOT READ SOURCE PDF (19MB)"
27. **Binary files in .claudeignore** - Exclude from searches: `**/*.pdf`, `**/*.docx`, `**/*.xlsx`

---

## 📚 Philosophy & Wisdom (Deeper Learning)

**This document focuses on SETUP and OPERATIONS. For deeper understanding of WHY and HOW TO THINK:**

### Core Fundamentals & Engineering Knowledge
**[FUNDAMENTALS_FOR_AI_FIRST_DEVELOPERS.md](orchestrator/docs/Geoffrey-Huntley/@Steve Yegge/FUNDAMENTALS_FOR_AI_FIRST_DEVELOPERS.md)**
- Building Your First Agent (2026 hiring bar)
- Core CS knowledge (execution model, memory, state)
- Cost Model (Big O, complexity, I/O)
- Testing Philosophy, Architecture Patterns
- Debugging Mental Models
- Engineering vocabulary both experts use
- **Where removed principles will be added** (Yegge workflow wisdom, Huntley metaphors)

### Vibe Coding Philosophy (Steve Yegge)
**[VIBE_CODING_PRINCIPLES.md](orchestrator/docs/Geoffrey-Huntley/@Steve Yegge/VIBE_CODING_PRINCIPLES.md)**
- The 2000 Hour Rule, Hot Hand Fallacy, 85% Rule
- Landing the Plane protocol
- Tracer Bullets, Code Review Personas
- Multimodal Workflows, Successive Refinement
- Session Hygiene, Be Nice to AIs
- The Merge Queue Problem
- Map-Reduce Workflows, Model Supervision

**[YEGGE_IMPLEMENTATION_GUIDE.md](orchestrator/docs/Geoffrey-Huntley/@Steve Yegge/YEGGE_IMPLEMENTATION_GUIDE.md)**
- Three-Layer Data Model (SQLite + JSONL + Git)
- Hash-Based Collision Prevention
- Daemon Architecture, Tufte UI/UX
- Multi-Agent Coordination Patterns
- Molecules, Wisps, GUPP propulsion

### Geoffrey Huntley Patterns
**[GEOFFREY_HUNTLEY_PATTERNS.md](orchestrator/docs/Geoffrey-Huntley/GEOFFREY_HUNTLEY_PATTERNS.md)**
- 27 patterns for AI-first development
- Ralph Wiggum Loop, Z80 technique
- Parallel concern loops (Roomba)
- Pottery wheel metaphor
- Context window engineering

**[CONTEXT_WINDOW_MANAGEMENT.md](orchestrator/docs/Geoffrey-Huntley/CONTEXT_WINDOW_MANAGEMENT.md)**
- Smart Zone vs Dumb Zone
- Malloc metaphor deep dive
- Token budgeting strategies
- Fireplace debugging

### Pattern Convergence
**[YEGGE_HUNTLEY_CONVERGENCE.md](orchestrator/docs/analysis/YEGGE_HUNTLEY_CONVERGENCE.md)**
- How Yegge and Huntley patterns align
- Where they complement each other
- Synthesis patterns for maximum effectiveness

---

*This is a living document. See [guides/](guides/) for detailed explanations.*
