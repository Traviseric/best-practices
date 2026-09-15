#!/usr/bin/env bash
# PreToolUse(Bash) guard: stops a file with unresolved merge-conflict markers from
# being committed. POSIX twin of guard-conflict-markers.ps1.
#
# Why: a conflict marker is never intentional content. A botched `git stash pop` can
# leave "<<<<<<< Updated upstream" in a JSON file a script reads, and nothing notices
# until the script fails hours later. Catching it at commit costs milliseconds.
#
# Scope: only `git commit`; only STAGED files read from the index; only the full
# triad (<<<<<<< AND ======= AND >>>>>>>) at line start.
# Escape hatch: a file containing the literal token ALLOW-CONFLICT-MARKERS is skipped.
# FAILS OPEN on any error.
#
# Wiring (Claude Code, .claude/settings.json):
#   { "matcher": "Bash", "hooks": [ { "type": "command", "if": "Bash(git commit *)",
#     "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/guard-conflict-markers.sh\"",
#     "timeout": 30 } ] }
#
# Requires: bash, git, grep -E, and a JSON reader (python3, node, or jq).

allow() { printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'; exit 0; }
deny() {
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

has_i "$cmd" '\bgit\b[^&|;]*\bcommit\b' || allow

[ -n "$cwd" ] && [ -d "$cwd" ] || cwd=$(pwd)

cdtarget=$(printf '%s' "$cmd" | grep -Eo '(^|[;&|][[:space:]]*)cd[[:space:]]+("[^"]+"|'"'"'[^'"'"']+'"'"'|[^[:space:];&|]+)' | tail -n1 | sed -E 's/^.*cd[[:space:]]+//; s/^["'"'"']//; s/["'"'"']$//')
if [ -n "$cdtarget" ]; then
  case "$cdtarget" in
    /*) [ -d "$cdtarget" ] && cwd="$cdtarget" ;;
    *)  [ -d "$cwd/$cdtarget" ] && cwd="$cwd/$cdtarget" ;;
  esac
fi

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

# FAST PATH: one python3 process does the whole scan. Git Bash on Windows stalls
# intermittently when a script spawns many short pipelines; the bash loop below is
# the fallback for machines without python3.
PYSCAN='
import re, subprocess, sys
cwd = sys.argv[1]
def git(*a):
    return subprocess.run(["git", "-C", cwd, *a], capture_output=True, text=True, errors="replace").stdout
names = [n for n in git("diff", "--cached", "--name-only", "--diff-filter=ACM").splitlines() if n]
bad = []
for n in names:
    if len(bad) >= 20: break
    if git("diff", "--cached", "--numstat", "--", n).startswith("-"): continue
    t = git("show", ":" + n)
    if not t or len(t) > 4000000 or "\x00" in t or "ALLOW-CONFLICT-MARKERS" in t: continue
    if re.search(r"^<<<<<<< ", t, re.M) and re.search(r"^=======\s*$", t, re.M) and re.search(r"^>>>>>>> ", t, re.M):
        bad.append("  - " + n)
print("\n".join(bad))
'
if command -v python3 >/dev/null 2>&1; then
  pyout=$(python3 -c "$PYSCAN" "$cwd" 2>/dev/null) || allow
  count=0; bad=""
  if [ -n "$pyout" ]; then
    count=$(printf '%s\n' "$pyout" | grep -c .)
    bad="$pyout
"
  fi
  if [ "$count" -gt 0 ]; then
    deny "BLOCKED: $count staged file(s) contain unresolved merge-conflict markers.

$bad
These files carry <<<<<<< / ======= / >>>>>>> at line start, so whatever reads them
next will fail to parse. Resolve the conflict, restage, and commit again.

If a file legitimately shows a conflict verbatim (a doc, a fixture), put the token
ALLOW-CONFLICT-MARKERS in it and this guard will skip it."
  fi
  allow
fi

# FALLBACK PATH (no python3)
bad=""
count=0
while IFS= read -r n; do
  [ -z "$n" ] && continue
  [ "$count" -ge 20 ] && break
  numstat=$(git -C "$cwd" diff --cached --numstat -- "$n" 2>/dev/null)
  numstat=$(first_line "$numstat")
  case "$numstat" in -*) continue ;; esac      # binary: markers are meaningless
  blob=$(git -C "$cwd" show ":$n" 2>/dev/null) || continue
  [ -z "$blob" ] && continue
  has "$blob" 'ALLOW-CONFLICT-MARKERS' && continue
  # Require the FULL triad at line start.
  has "$blob" '^<<<<<<< ' || continue
  has "$blob" '^=======[[:space:]]*$' || continue
  has "$blob" '^>>>>>>> ' || continue
  bad="${bad}  - ${n}
"
  count=$((count + 1))
done <<EOF
$names
EOF

if [ "$count" -gt 0 ]; then
  deny "BLOCKED: $count staged file(s) contain unresolved merge-conflict markers.

$bad
These files carry <<<<<<< / ======= / >>>>>>> at line start, so whatever reads them
next will fail to parse. Resolve the conflict, restage, and commit again.

If a file legitimately shows a conflict verbatim (a doc, a fixture), put the token
ALLOW-CONFLICT-MARKERS in it and this guard will skip it."
fi

allow
