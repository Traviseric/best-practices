#!/usr/bin/env bash
# Install the best-practices skills into ~/.claude/skills (and ~/.codex/skills if present).
#
# Preferred path is the Claude Code plugin (see README: /plugin marketplace add). Use this
# script when the plugin path is not available on your version, or for another agent that
# reads ~/.codex/skills.
#
# Symlinks stay current with `git pull`. Pass --copy to copy instead (copies go stale; re-run
# after every pull). Pass --check to report drift without changing anything (exit 1 on drift).
set -euo pipefail

mode="link"; check=0
for arg in "$@"; do
  case "$arg" in
    --copy)  mode="copy" ;;
    --check) check=1 ;;
    *) echo "usage: install.sh [--copy] [--check]"; exit 2 ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$repo_root/skills"
targets=("$HOME/.claude/skills")
[ -d "$HOME/.codex" ] && targets+=("$HOME/.codex/skills")

tree_hash() { (cd "$1" && find . -type f | LC_ALL=C sort | xargs sha256sum 2>/dev/null | sha256sum | cut -d' ' -f1); }

drift=0; linked=0; copied=0; kept=0; count=0
for skill in "$src"/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  name="$(basename "$skill")"; count=$((count+1))
  for target in "${targets[@]}"; do
    mkdir -p "$target"
    dest="$target/$name"
    if [ "$check" = 1 ]; then
      if [ ! -e "$dest" ]; then echo "MISSING  $dest"; drift=$((drift+1)); continue; fi
      if [ -L "$dest" ]; then echo "link     $dest"; continue; fi
      if [ "$(tree_hash "$skill")" != "$(tree_hash "$dest")" ]; then echo "STALE    $dest"; drift=$((drift+1)); else echo "current  $dest"; fi
      continue
    fi
    if [ -L "$dest" ]; then kept=$((kept+1)); continue; fi
    rm -rf "$dest"
    if [ "$mode" = "link" ] && ln -s "$skill" "$dest" 2>/dev/null; then linked=$((linked+1)); else cp -R "$skill" "$dest"; copied=$((copied+1)); fi
  done
done

if [ "$check" = 1 ]; then
  if [ "$drift" -gt 0 ]; then echo; echo "DRIFT: $drift skill(s) missing or stale. Re-run install.sh."; exit 1; fi
  echo; echo "CLEAN: every installed skill is a link or matches the source."; exit 0
fi

echo; echo "Installed $count skill(s) into ${#targets[@]} location(s): $linked linked, $copied copied, $kept existing links kept."
if [ "$copied" -gt 0 ]; then echo "Copies go stale: re-run this script after git pull."; else echo "Links stay current: a git pull in this repo updates every skill."; fi
echo "Hooks are not installed by this script. See docs/HOOKS.md to add them per repo."
