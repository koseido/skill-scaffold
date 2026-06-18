[CmdletBinding()]
param(
    [string]$Root = ".claude/skills",
    [string]$IndexPath = "",
    [ValidateSet("auto", "global", "project", "lab", "disabled", "archive")]
    [string]$Scope = "auto"
)

$ErrorActionPreference = "Stop"

$resolvedRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Root)

if (-not (Test-Path -LiteralPath $resolvedRoot -PathType Container)) {
    Write-Error "Skills directory not found: $resolvedRoot"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($IndexPath)) {
    $IndexPath = Join-Path (Split-Path -Parent $resolvedRoot) "SKILLS_INDEX.md"
}
else {
    $IndexPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($IndexPath)
}

function Get-FrontmatterLines([string]$FilePath) {
    $lines = Get-Content -LiteralPath $FilePath
    if ($lines.Count -lt 3 -or $lines[0] -ne "---") {
        return @()
    }

    $endIndex = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq "---") {
            $endIndex = $i
            break
        }
    }

    if ($endIndex -lt 1) {
        return @()
    }

    return $lines[1..($endIndex - 1)]
}

function Get-FrontmatterValue([string]$FilePath, [string]$Key) {
    $escapedKey = [regex]::Escape($Key)
    foreach ($line in Get-FrontmatterLines $FilePath) {
        if ($line -match "^${escapedKey}:\s*(.+?)\s*$") {
            return $matches[1]
        }
    }
    return $null
}

function Test-FrontmatterTrue([string]$FilePath, [string]$Key) {
    $value = Get-FrontmatterValue -FilePath $FilePath -Key $Key
    return $value -eq "true"
}

function Infer-Scope([string]$SkillsRoot, [string]$ScopeValue) {
    if ($ScopeValue -ne "auto") {
        return $ScopeValue
    }

    $normalized = $SkillsRoot.Replace('\', '/')
    $homeNormalized = $HOME.Replace('\', '/')

    if ($normalized -like "*/skills-lab*") {
        return "lab"
    }
    if ($normalized -like "*/skills-disabled*") {
        return "disabled"
    }
    if ($normalized -like "*/skills-archive*") {
        return "archive"
    }
    if ($normalized -like "$homeNormalized/.claude/skills*") {
        return "global"
    }
    return "project"
}

function Scope-ToStatus([string]$ScopeValue) {
    switch ($ScopeValue) {
        "lab" { "experimental" }
        "disabled" { "disabled" }
        "archive" { "archived" }
        default { "active" }
    }
}

function Infer-Risk([string]$SkillName) {
    if ($SkillName -match '^(code|db|ops)-') {
        return "high"
    }
    if ($SkillName -match '^learn-') {
        return "low"
    }
    return "medium"
}

function Shorten-Purpose([string]$Description) {
    if ([string]::IsNullOrWhiteSpace($Description)) {
        return ""
    }

    $purpose = $Description -replace '\s+Use when.*$', ''
    $purpose = $purpose -replace '\s+Do not use.*$', ''
    $purpose = $purpose -replace '\s+Keywords:.*$', ''
    return $purpose.Trim()
}

$scopeValue = Infer-Scope -SkillsRoot $resolvedRoot -ScopeValue $Scope
$statusValue = Scope-ToStatus -ScopeValue $scopeValue

New-Item -ItemType Directory -Path (Split-Path -Parent $IndexPath) -Force | Out-Null

$rows = [System.Collections.Generic.List[string]]::new()
$rows.Add("| Skill | Domain | Scope | Status | Risk | Auto trigger | Purpose |")
$rows.Add("|---|---|---|---|---|---|---|")

Get-ChildItem -LiteralPath $resolvedRoot -Directory | Sort-Object Name | ForEach-Object {
    $skillMd = Join-Path $_.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillMd -PathType Leaf)) {
        return
    }

    $skillName = Get-FrontmatterValue -FilePath $skillMd -Key "name"
    if ([string]::IsNullOrWhiteSpace($skillName)) {
        $skillName = $_.Name
    }

    $domain = ($skillName -split '-')[0]
    $risk = Infer-Risk -SkillName $skillName
    $autoTrigger = if (Test-FrontmatterTrue -FilePath $skillMd -Key "disable-model-invocation") { "No" } else { "Yes" }
    $description = Get-FrontmatterValue -FilePath $skillMd -Key "description"
    $purpose = Shorten-Purpose -Description $description
    $purpose = $purpose.Replace("|", "/")

    $rows.Add("| $skillName | $domain | $scopeValue | $statusValue | $risk | $autoTrigger | $purpose |")
}

Set-Content -LiteralPath $IndexPath -Value $rows

Write-Host "Generated SKILLS_INDEX.md successfully."
Write-Host "Root: $resolvedRoot"
Write-Host "Index: $IndexPath"
