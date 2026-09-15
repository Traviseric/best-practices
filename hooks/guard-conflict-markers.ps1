<#
  PreToolUse(Bash) guard: stops a file with unresolved merge-conflict markers from
  being committed.

  Why: a conflict marker is never intentional content in code or data. A botched
  `git stash pop` or a half-finished rebase can leave "<<<<<<< Updated upstream" in
  a JSON file that a script reads, and nothing notices until the script fails hours
  later. Catching it at `git commit` costs milliseconds; catching it after it lands
  costs an archaeology session to find the last commit where the file was valid.

  Scope is deliberately narrow:
    - only `git commit` (not add/status/log/push/diff)
    - only files STAGED for this commit, read from the index (`git show :path`),
      so unrelated dirty work in the tree is never the reason a commit is blocked
    - only the full triad (<<<<<<< AND ======= AND >>>>>>>) at line start, which
      is far more specific than any single marker and will not trip on prose that
      merely mentions one

  Escape hatch: a file containing the literal token ALLOW-CONFLICT-MARKERS is
  skipped, for the rare doc that legitimately shows a conflict verbatim.

  FAILS OPEN: no git, not a repo, an unreadable blob, or any parse problem allows
  the command. A hygiene guard must never be the reason real work cannot proceed.

  Wiring (Claude Code, .claude/settings.json):
    { "matcher": "Bash", "hooks": [ { "type": "command", "if": "Bash(git commit *)",
      "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PROJECT_DIR}/.claude/hooks/guard-conflict-markers.ps1\"",
      "timeout": 30 } ] }
  On Windows PowerShell 5.1 replace `pwsh` with `powershell`.
#>
$ErrorActionPreference = 'Stop'

function Allow { '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'; exit 0 }
function Deny([string]$why) {
  $o = @{ hookSpecificOutput = @{
      hookEventName = 'PreToolUse'
      permissionDecision = 'deny'
      permissionDecisionReason = $why } }
  $o | ConvertTo-Json -Compress -Depth 5
  exit 0
}

try {
  $raw = [Console]::In.ReadToEnd()
  if (-not $raw) { Allow }
  $payload = $raw | ConvertFrom-Json
  $cmd = [string]$payload.tool_input.command
  if (-not $cmd) { Allow }

  # Only `git commit` is in scope. --amend counts; add/push/status pass untouched.
  if ($cmd -notmatch '(?i)\bgit\b[^&|;]*\bcommit\b') { Allow }

  # The Bash tool speaks Git-Bash/MSYS (/c/code/...) and WSL (/mnt/c/code/...) paths.
  function ConvertTo-WinPath([string]$p) {
    if (-not $p) { return $p }
    if ($p -match '^/mnt/([a-zA-Z])/(.*)$') { return ('{0}:\{1}' -f $Matches[1].ToUpper(), ($Matches[2] -replace '/', '\')) }
    if ($p -match '^/([a-zA-Z])/(.*)$')     { return ('{0}:\{1}' -f $Matches[1].ToUpper(), ($Matches[2] -replace '/', '\')) }
    if ($p -match '^/([a-zA-Z])/?$')        { return ('{0}:\' -f $Matches[1].ToUpper()) }
    return $p
  }

  $cwd = ConvertTo-WinPath ([string]$payload.cwd)
  if (-not $cwd -or -not (Test-Path -LiteralPath $cwd)) { $cwd = (Get-Location).Path }

  # `cd x && git commit ...`: honour the LAST cd target that resolves.
  if ($cmd -match '(?i)(?:^|[;&|]\s*)cd\s+(?:-{1,2}\S+\s+)*(?:"([^"]+)"|''([^'']+)''|([^\s;&|]+))') {
    $target = $Matches[1]; if (-not $target) { $target = $Matches[2] }; if (-not $target) { $target = $Matches[3] }
    $target = ConvertTo-WinPath $target
    if ($target) {
      $resolved = if ([System.IO.Path]::IsPathRooted($target)) { $target } else { Join-Path $cwd $target }
      if (Test-Path -LiteralPath $resolved) { $cwd = (Get-Item -LiteralPath $resolved).FullName }
    }
  }

  $git = Get-Command git -ErrorAction SilentlyContinue
  if (-not $git) { Allow }   # no git -> not this guard's problem

  # An explicit `-C <path>` on the git command wins over cwd.
  if ($cmd -match '(?i)\bgit\b\s+(?:[^\s]+\s+)*?-C\s+(?:"([^"]+)"|''([^'']+)''|([^\s]+))') {
    $t = $Matches[1]; if (-not $t) { $t = $Matches[2] }; if (-not $t) { $t = $Matches[3] }
    $t = ConvertTo-WinPath $t
    if ($t) {
      $r = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $cwd $t }
      if (Test-Path -LiteralPath $r) { $cwd = (Get-Item -LiteralPath $r).FullName }
    }
  }

  $names = & $git.Source -C $cwd diff --cached --name-only --diff-filter=ACM 2>$null
  if ($LASTEXITCODE -ne 0) { Allow }        # not a repo, or nothing staged
  if (-not $names) { Allow }

  $bad = New-Object System.Collections.Generic.List[string]
  foreach ($n in $names) {
    if (-not $n) { continue }
    if ($bad.Count -ge 20) { break }        # a bounded report is still actionable

    $blob = & $git.Source -C $cwd show (":{0}" -f $n) 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $blob) { continue }
    $text = $blob -join "`n"

    if ($text.Length -gt 4000000) { continue }          # very large file: skip, stay fast
    if ($text.IndexOf([char]0) -ge 0) { continue }      # binary: markers are meaningless
    if ($text -match 'ALLOW-CONFLICT-MARKERS') { continue }

    # Require the FULL triad at line start. Any one marker alone can be legitimate prose.
    $hasStart = $text -match '(?m)^<<<<<<< '
    $hasMid   = $text -match '(?m)^=======\s*$'
    $hasEnd   = $text -match '(?m)^>>>>>>> '
    if ($hasStart -and $hasMid -and $hasEnd) { $bad.Add($n) }
  }

  if ($bad.Count -gt 0) {
    $list = ($bad | ForEach-Object { "  - $_" }) -join "`n"
    Deny @"
BLOCKED: $($bad.Count) staged file(s) contain unresolved merge-conflict markers.

$list

These files carry <<<<<<< / ======= / >>>>>>> at line start, so whatever reads them
next will fail to parse. Resolve the conflict, restage, and commit again.

If a file legitimately shows a conflict verbatim (a doc, a fixture), put the token
ALLOW-CONFLICT-MARKERS in it and this guard will skip it.
"@
  }

  Allow
}
catch { Allow }   # fail open
