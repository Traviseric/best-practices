<#
  PreToolUse(Bash) guard: stops a STAGED file carrying a high-confidence live
  credential from being committed.

  Why: a secret in git history is not fixable with a follow-up commit. It must be
  rotated across every consumer of that key, and it stays in history forever. A
  conflict marker costs an afternoon; a leaked live key costs a rotation.

  Scope is deliberately narrow. The guardrail on a guard is that it must never be
  the reason a legitimate commit fails:
    - only `git commit` (not add/status/log/push/diff)
    - only files STAGED for this commit, read from the index (`git show :path`),
      so unrelated dirty work in the tree is never the reason a commit is blocked
    - only PROVIDER-PREFIXED live-credential shapes (sk_live_, sk-ant-, ghp_, AKIA,
      xox?-, AIza, private-key headers, a password inside a postgres:// URL).
      A bare high-entropy string is NOT flagged. That is where false positives live.
    - placeholder forms (your-, example, REPLACE_ME, xxxx, <...>) are skipped
    - .env.example / .env.sample / *.template are skipped by name
    - test/fixture/mock/snapshot paths are skipped, because their purpose is to
      contain secret-shaped strings. A guard that cries wolf gets disabled, and then
      it covers nothing. Accepted trade: a real key pasted INTO a test file is not
      caught here. Read your diff before you stage it.

  KNOWN LIMIT: binary documents (PDF, DOCX, images) are skipped. Their text is
  compressed, so a plaintext password inside a tracked PDF is on the human, not on
  this scanner. Do not read a pass here as proof a document is clean.

  Escape hatches:
    - a file containing the literal token ALLOW-SECRET-SCAN is skipped
    - a commit command containing the literal token ALLOW-SECRET-SCAN skips the
      whole check for that one commit

  FAILS OPEN: no git, not a repo, an unreadable blob, or any parse problem allows
  the command. A hygiene guard must never be the reason real work cannot proceed.

  Wiring (Claude Code, .claude/settings.json):
    { "matcher": "Bash", "hooks": [ { "type": "command", "if": "Bash(git commit *)",
      "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PROJECT_DIR}/.claude/hooks/guard-staged-secrets.ps1\"",
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

# name -> regex. Every one is provider-anchored; none is "looks random enough".
# Add your own internal service-key prefix here if you have one, e.g.
#   'Internal service key' = '\bmyco_svc_[a-z0-9\-]+_[0-9a-f]{32}\b'
$SECRET_PATTERNS = [ordered]@{
  'Stripe live key'        = '\b[srk]k_live_[A-Za-z0-9]{16,}'
  'Anthropic API key'      = '\bsk-ant-[A-Za-z0-9_\-]{24,}'
  'OpenAI project key'     = '\bsk-proj-[A-Za-z0-9_\-]{24,}'
  'OpenAI legacy key'      = '\bsk-[A-Za-z0-9]{40,}'
  'GitHub token'           = '\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}|\bgithub_pat_[A-Za-z0-9_]{30,}'
  'AWS access key id'      = '\bAKIA[0-9A-Z]{16}\b'
  'Slack token'            = '\bxox[baprs]-[A-Za-z0-9\-]{10,}'
  'Google API key'         = '\bAIza[0-9A-Za-z_\-]{35}\b'
  'Private key block'      = '-----BEGIN (?:RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----'
  'Password in DB URL'     = '\b(?:postgres(?:ql)?|mysql|mongodb(?:\+srv)?|redis|amqp)://[^:/\s]+:[^@\s''"]{6,}@'
}

# If the matched LINE also looks like a placeholder, it is documentation, not a leak.
# `\.invalid` catches the RFC-2606 fixture host convention; the sequential/alphabet
# runs catch hand-typed fake keys (sk_live_1234567890..., sk_live_51AbCdEfGh...).
$PLACEHOLDER = '(?i)your[-_]|example|placeholder|replace[-_]?me|<[^>]+>|\bxxxx|\bdummy|\bfake|redacted|\*{4,}|\.invalid\b|1234567890|abcdefgh|qwerty|0{12,}'

# Files whose PURPOSE is to contain secret-shaped strings.
$EXEMPT_PATH = '(?i)(^|/)(tests?|__tests__|testing|spec|fixtures?|mocks?|captures?|snapshots?)/|\.(test|spec|fixture|mock)\.[a-z]+$'

try {
  $raw = [Console]::In.ReadToEnd()
  if (-not $raw) { Allow }
  $payload = $raw | ConvertFrom-Json
  $cmd = [string]$payload.tool_input.command
  if (-not $cmd) { Allow }

  # Only `git commit` is in scope.
  if ($cmd -notmatch '(?i)\bgit\b[^&|;]*\bcommit\b') { Allow }
  # Explicit one-commit bypass.
  if ($cmd -match 'ALLOW-SECRET-SCAN') { Allow }

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
  if (-not $git) { Allow }

  # An explicit `-C <path>` wins over cwd.
  if ($cmd -match '(?i)\bgit\b\s+(?:[^\s]+\s+)*?-C\s+(?:"([^"]+)"|''([^'']+)''|([^\s]+))') {
    $t = $Matches[1]; if (-not $t) { $t = $Matches[2] }; if (-not $t) { $t = $Matches[3] }
    $t = ConvertTo-WinPath $t
    if ($t) {
      $r = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $cwd $t }
      if (Test-Path -LiteralPath $r) { $cwd = (Get-Item -LiteralPath $r).FullName }
    }
  }

  $names = & $git.Source -C $cwd diff --cached --name-only --diff-filter=ACM 2>$null
  if ($LASTEXITCODE -ne 0) { Allow }
  if (-not $names) { Allow }

  $hits = New-Object System.Collections.Generic.List[string]
  foreach ($n in $names) {
    if (-not $n) { continue }
    if ($hits.Count -ge 20) { break }
    if ($n -match '(?i)(^|/)\.env\.(example|sample|template)$|\.(template|example|sample)$') { continue }
    if ($n -match $EXEMPT_PATH) { continue }

    $blob = & $git.Source -C $cwd show (":{0}" -f $n) 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $blob) { continue }
    $text = $blob -join "`n"

    if ($text.Length -gt 4000000) { continue }
    if ($text.IndexOf([char]0) -ge 0) { continue }   # binary: see KNOWN LIMIT above
    if ($text -match 'ALLOW-SECRET-SCAN') { continue }

    foreach ($kind in $SECRET_PATTERNS.Keys) {
      $m = [regex]::Match($text, $SECRET_PATTERNS[$kind])
      if (-not $m.Success) { continue }
      # Re-check the whole LINE for placeholder tells before calling it a leak.
      $lineStart = $text.LastIndexOf("`n", [Math]::Max(0, $m.Index)) + 1
      $lineEnd = $text.IndexOf("`n", $m.Index); if ($lineEnd -lt 0) { $lineEnd = $text.Length }
      $line = $text.Substring($lineStart, $lineEnd - $lineStart)
      if ($line -match $PLACEHOLDER) { continue }
      $hits.Add("$n  -  $kind")
      break
    }
  }

  if ($hits.Count -gt 0) {
    $list = ($hits | ForEach-Object { "  - $_" }) -join "`n"
    Deny @"
BLOCKED: $($hits.Count) staged file(s) appear to contain a live credential.

$list

A secret in git history is not fixable with a follow-up commit. It must be ROTATED.
Do this instead:
  1. Unstage the file:            git restore --staged <file>
  2. Move the real value to your secret store (a local .env that is gitignored, or
     the platform's own store: Vercel/Railway env, AWS Secrets Manager, 1Password).
  3. Reference it by NAME in code and docs, then re-stage and commit.
If this is genuinely not a secret (a fixture, a doc showing the SHAPE of a key), add the
token ALLOW-SECRET-SCAN to the file, or use an obvious placeholder form.
"@
  }

  Allow
} catch {
  Allow   # fail open, always
}
