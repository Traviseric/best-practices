# MCP Optimization

Five rules, each stated as the thing an agent would have done wrong, each with the failure that earned it. MCP (Model Context Protocol) servers are the largest variable cost in an agent's context window, and the cost is invisible unless you go looking for it.

**Take the incidents at zero.** They come from a private portfolio of agent-run systems between mid-2025 and September 2026, so you cannot check them. The one thing you can check takes ten seconds: run `/context` in your own session and read the `mcp__` line. That number is the argument.

---

## 1. You would have installed the MCP because it existed

**The rule.** CLI beats MCP whenever a CLI exists. The agent already knows `gh`, `aws`, `git`, `kubectl`, `curl`. An MCP server teaches it the same thing again, and charges rent every session.

**The incident.** A single cloud-function MCP server measured at **over 40,000 tokens** of tool definitions, because it exposed every function in the account as its own tool. With that server, a logs server, a code-host server, and a browser server all enabled, roughly **57,000 tokens (28% of a 200K window)** were gone before anyone asked a question. None of them did anything the corresponding CLI could not do.

**The mechanism.** A written default: no MCP server without a specific justification naming what the CLI cannot do. The burden of proof sits on the server, not on the CLI.

**Apply it.** Before installing any MCP server, write one sentence naming the thing the CLI cannot do. If you cannot write it, use the CLI.

## 2. You would never have looked at the bill

**The rule.** MCP overhead is paid every session, forever, silently. It never appears as an error. It shows up as an agent that gets worse sooner, and you will attribute that to the model.

**The incident.** The overhead above was not discovered by anyone noticing slowness. It was found by running a context audit for an unrelated reason. Until then every session on that machine had been starting a quarter of the way through its own budget, and the sessions that went badly were read as bad luck.

**The mechanism.** A context audit belongs in setup, not in debugging. `/context` in Claude Code prints the breakdown; anything on the `mcp__` line above a few thousand tokens is a standing tax that needs a reason.

**Apply it.** Run `/context` now. Write the `mcp__` number down. That is your recurring bill.

| Server class | Observed overhead | Cheaper path |
|---|---|---|
| Cloud function server exposing every function | 40,000+ tokens | The provider's CLI |
| Cloud logs or metrics server | around 8,000 tokens | The provider's CLI |
| Browser control server (around 17 tools) | around 5,000 tokens | Disable by default, enable per task |
| Code host server (20+ tools) | around 4,000 tokens | `gh` or the equivalent CLI |
| Small core server | around 1,000 tokens | Usually fine |

Numbers are one portfolio's measurements and will differ for you. Measure your own; the ranking is what transfers.

## 3. You would have kept the browser server loaded for the two days a month you use it

**The rule.** Load on demand. A server that earns its cost during one task does not earn it during the other forty.

**The incident.** A browser-control server sat enabled in the default profile for months, charging around 5,000 tokens per session, for a capability used a couple of times a month. When browser work did come up, the private system's own driver, invoked as an ordinary command, did the job with zero standing cost. The server was disabled by default and nothing was lost.

**The mechanism.** Two profiles and a shell alias: a lean default with an empty server list, and a task profile that switches the heavy servers on for the session that needs them. Project-scoped configuration (`.mcp.json` in a repo) keeps a project's server out of every other project's context.

**Apply it.** Set your default configuration to an empty server list today. Add servers back one at a time, each with the sentence from rule 1.

## 4. You would have let one server's tool list grow without noticing

**The rule.** An MCP server's cost is proportional to how many tools it exposes, and that number changes when the account or repository behind it changes. A server that was cheap when you installed it is not necessarily cheap now.

**The incident.** The 40,000-token measurement was not the server's design cost. It was the cost after the account filled up with functions, each of which the server dutifully exposed as a tool. Nobody re-measured between installing it and finding it.

**The mechanism.** Re-run the context audit whenever the environment behind a server changes materially, and whenever an agent starts degrading earlier than it used to.

**Apply it.** Add the context audit to whatever checklist you already run monthly.

## 5. You would have written a custom MCP server for something the model can already do

**The rule.** An MCP server is plumbing. If the capability you want is reasoning over information the agent can already read, the deliverable is a document, not a server.

**The incident.** The wider version of this failure cost weeks in the same portfolio: a large analysis module with custom scoring and pattern matching was replaced by a structured markdown document that told the model how to do the analysis, with the same output. The MCP version is the same shape, and it also charges context in every session that is not doing the analysis.

**The mechanism.** One question in writing before any server is built: if the agent had a well-written document explaining exactly what to do, and a CLI to fetch the data, would a server add anything? See `docs/ENGINEERING_PRINCIPLES.md` rule 1.

**Apply it.** Build the document first. Build the server only if the document fails.

---

## Where the configuration lives

| Tool | Path |
|---|---|
| Claude Code, user scope | `~/.claude.json` |
| Claude Code, project scope | `.mcp.json` in the repo root |
| Claude Desktop, Windows | `%APPDATA%/Claude/claude_desktop_config.json` |
| Claude Desktop, macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |

A minimal default:

```json
{
  "mcpServers": {}
}
```

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/HOOKS.md`.
