# AGENTS.md

If you are an AI coding agent and a person just pointed you at this repo, this file is for you. Read it, then do the steps. It takes about two minutes.

## What this is

A kit of skills, guard hooks, templates, and short docs that change how you behave on the person's projects: you name which rung of "done" you have proven, you refuse to commit a live secret, you close a session with a handoff, and you read their homepage the way a stranger does. The map of everything is in `README.md`; the pin for working on this repo itself is `CLAUDE.md`.

## Set it up for the person (do all four)

1. **Install the skills.** Preferred: `/plugin marketplace add Traviseric/best-practices` then `/plugin install best-practices@traviseric`. If the plugin path is not available on this version, run `./install.sh` (macOS, Linux, Git Bash) or `.\install.ps1` (PowerShell). Confirm with `./install.sh --check` or `.\install.ps1 -Check`, which exits 0 when the installed skills match the source.
2. **Offer to wire the hooks into their project**, not this repo, and do it only with their yes: copy `hooks/` into `<their-project>/.claude/hooks/`, then MERGE the three hook entries from `templates/settings.json.template` into their existing `<their-project>/.claude/settings.json` (never overwrite a settings file; show them the diff), and set the build command for their stack (see `hooks/build-gate.example.json`). On Windows without python3, use the `.ps1` forms. Details and the recorded tests are in `docs/HOOKS.md`.
3. **Give their project a `CLAUDE.md`** from `templates/CLAUDE.md.template` if it has none: a lookup table, the commands, the current focus. Keep it under 100 lines. Add a `.claudeignore` from the template.
4. **Show them `docs/ROOM_AND_GROUND.md`** if they write anything that has to move a person: a homepage, a pitch, a report, an email. It is a writing method they can adopt by pasting it into their `CLAUDE.md`. Adopting it is their choice, not yours.

## Then offer these, in order

- `skills/definition-of-done` on whatever they last called finished. Say which rung is proven and what would prove the next one.
- `skills/clarity-gate` on their homepage or README, if they want it. It reads the page as a stranger would and says whether it lands in five seconds. It fetches nothing they did not point you at.
- `skills/session-closeout` at the end of the session. Write the handoff; commit only what you own, by explicit path.

## Rules while you are here

- Read `docs/SEVEN_CHEAP_LIES.md` before you say the word "verified". A check you did not run is not a check.
- Skills reference nothing outside this repo. If a skill seems to point at something that does not exist here, it is a bug: open an issue.
- Hooks fail open. If a guard cannot run, the commit proceeds and you say so.
- Do not edit this repo on the person's behalf unless they asked. Your job is their project.

## Verify

```
./install.sh --check            # or .\install.ps1 -Check
python skills/verification-gate/scripts/gate_runner.py --self-test
```

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/SEVEN_CHEAP_LIES.md`.
