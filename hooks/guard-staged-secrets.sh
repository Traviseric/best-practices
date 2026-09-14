#!/usr/bin/env bash
# PreToolUse(Bash) guard: stops a STAGED file carrying a high-confidence live
# credential from being committed. POSIX twin of guard-staged-secrets.ps1.
#
# Why: a secret in git history is not fixable with a follow-up commit. It must be
# rotated across every consumer of that key, and it stays in history forever.
#
# Scope is deliberately narrow, so it is never the reason a legitimate commit fails:
#   - only `git commit` (not add/status/log/push/diff)
#   - only files STAGED for this commit, read from the index (`git show :path`)
#   - only PROVIDER-PREFIXED live-credential shapes; a bare high-entropy string is
#     NOT flagged, because that is where false positives live
#   - placeholder lines (your-, example, REPLACE_ME, xxxx, <...>) are skipped
#   - .env.example / .env.sample / *.template are skipped by name
#   - test/fixture/mock/snapshot paths are skipped: their purpose is to contain
#     secret-shaped strings. A guard that cries wolf gets disabled.
#
# KNOWN LIMIT: binary documents (PDF, DOCX, images) are skipped. A password inside
# a tracked PDF is on the human, not on this scanner.
#
# Escape hatches: the literal token ALLOW-SECRET-SCAN in a file skips that file;
# the same token in the commit command skips the whole check for that commit.
#
# FAILS OPEN: no git, not a repo, missing tools, or any error allows the command.
#
# Wiring (Claude Code, .claude/settings.json):
#   { "matcher": "Bash", "hooks": [ { "type": "command", "if": "Bash(git *)",
#     "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/guard-staged-secrets.sh\"",
#     "timeout": 30 } ] }
#
# Requires: bash, git, grep with -E, and a JSON reader (python3, node, or jq).

