# Hedge audit: the pattern catalog and the decision tree

Regexes are leads, not verdicts. Read every hit before you classify it.

## Phase 1: documents (markdown, text, yaml, json, html, prompts, config)

| # | Regex | Category |
|---|---|---|
| D1 | `boundary\|consent` | Boundary and consent statements |
| D2 | `(?i)defensive` | Defensive-only framing |
| D3 | `not a (guide\|how-to\|recipe\|playbook\|punch-list)` | Disclaimer qualifiers |
| D4 | `the line (we do )?not cross` | Hard refusal |
| D5 | `(?i)won't (build\|write\|improve\|create)` | Refusal statements |
| D6 | `study to defend\|only to defend` | Defensive-only study |
| D7 | `static analysis only\|never installed or run` | Cover-yourself disclaimers |
| D8 | `intentionally (absent\|inert\|excluded)` | Inert markers |
| D9 | `not produced.*(and\|-).*(won't\|wont) be` | Permanent refusal |
| D10 | `no improvement to\|does not improve` | Improvement refusal |
| D11 | `scope.*restrict\|what is intentionally NOT\|scoped to.*does not provide` | Scope restriction |
| D12 | `not a guide\|not an operational\|not a punch.?list` | Guide refusal |

Extended document patterns:

| Regex | What it catches |
|---|---|
| `only scan yourself\|personal (audit\|privacy) only` | Self-restriction |
| `personal privacy protection\|white-hat testing` | Root identity framing |
| `shadow.?only\|pending_approval\|enqueueSequence:\s*false` | Human-approval gates (often legitimate) |
| `written authorization\|must have written` | Consent requirements (often legitimate) |
| `not a consumer reporting agency\|fair credit reporting` | Regulatory boilerplate (usually legitimate) |
| `for defensive security purposes` | Repo identity framing |
| `BLOCKED_\w+\|blockedCategories\|blockedScanners` | Code-level gates |
| `process\.exit\(1\).*refused\|Error:.*(refused\|rejected)` | Hard exits |
| `stub\|placeholder\|not implemented\|not built\|spec\.?only` | Stub markers |
| `never (imply\|invent\|promise\|argue\|enable\|auto-post)\|no (hype\|buzzwords\|emojis\|links)` | Prompt-level constraints |

## Phase 2: code

| # | Pattern | Target |
|---|---|---|
| C1 | `ran\s*=\s*False\|ran:\s*false\|stub\|no-op\|noop\|inert.*engine\|placeholder.*implement` | Stub implementations |
| C2 | `intentionally absent\|deliberately minimal\|intentionally inert` in code files | Safety preamble blocks |
| C3 | Auth-only imports with no capability imports | Defensive-only isolation |
| C4 | Permission or manifest self-censorship | Omitted capabilities |
| C5 | `expect.*\.toBe\(false\)\|assert.*False\|assert.*not.*work` in tests | Tests that enforce inertness |
| C6 | Multi-line "intentionally absent" or "defensive" comment blocks | Safety headers |
| C7 | `DELIBERATELY MINIMAL\|BENIGN\|DEFENSIVE` in config or comments | Manifest censorship |
| C8 | Scorecard rows marked NONE for a capability the product sells | Capability labeling |
| C9 | Hardcoded real third-party URLs in source | Fingerprint exposure |
| C10 | API keys, private keys, JWTs, certificates in source | Secret exposure |

## Phase 3: runtime behavior (the Tier 3 hunt)

| # | Pattern | Target |
|---|---|---|
| R1 | Fetch-and-discard: `_data\|_response\|_html\|_body\|_params` underscore params | A call whose result is thrown away |
| R2 | `simulated\|would (run\|create\|send) here\|success: true.*not.*implement` | Fabricated success |
| R3 | `MAX_\w+\s*=\s*[0-9]{1,3}` beside `safety\|never exceed\|hard cap\|conservative` | Artificial caps |
| R4 | `if \(!process\.env\.\w+\) return (null\|\{)` with nothing logged | Silent key-gated skips |

## Decision tree

```
Is it hedge-shaped?
  no  -> false positive: note and skip
  yes -> Does it enforce the system's own threat model, the law, or product doctrine?
           yes -> LEGITIMATE GATE: document, do not strip
           no  -> Does it report success while doing no work?
                    yes -> TIER 3: fix immediately
                    no  -> Does it label the gap where the consumer can see it?
                             yes -> TIER 2: track in the roadmap
                             no  -> TIER 1: surface for the owner's decision
```

## What a distribution usually looks like

| Repo type | Tier 1 | Tier 2 | Tier 3 | Gates |
|---|---|---|---|---|
| Security or recon tooling | High | Low | Uncommon | Moderate |
| Conversation or compliance | Zero | Moderate | Low | High |
| Telemetry or analytics | Zero | Low | Zero | Moderate |
| Marketing automation | Zero | Moderate | Low | High |
| Research or intelligence pipelines | Zero | High | Zero | Low |

A repo whose Tier 3 count is not zero has a lie on a live path. That is the headline.
