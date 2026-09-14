#requires -Version 5.1
<#
.SYNOPSIS
    Install the best-practices skills into ~/.claude/skills (and ~/.codex/skills if present)
    so they are available in every repo on this machine.

.DESCRIPTION
    Preferred path is the Claude Code plugin (see README: /plugin marketplace add). Use this
    script when the plugin path is not available on your version, or when you want the skills
    for another agent that reads ~/.codex/skills.

    SYMLINK vs COPY, and why it matters:
      * A symlink stays current: a `git pull` in this repo updates every skill.
      * A copy is a snapshot. It goes stale silently.
    Symlinks need Developer Mode or an elevated shell on Windows. When they fail, this script
    copies, and it ALWAYS re-copies existing copies, because there is no cheap way to know a
    copy is current and an agent running months-old instructions costs far more than a
    re-copy of a few text files. Existing symlinks are left alone; they cannot be stale.

.PARAMETER Check
    Report drift (a copy whose content differs from the source) and exit 1 if any; change nothing.

.PARAMETER Copy
    Force copy mode even where symlinks would work.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1
    powershell -ExecutionPolicy Bypass -File .\install.ps1 -Check
#>
[CmdletBinding()]
param(
    [switch]$Check,
    [switch]$Copy
)

$ErrorActionPreference = 'Stop'
$repoRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsSrc  = Join-Path $repoRoot 'skills'
$targets    = @((Join-Path $HOME '.claude\skills'))
if (Test-Path (Join-Path $HOME '.codex')) { $targets += (Join-Path $HOME '.codex\skills') }

function Get-TreeHash([string]$path) {
    $files = Get-ChildItem -Path $path -Recurse -File | Sort-Object FullName
    $sb = New-Object System.Text.StringBuilder
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($path.Length)
        $h = (Get-FileHash -Path $f.FullName -Algorithm SHA256).Hash
        [void]$sb.Append("$rel=$h;")
    }
    return $sb.ToString()
}

$skills = Get-ChildItem -Path $skillsSrc -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }
if (-not $skills) { Write-Host 'No skills found under skills/.'; exit 1 }

$drift = 0; $linked = 0; $copied = 0; $kept = 0
foreach ($target in $targets) {
    if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target -Force | Out-Null }
    foreach ($s in $skills) {
        $dest = Join-Path $target $s.Name
        $item = Get-Item -Path $dest -ErrorAction SilentlyContinue
        $isLink = $item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)

        if ($Check) {
            if (-not $item) { Write-Host "MISSING  $dest"; $drift++; continue }
            if ($isLink)    { Write-Host "link     $dest"; continue }
            if ((Get-TreeHash $s.FullName) -ne (Get-TreeHash $dest)) { Write-Host "STALE    $dest"; $drift++ }
            else { Write-Host "current  $dest" }
            continue
        }

        if ($isLink) { $kept++; continue }
        if ($item) { Remove-Item -Path $dest -Recurse -Force }

        if (-not $Copy) {
            try {
                New-Item -ItemType SymbolicLink -Path $dest -Target $s.FullName -ErrorAction Stop | Out-Null
                $linked++; continue
            } catch { }
        }
        Copy-Item -Path $s.FullName -Destination $dest -Recurse -Force
        $copied++
    }
}

if ($Check) {
    if ($drift -gt 0) { Write-Host "`nDRIFT: $drift skill(s) missing or stale. Re-run install.ps1."; exit 1 }
    Write-Host "`nCLEAN: every installed skill is a link or matches the source."; exit 0
}

Write-Host "`nInstalled $($skills.Count) skill(s) into $($targets.Count) location(s): $linked linked, $copied copied, $kept existing links kept."
if ($copied -gt 0) {
    Write-Host 'Copies go stale: re-run this script after `git pull`, or enable Developer Mode so links work.'
} else {
    Write-Host 'Links stay current: a `git pull` in this repo updates every skill.'
}
Write-Host 'Hooks are not installed by this script. See docs/HOOKS.md to add them per repo.'
