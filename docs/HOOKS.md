# Hooks: the three commit guards

Three `PreToolUse` hooks that fire when the agent runs `git commit`. Each one costs
milliseconds, denies only an objectively broken state, and fails open. Together they
close the three ways a "green" session most often lands something broken.

| Hook | Denies a commit when... | Escape hatch |
|---|---|---|
| Build gate | your stack's compile/collect command fails | none; fix the build |
| `guard-staged-secrets` | a STAGED file carries a provider-prefixed live credential | token `ALLOW-SECRET-SCAN` in the file or the commit command |
| `guard-conflict-markers` | a STAGED file carries the full `<<<<<<<` / `=======` / `>>>>>>>` triad at line start | token `ALLOW-CONFLICT-MARKERS` in the file |

## Install (two minutes)

1. Copy `hooks/` from this repo into your project at `.claude/hooks/`.
2. If you have no `.claude/settings.json`, copy `templates/settings.json.template` to it. If you already have one, MERGE the three hook entries into your existing `hooks.PreToolUse` array. Never overwrite a settings file you did not write; it carries permissions and other hooks you will not get back.
3. Replace `<build-command>` with your stack's cheapest check (see `hooks/build-gate.example.json`).
4. On Windows with PowerShell as the hook shell, swap the `.sh` lines for the `.ps1` lines shown in the template's comment.
5. Prove it once: stage a file containing the Stripe live prefix followed by 24 random mixed-case alphanumerics, and try to commit through the agent. You should see the deny reason, not a commit. If it allows, read the fixture warning under Recorded tests before you conclude the guard is broken.

Both guards ship as a `.ps1` and a `.sh` with identical behavior. The `.sh` needs `bash`, `git`, and one JSON reader (`python3`, `node`, or `jq`). With `python3` present the whole scan runs in one process, which is the path to use on Git Bash for Windows: that shell stalls intermittently when a script spawns many short pipelines, and the pure-bash fallback loop does exactly that. On Windows prefer the `.ps1` files.

## What each guard actually reads

Only the index. `git diff --cached --name-only` lists what this commit would land, and `git show :path` reads the staged blob. Dirty files in the working tree that are not staged are never the reason a commit is blocked, so another session's half-finished work beside yours cannot trip the guard.

Only `git commit`. `add`, `status`, `log`, `push`, and `diff` pass untouched. A compound `cd repo && git commit` is followed to the right repo, and an explicit `git -C path commit` wins over the session's cwd.

## The secrets guard: what counts and what does not

It flags provider-anchored shapes only: Stripe `sk_live_`/`rk_live_`, Anthropic `sk-ant-`, OpenAI `sk-proj-` and long `sk-`, GitHub `ghp_`/`github_pat_`, AWS `AKIA`, Slack `xox?-`, Google `AIza`, `-----BEGIN ... PRIVATE KEY-----`, and a password inside a `postgres://` style URL. Add your own internal prefix at the top of the script if you issue service keys.

It does not flag a bare high-entropy string. That is where false positives live, and a guard that cries wolf gets disabled, after which it covers nothing.

It skips, on purpose:

- lines that read as placeholders (`your-`, `example`, `REPLACE_ME`, `<...>`, `xxxx`, `1234567890`, long runs of zeros);
- `.env.example`, `.env.sample`, and `*.template` by name;
- `test/`, `__tests__/`, `spec/`, `fixtures/`, `mocks/`, `snapshots/` paths and `*.test.*` / `*.spec.*` files, because their purpose is to contain secret-shaped strings.

The accepted trade: a real key pasted into a test file is not caught. Read your diff before you stage it.

## The limit you must not forget

A guard cannot read a binary document. PDF, DOCX, images, and archives are compressed, so a plaintext password inside a tracked PDF passes both guards. A pass here is not proof a document is clean. Before staging any document, open it and look. This case has already happened in production once; the guard was written after the human caught it.

## Why fail open

Every guard allows the command on any error: no git, not a repo, an unreadable blob, a missing JSON reader, a timeout. A hygiene guard must never be the reason real work cannot proceed. If it were to fail closed, the first flaky run would get it deleted, and then it would cover nothing. The cost of a missed catch is a rotation or an afternoon; the cost of a guard that blocks legitimate work is the guard itself.

## When a guard fires

The deny reason tells you which file and which kind. For a secret:

