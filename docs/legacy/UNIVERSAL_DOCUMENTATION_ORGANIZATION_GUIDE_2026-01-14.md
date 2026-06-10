# 📚 Universal Documentation Organization Guide

**Last Updated**: 2026-01-14

## Purpose & Scope

**This document is for:** Quick reference for organizing project documentation structure
**This document is NOT for:** Deep examples, anti-patterns, or step-by-step migration (see guides/ below)

**What's included:**
- Quick reference for folder structure
- 12 Core principles
- Standard directory template
- Root folder rules (what stays, what moves)
- Quick start checklist

**For deeper guidance, see:**
- [guides/folder-naming.md](guides/folder-naming.md) - Anti-patterns and naming conventions
- [guides/master-index-creation.md](guides/master-index-creation.md) - Creating comprehensive docs/README.md
- [guides/documentation-migration.md](guides/documentation-migration.md) - Migrating existing projects
- [guides/pdf-handling.md](guides/pdf-handling.md) - PDF/binary file handling for doc-heavy repos
- [guides/clean-root-guide.md](guides/clean-root-guide.md) - Detailed root folder organization

---

## 🎯 Quick Reference

| Topic | Key Rule | Guide |
|-------|----------|-------|
| **Root Files** | 5-15 essential files only | [Clean Root](#-clean-root-principle) |
| **docs/ Structure** | Category folders, only README.md at root | [Standard Structure](#-standard-directory-structure) |
| **Folder Naming** | Content-based, not status-based | [guides/folder-naming.md](guides/folder-naming.md) |
| **Master Index** | docs/README.md with all docs linked | [guides/master-index-creation.md](guides/master-index-creation.md) |
| **Archives** | Historical docs in archives/ subdirs | [Archive Management](#archives--historical-documents) |
| **PDF Handling** | Convert to .md, exclude from search | [guides/pdf-handling.md](guides/pdf-handling.md) |
| **Migration** | Step-by-step existing project cleanup | [guides/documentation-migration.md](guides/documentation-migration.md) |
| **CLAUDE.md** | AI context file in root (< 100 lines) | `.claude/BEST_PRACTICES.md` |

---

## 🏆 12 Core Principles

1. **📂 Category-Based Structure** - Organize by function, not chronology
2. **🎯 Priority-Based Hierarchy** - Critical → High → Medium → Nice to Have
3. **🔗 Intelligent Linking** - Master index with cross-references
4. **🧹 Clean Root** - 5-15 essential files maximum in project root
5. **📁 No Loose Files in docs/** - Only README.md lives at docs/ root
6. **📦 Content-Based Folders** - Folder names describe WHAT'S INSIDE, never lifecycle status
7. **📏 Flat Until Necessary** - No single-file subfolders; create subfolders when 3+ files of same type
8. **🚫 No Duplicate Folders** - One folder per concept (no `integration/` AND `integrations/`)
9. **🏷️ Purpose-Clear Naming** - Document names match content purpose
10. **📦 Archives for History** - Historical/deprecated docs in `archives/` subdirectories
11. **⚠️ PDF Conversion Required** - Convert binaries to .md before AI access (or "Request too large" errors)
12. **📋 Master Index Mandatory** - `docs/README.md` links ALL documentation with priority tags

---

## 📁 Standard Directory Structure

```
project-root/
├── README.md                    # 🏠 Main entry point (REQUIRED)
├── CLAUDE.md                    # 🤖 AI context (< 100 lines, TE Code best practice)
├── LICENSE                      # License file (if applicable)
├── .gitignore                   # Git ignore rules (REQUIRED)
├── package.json / requirements.txt  # Dependencies (REQUIRED)
├── [config files]               # Core config files ONLY (tsconfig.json, vercel.json, etc.)
│
├── docs/                        # 📚 ALL DOCUMENTATION
│   ├── README.md               # 📚 Master documentation index (REQUIRED)
│   ├── quick-start/            # 🚀 Getting Started (Priority: Critical)
│   │   ├── setup.md
│   │   ├── first-run.md
│   │   └── common-tasks.md
│   ├── core/                   # 🏗️ Core System (Priority: High)
│   │   ├── architecture.md
│   │   ├── main-functions.md
│   │   └── system-design.md
│   ├── features/               # ✨ Feature Documentation (Priority: High)
│   │   ├── README.md           # Feature navigation hub
│   │   ├── [feature-name]/     # ✅ Use FEATURE names
│   │   └── archives/           # Historical/deprecated features
│   ├── deployment/             # 🚀 Deployment & Production (Priority: Critical)
│   │   ├── quick-deploy.md
│   │   ├── production-setup.md
│   │   └── troubleshooting.md
│   ├── integration/            # 🔗 Integrations & APIs (Priority: High)
│   │   ├── api-reference.md
│   │   ├── third-party-services.md
│   │   └── webhooks.md
│   ├── development/            # 🛠️ Development Guidelines (Priority: High)
│   │   ├── contributing.md
│   │   ├── coding-standards.md
│   │   └── development-setup.md
│   ├── testing/                # 🧪 Testing & QA (Priority: High)
│   │   ├── test-strategy.md
│   │   └── test-guide.md
│   ├── operations/             # ⚙️ Operations & Monitoring (Priority: Medium)
│   │   ├── monitoring.md
│   │   ├── maintenance.md
│   │   └── backup-recovery.md
│   ├── research/               # 🔬 Research & Discovery (Priority: Medium) [OPTIONAL]
│   │   ├── README.md           # Research navigation hub
│   │   └── findings/           # Research findings
│   └── reference/              # 📖 Reference Materials (Priority: Medium)
│       ├── configuration.md
│       ├── cli-commands.md
│       ├── faq.md
│       └── archives/           # 📦 Historical documentation
│
├── src/ or lib/                # 📦 ALL SOURCE CODE
├── tests/                      # 🧪 ALL TESTS
├── scripts/                    # 🔧 BUILD/DEPLOYMENT SCRIPTS
├── specs/                      # 📋 FEATURE SPECIFICATIONS (TE Code pattern)
└── logs/                       # 📝 ALL LOG FILES
```

**CRITICAL**: Only essential configuration files belong in root. ALL other files go in appropriate subdirectories.

---

## 🧹 Clean Root Principle

### **Goal**: Keep project root minimal and focused (5-15 files)

### What Belongs in Root ✅

**Documentation (1-3 files max)**
- ✅ `README.md` - Main project README (REQUIRED)
- ✅ `CLAUDE.md` - AI agent context file (< 100 lines, TE Code best practice)
- ✅ `LICENSE` or `LICENSE.md` - License file (if applicable)
- ✅ `CHANGELOG.md` - Version history (optional, can go in docs/)

**Configuration Files (3-8 files)**
- ✅ `.gitignore` - Git ignore rules (REQUIRED)
- ✅ `package.json` / `requirements.txt` / `Cargo.toml` - Dependencies (REQUIRED)
- ✅ `[deploy-config]` - Deployment config (vercel.json, netlify.toml, etc.)
- ✅ `.env.example` - Environment variable template
- ✅ `[tooling-config]` - Essential tool configs (tsconfig.json, pyproject.toml, etc.)

**Entry Points (1-2 files max)**
- ✅ `index.py` / `main.py` / `app.js` / `index.ts` - Single main entry point
- ✅ `setup.py` / `Makefile` - Build/install scripts (if standard for ecosystem)

**Development Workflow (TE Code pattern)**
- ✅ `specs/` - Feature specifications directory (specs are source code)

**Total Root Files Target: 5-15 files maximum**

---

### What DOES NOT Belong in Root ❌

**Documentation Files → `docs/[category]/`**
- ❌ `ARCHITECTURE.md` → `docs/core/architecture.md`
- ❌ `DEPLOYMENT_GUIDE.md` → `docs/deployment/guide.md`
- ❌ `API.md` → `docs/integration/api.md`
- ❌ Status files, audit reports → `docs/reference/archives/`

**Rule**: Only `README.md` and `CLAUDE.md` stay in root. Everything else to `docs/`.

**Source Code Files → `src/` or `lib/`**
- ❌ `utils.py`, `helpers.js`, `config.ts` → `src/utils/`, `src/helpers/`, `src/config/`

**Test Files → `tests/`**
- ❌ `test_*.py`, `*.test.js`, `*.spec.ts` → `tests/`

**Log Files → `logs/` or `.gitignore`**
- ❌ `*.log` files → `logs/` directory or add to `.gitignore`

**Scripts → `scripts/`**
- ❌ Utility scripts → `scripts/`
- ❌ Build scripts → `scripts/` (unless Makefile is standard)

**Temporary/Runtime Files → `.gitignore`**
- ❌ `status.json`, `state.json` → Never committed, or `runtime/` folder

See: [guides/clean-root-guide.md](guides/clean-root-guide.md) for detailed decision matrix

---

## 📋 Master Index (docs/README.md)

**Purpose**: Single source of truth for ALL documentation

**Required Elements:**
1. **Quick Navigation Table** - What you need → Where to go → Time estimate
2. **Category Sections** - All 14 categories with document tables
3. **Priority Tags** - 🔥 Critical, ⭐ High, 📋 Medium, 💡 Nice to Have
4. **Role-Based Paths** - Guided learning for different users
5. **Emergency Shortcuts** - Quick links for troubleshooting
6. **Documentation Metrics** - Total docs, pages, completion status

**Template**: See [guides/master-index-creation.md](guides/master-index-creation.md) for complete template

---

## 📦 Archives & Historical Documents

**Where**: `docs/reference/archives/` or `docs/[category]/archives/`

**What Goes Here**:
- ✅ Historical status documents ("DEPLOYMENT_COMPLETE.md")
- ✅ Completion milestones ("FEATURE_X_READY.md")
- ✅ Old verification reports
- ✅ Deprecated feature documentation
- ✅ Migration history

**Organization**:
```
docs/reference/archives/
├── [feature-name]/           # Group by feature/topic
│   ├── completion-*.md
│   └── status-*.md
├── verification/             # Test/verification history
└── migrations/               # Database/system migrations
```

**Rule**: Keep archives organized by topic, not dumped in one folder

---

## ⚠️ PDF and Binary File Handling

**Problem**: Direct PDF reads cause "Request too large" errors

**Solution** (from TE Code Best Practices):

1. **Convert on Ingest** - Convert PDFs to markdown BEFORE AI needs them
2. **Add Warnings** - Top of converted files: "⚠️ DO NOT READ SOURCE PDF (19MB)"
3. **Exclude from Search** - Add to `.claudeignore`: `**/*.pdf`, `**/*.docx`
4. **Separate Folders** - `docs/source/` (originals) vs `docs/converted/` (AI-readable)

See: [guides/pdf-handling.md](guides/pdf-handling.md) for complete guide

---

## 🚀 Quick Start Checklist

### New Projects
- [ ] Create `docs/` folder with category structure
- [ ] Create `docs/README.md` master index
- [ ] Create `CLAUDE.md` in root (< 100 lines with lookup table)
- [ ] Keep only 5-15 essential files in root
- [ ] Add `.claudeignore` for PDFs/binaries
- [ ] Create `specs/` for feature specifications
- [ ] Set up `docs/reference/archives/` for historical docs

### Existing Projects (Migration)
See: [guides/documentation-migration.md](guides/documentation-migration.md) for step-by-step guide

---

## 🔗 Related Resources

### TE Code Best Practices
- **`.claude/BEST_PRACTICES.md`** - Engineering workflow guide
  - CLAUDE.md template (< 100 lines with lookup tables)
  - Context management (176K usable tokens)
  - TDD workflow (Research → Plan → Implement)
  - Team collaboration patterns (WORKER.md, specs/)

### Documentation Organization Guides
- **[guides/folder-naming.md](guides/folder-naming.md)** - Comprehensive folder naming rules and anti-patterns
- **[guides/master-index-creation.md](guides/master-index-creation.md)** - Step-by-step guide to creating perfect docs/README.md
- **[guides/documentation-migration.md](guides/documentation-migration.md)** - Migrate existing projects to this structure
- **[guides/pdf-handling.md](guides/pdf-handling.md)** - Handle PDFs in documentation-heavy repos
- **[guides/clean-root-guide.md](guides/clean-root-guide.md)** - Detailed root folder organization rules

### When to Use What
- **This guide** - Quick reference for organizing documentation structure
- **BEST_PRACTICES.md** - Engineering workflow and AI-assisted development
- **guides/** - Deep dives into specific organization topics
- Use **all three** for complete project setup

---

## 💡 Quick Tips

1. **Start with docs/README.md** - Master index is your source of truth
2. **Category folders first** - Create folders, then move files
3. **One file, one home** - No duplicates, single source of truth
4. **Archives are friends** - Don't delete history, archive it
5. **CLAUDE.md = AI GPS** - Lookup table helps AI navigate instantly
6. **PDFs = trouble** - Always convert to markdown first
7. **Clean root = professional** - 5-15 files shows you care

---

*This is a living template. Adapt folder names and priorities to your project's needs.*

**Version**: 2.0 (Refactored 2026-01-14)
**Based on**: TE Code ecosystem patterns, Geoffrey Huntley principles, real-world usage