allow() { printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'; exit 0; }
deny() {
  # $1 = reason text; escape for JSON by hand (no jq dependency on the deny path)
  local r; r=$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\\n", $0}')
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$r"
  exit 0
}
trap 'allow' ERR

# has / has_i: regex test that reads ALL of its input. Never use `grep -q`, `grep -m1`,
# or `head -n1` on a pipe in this script: on MSYS/Git Bash an early-exiting reader can
# leave the writer hung on a broken pipe, and the whole hook stalls until timeout.
has()   { printf '%s\n' "$1" | grep -E  "$2" >/dev/null 2>&1; }
has_i() { printf '%s\n' "$1" | grep -Ei "$2" >/dev/null 2>&1; }
first_line() { printf '%s\n' "$1" | sed -n '1p'; }

raw=$(cat) || allow
[ -z "$raw" ] && allow

# Pull .tool_input.command and .cwd out of the payload with whatever JSON reader exists.
read_json() {
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$raw" | python3 -c 'import json,sys; d=json.load(sys.stdin); print((d.get("tool_input") or {}).get("command") or ""); print(d.get("cwd") or "")' 2>/dev/null
  elif command -v node >/dev/null 2>&1; then
    printf '%s' "$raw" | node -e 'let s="";process.stdin.on("data",c=>s+=c).on("end",()=>{const d=JSON.parse(s);console.log((d.tool_input||{}).command||"");console.log(d.cwd||"")})' 2>/dev/null
  elif command -v jq >/dev/null 2>&1; then
    printf '%s' "$raw" | jq -r '(.tool_input.command // ""), (.cwd // "")' 2>/dev/null
  else
    return 1
  fi
}
parsed=$(read_json) || allow
cmd=$(printf '%s\n' "$parsed" | sed -n '1p')
cwd=$(printf '%s\n' "$parsed" | sed -n '2p')
[ -z "$cmd" ] && allow

# Only `git commit` is in scope.
has_i "$cmd" '\bgit\b[^&|;]*\bcommit\b' || allow
# Explicit one-commit bypass.
has "$cmd" 'ALLOW-SECRET-SCAN' && allow

[ -n "$cwd" ] && [ -d "$cwd" ] || cwd=$(pwd)

# `cd x && git commit ...`: honour the last cd target that resolves.
cdtarget=$(printf '%s' "$cmd" | grep -Eo '(^|[;&|][[:space:]]*)cd[[:space:]]+("[^"]+"|'"'"'[^'"'"']+'"'"'|[^[:space:];&|]+)' | tail -n1 | sed -E 's/^.*cd[[:space:]]+//; s/^["'"'"']//; s/["'"'"']$//')
if [ -n "$cdtarget" ]; then
  case "$cdtarget" in
    /*) [ -d "$cdtarget" ] && cwd="$cdtarget" ;;
    *)  [ -d "$cwd/$cdtarget" ] && cwd="$cwd/$cdtarget" ;;
  esac
fi

# An explicit `-C <path>` wins over cwd.
ctarget=$(printf '%s' "$cmd" | grep -Eo '\bgit\b[[:space:]]+([^[:space:]]+[[:space:]]+)*?-C[[:space:]]+("[^"]+"|'"'"'[^'"'"']+'"'"'|[^[:space:]]+)' | sed -n '1p' | sed -E 's/^.*-C[[:space:]]+//; s/^["'"'"']//; s/["'"'"']$//')
if [ -n "$ctarget" ]; then
  case "$ctarget" in
    /*) [ -d "$ctarget" ] && cwd="$ctarget" ;;
    *)  [ -d "$cwd/$ctarget" ] && cwd="$cwd/$ctarget" ;;
  esac
fi

command -v git >/dev/null 2>&1 || allow
names=$(git -C "$cwd" diff --cached --name-only --diff-filter=ACM 2>/dev/null) || allow
[ -z "$names" ] && allow

# Parallel arrays: kind[i] names the credential, rx[i] is its regex. Every one is
# provider-anchored. Add your own internal prefix as a new pair, e.g.
#   KIND+=('Internal service key'); RX+=('\bmyco_svc_[a-z0-9-]+_[0-9a-f]{32}\b')
KIND=(); RX=()
KIND+=('Stripe live key');     RX+=('\b[srk]k_live_[A-Za-z0-9]{16,}')
KIND+=('Anthropic API key');   RX+=('\bsk-ant-[A-Za-z0-9_-]{24,}')
KIND+=('OpenAI project key');  RX+=('\bsk-proj-[A-Za-z0-9_-]{24,}')
KIND+=('OpenAI legacy key');   RX+=('\bsk-[A-Za-z0-9]{40,}')
KIND+=('GitHub token');        RX+=('\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}|\bgithub_pat_[A-Za-z0-9_]{30,}')
KIND+=('AWS access key id');   RX+=('\bAKIA[0-9A-Z]{16}\b')
KIND+=('Slack token');         RX+=('\bxox[baprs]-[A-Za-z0-9-]{10,}')
KIND+=('Google API key');      RX+=('\bAIza[0-9A-Za-z_-]{35}\b')
KIND+=('Private key block');   RX+=('-----BEGIN (RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----')
KIND+=('Password in DB URL');  RX+=('\b(postgres(ql)?|mysql|mongodb(\+srv)?|redis|amqp)://[^:/[:space:]]+:[^@[:space:]'"'"'"]{6,}@')

PLACEHOLDER='your[-_]|example|placeholder|replace[-_]?me|<[^>]+>|\bxxxx|\bdummy|\bfake|redacted|\*{4,}|\.invalid\b|1234567890|abcdefgh|qwerty|0{12,}'
EXEMPT_PATH='(^|/)(tests?|__tests__|testing|spec|fixtures?|mocks?|captures?|snapshots?)/|\.(test|spec|fixture|mock)\.[a-z]+$'

# FAST PATH: one python3 process does the whole scan. Git Bash on Windows stalls
# intermittently when a script spawns dozens of short pipelines, so the per-file,
# per-pattern grep loop below is only the fallback for machines without python3.
# The Python pattern table mirrors the bash one above; keep them in step.
PYSCAN='
import re, subprocess, sys
cwd = sys.argv[1]
def git(*a):
    return subprocess.run(["git", "-C", cwd, *a], capture_output=True, text=True, errors="replace").stdout
P = [
 ("Stripe live key",     r"\b[srk]k_live_[A-Za-z0-9]{16,}"),
 ("Anthropic API key",   r"\bsk-ant-[A-Za-z0-9_\-]{24,}"),
 ("OpenAI project key",  r"\bsk-proj-[A-Za-z0-9_\-]{24,}"),
 ("OpenAI legacy key",   r"\bsk-[A-Za-z0-9]{40,}"),
 ("GitHub token",        r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}|\bgithub_pat_[A-Za-z0-9_]{30,}"),
 ("AWS access key id",   r"\bAKIA[0-9A-Z]{16}\b"),
 ("Slack token",         r"\bxox[baprs]-[A-Za-z0-9\-]{10,}"),
 ("Google API key",      r"\bAIza[0-9A-Za-z_\-]{35}\b"),
 ("Private key block",   r"-----BEGIN (?:RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----"),
 ("Password in DB URL",  r"\b(?:postgres(?:ql)?|mysql|mongodb(?:\+srv)?|redis|amqp)://[^:/\s]+:[^@\s\x27\x22]{6,}@"),
]
PLACEHOLDER = re.compile(r"your[-_]|example|placeholder|replace[-_]?me|<[^>]+>|\bxxxx|\bdummy|\bfake|redacted|\*{4,}|\.invalid\b|1234567890|abcdefgh|qwerty|0{12,}", re.I)
EXEMPT = re.compile(r"(^|/)(tests?|__tests__|testing|spec|fixtures?|mocks?|captures?|snapshots?)/|\.(test|spec|fixture|mock)\.[a-z]+$", re.I)
TEMPL = re.compile(r"(^|/)\.env\.(example|sample|template)$|\.(template|example|sample)$", re.I)
names = [n for n in git("diff", "--cached", "--name-only", "--diff-filter=ACM").splitlines() if n]
hits = []
for n in names:
    if len(hits) >= 20: break
    if TEMPL.search(n) or EXEMPT.search(n): continue
    if git("diff", "--cached", "--numstat", "--", n).startswith("-"): continue
    text = git("show", ":" + n)
    if not text or len(text) > 4000000 or "\x00" in text or "ALLOW-SECRET-SCAN" in text: continue
    for kind, rx in P:
        m = re.search(rx, text)
        if not m: continue
        ls = text.rfind("\n", 0, m.start()) + 1
        le = text.find("\n", m.start()); le = len(text) if le < 0 else le
        if PLACEHOLDER.search(text[ls:le]): continue
        hits.append("  - %s  -  %s" % (n, kind)); break
print("\n".join(hits))
'
if command -v python3 >/dev/null 2>&1; then
  pyout=$(python3 -c "$PYSCAN" "$cwd" 2>/dev/null) || allow
  count=0; hits=""
  if [ -n "$pyout" ]; then
    count=$(printf '%s\n' "$pyout" | grep -c .)
    hits="$pyout
"
  fi
  if [ "$count" -gt 0 ]; then
    deny "BLOCKED: $count staged file(s) appear to contain a live credential.

$hits
A secret in git history is not fixable with a follow-up commit. It must be ROTATED.
Do this instead:
  1. Unstage the file:            git restore --staged <file>
  2. Move the real value to your secret store (a gitignored .env, or the platform's
     own store: Vercel/Railway env, AWS Secrets Manager, 1Password).
  3. Reference it by NAME in code and docs, then re-stage and commit.
If this is genuinely not a secret (a fixture, a doc showing the SHAPE of a key), add the
token ALLOW-SECRET-SCAN to the file, or use an obvious placeholder form."
  fi
  allow
fi

# FALLBACK PATH (no python3): iterate names with a newline-only IFS and globbing off.
hits=""
count=0
OLDIFS=$IFS; IFS=$'\n'; set -f
for n in $names; do
  IFS=$OLDIFS
  [ -z "$n" ] && { IFS=$'\n'; continue; }
  [ "$count" -ge 20 ] && break
  if has_i "$n" '(^|/)\.env\.(example|sample|template)$|\.(template|example|sample)$' || has_i "$n" "$EXEMPT_PATH"; then
    IFS=$'\n'; continue
  fi

  # binary (git reports "-\t-" in numstat): skip, see KNOWN LIMIT above
  numstat=$(git -C "$cwd" diff --cached --numstat -- "$n" 2>/dev/null)
  numstat=$(first_line "$numstat")
  case "$numstat" in -*) IFS=$'\n'; continue ;; esac
  blob=$(git -C "$cwd" show ":$n" 2>/dev/null) || { IFS=$'\n'; continue; }
  if [ -z "$blob" ] || has "$blob" 'ALLOW-SECRET-SCAN'; then IFS=$'\n'; continue; fi

  i=0
  while [ "$i" -lt "${#RX[@]}" ]; do
    rx=${RX[$i]}; kind=${KIND[$i]}; i=$((i + 1))
    line=$(printf '%s\n' "$blob" | grep -E -- "$rx" 2>/dev/null | sed -n '1p')
    [ -z "$line" ] && continue
    has_i "$line" "$PLACEHOLDER" && continue
    hits="${hits}  - ${n}  -  ${kind}
"
    count=$((count + 1))
    break
  done
  IFS=$'\n'
done
IFS=$OLDIFS; set +f

if [ "$count" -gt 0 ]; then
  deny "BLOCKED: $count staged file(s) appear to contain a live credential.

$hits
A secret in git history is not fixable with a follow-up commit. It must be ROTATED.
Do this instead:
  1. Unstage the file:            git restore --staged <file>
  2. Move the real value to your secret store (a gitignored .env, or the platform's
     own store: Vercel/Railway env, AWS Secrets Manager, 1Password).
  3. Reference it by NAME in code and docs, then re-stage and commit.
If this is genuinely not a secret (a fixture, a doc showing the SHAPE of a key), add the
token ALLOW-SECRET-SCAN to the file, or use an obvious placeholder form."
fi

allow