```
git restore --staged <file>
# move the value to a gitignored .env or the platform's secret store
# reference it by NAME, restage, commit
```

A secret that already reached history is not fixed by a follow-up commit. Rotate it.

For a conflict marker: resolve the conflict, restage, commit again. If the file is a doc or fixture that legitimately shows a conflict, put `ALLOW-CONFLICT-MARKERS` in it.

## Adding a fourth guard

Same shape: read stdin JSON, scope to the command you care about, read only the index, deny with a reason someone can act on in under a minute, fail open on everything else. Measure the false-positive rate on your own repos before wiring it. A guard qualifies when it triggers rarely, checks cheaply, fails open, denies only objectively broken states, and has a measured false-positive rate of zero.

## Recorded tests

Run 2026-09-14 against `hooks/guard-staged-secrets.sh` and `hooks/guard-conflict-markers.sh` in a throwaway git repository, feeding each script the hook payload on stdin. Reproduce them yourself: `git init` a scratch repo, stage the file described, and pipe `{"tool_input":{"command":"git commit -m x"},"cwd":"<repo>"}` into the script.

To keep this file free of key-shaped strings, the cases below describe the shape instead of printing it. Build each one by concatenating the prefix with random alphanumerics of the stated length.

**Build your fixture carefully, or you will misread a correct allow as a broken guard.** The placeholder exemption skips any line containing a sequential alphabet run (`abcdefgh`, case-insensitively), a long run of zeros, `1234567890`, `qwerty`, or the words fake, dummy, example, placeholder, or redacted. While recording these tests the author twice wrote a fixture key containing `AbCdEfGh`, watched both guards allow it, and briefly concluded the PowerShell twin was broken. It was not. Use genuinely random characters and read the exemption list in the script before filing a bug.

| Case | Staged content | Expected | Result |
|---|---|---|---|
| Stripe live key | a JS line assigning the Stripe live prefix plus 24 mixed-case alphanumerics | deny | **deny**, named the file and "Stripe live key" |
| Anthropic key | an env line assigning the Anthropic key prefix plus 45 mixed-case alphanumerics | deny | **deny**, named the file and "Anthropic API key" |
| Both staged together | the two files above | deny, both listed | **deny**, "2 staged file(s)", both named |
| Obvious placeholder | the Stripe live prefix followed by 22 zeros and two letters | allow | **allow** (placeholder forms are exempt by design) |
| Clean stage | a text file with no key shape | allow | **allow** |
| Conflict markers | a file with `<<<<<<<` / `=======` / `>>>>>>>` at line start | deny | **deny**, named the file |
| Non-commit command | payload command is `git status` | allow | **allow** (only `git commit` is in scope) |
| Malformed payload | `not json` on stdin | allow (fail open) | **allow** |

One more result, unplanned and worth having: the first attempt to publish this table was **rejected by GitHub push protection**, because a table of realistic test keys is indistinguishable from a leak. That is the correct behavior from a second, independent guard, and it is why the cases above describe shapes rather than print them. Two lessons: write your fixtures so they cannot be mistaken for the real thing, and do not treat your own guard as the only one in the chain.

The PowerShell twins were run the same way on 2026-09-15, against the same throwaway repository:

| Case | Expected | Result |
|---|---|---|
| Stripe live key plus a private key block, both staged | deny, both listed | **deny**, "2 staged file(s)", named each file and its kind |
| Conflict-marker file staged | deny | **deny**, named the file |
| Malformed payload on stdin | allow (fail open) | **allow** |
| Fixture key containing a sequential alphabet run | allow (placeholder exemption) | **allow**, matching the bash guard exactly |
 The bash scripts do the whole scan in one `python3` process when python3 exists; without it they fall back to a shell loop that has stalled intermittently on Git Bash, so on Windows without python3 prefer the `.ps1` forms.

Note on `install.sh --check`: it compares the copies in `~/.claude/skills` with this repo. If another system already installs skills with the same names there (the author's own machines do), the check reports drift that is not yours. Test against a throwaway home (`HOME=/tmp/x ./install.sh`) before reading a drift report as a bug.

---

Provenance: ported from a private operating system on 2026-09-14; the update path is this repository at github.com/Traviseric/best-practices.

Next: `docs/SEVEN_CHEAP_LIES.md`.
