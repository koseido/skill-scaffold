[CmdletBinding()]
param(
    [ValidateSet("global", "project")]
    [string]$Scope = "global",

    [string]$Skill = "skill-scaffold",

    [string]$Source = "",

    [string]$Target = "",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

function Get-Timestamp {
    Get-Date -Format "yyyyMMddHHmmss"
}

if ([string]::IsNullOrWhiteSpace($Skill)) {
    Fail "--skill cannot be empty"
}

if ($Skill -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    Fail "Invalid skill name: $Skill. Use lowercase kebab-case, for example: skill-scaffold or code-safe-feature."
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

if ([string]::IsNullOrWhiteSpace($Source)) {
    $Source = Join-Path $repoRoot "skills\$Skill"
}

$resolvedSource = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Source)

if (-not (Test-Path -LiteralPath $resolvedSource -PathType Container)) {
    Fail "Source Skill directory not found: $resolvedSource"
}

$sourceSkillMd = Join-Path $resolvedSource "SKILL.md"
if (-not (Test-Path -LiteralPath $sourceSkillMd -PathType Leaf)) {
    Fail "Source Skill is missing SKILL.md: $sourceSkillMd"
}

if ($Scope -eq "global") {
    if ([string]::IsNullOrWhiteSpace($Target)) {
        $Target = Join-Path $HOME ".claude\skills"
    }
    $targetSkillsDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)
}
else {
    if ([string]::IsNullOrWhiteSpace($Target)) {
        $Target = "."
    }
    $targetRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)
    $targetSkillsDir = Join-Path $targetRoot ".claude\skills"
}

$targetSkillDir = Join-Path $targetSkillsDir $Skill

New-Item -ItemType Directory -Path $targetSkillsDir -Force | Out-Null

if (Test-Path -LiteralPath $targetSkillDir) {
    if (-not $Force.IsPresent) {
        Fail "Target Skill already exists: $targetSkillDir. Use --force to back it up and overwrite."
    }

    $backupDir = "$targetSkillDir.backup.$(Get-Timestamp)"
    Write-Host "Existing Skill found. Creating backup:"
    Write-Host "  $backupDir"
    Move-Item -LiteralPath $targetSkillDir -Destination $backupDir
}

Copy-Item -LiteralPath $resolvedSource -Destination $targetSkillDir -Recurse

Write-Host "Installed Skill successfully."
Write-Host ""
Write-Host "Skill:"
Write-Host "  $Skill"
Write-Host ""
Write-Host "Source:"
Write-Host "  $resolvedSource"
Write-Host ""
Write-Host "Target:"
Write-Host "  $targetSkillDir"
Write-Host ""
Write-Host "Usage:"
Write-Host "  /$Skill"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review $targetSkillDir\SKILL.md"
Write-Host "  2. Validate with: powershell -ExecutionPolicy Bypass -File scripts\validate-skill.ps1 $targetSkillsDir"
Write-Host "  3. Restart your AI tool if the Skill does not appear"
