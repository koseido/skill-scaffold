[CmdletBinding()]
param(
    [string]$Root = ".claude/skills",
    [string]$IndexPath = ""
)

$ErrorActionPreference = "Stop"

$resolvedRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Root)

if (-not (Test-Path -LiteralPath $resolvedRoot -PathType Container)) {
    Write-Error "Skills directory not found: $resolvedRoot"
    exit 1
}

$Errors = 0
$Warnings = 0

function Write-Header([string]$Title) {
    Write-Host ""
    Write-Host "== $Title =="
}

function Add-Error([string]$Message) {
    Write-Host "  [ERROR] $Message"
    $script:Errors++
}

function Add-Warning([string]$Message) {
    Write-Host "  [WARN]  $Message"
    $script:Warnings++
}

function Add-Ok([string]$Message) {
    Write-Host "  [OK]    $Message"
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

function Test-FrontmatterKey([string]$FilePath, [string]$Key) {
    return $null -ne (Get-FrontmatterValue $FilePath $Key)
}

function Test-FrontmatterTrue([string]$FilePath, [string]$Key) {
    $value = Get-FrontmatterValue $FilePath $Key
    return $value -eq "true"
}

function Test-RequiredSection([string]$FilePath, [string]$Section) {
    Select-String -LiteralPath $FilePath -Pattern "^##\s+$([regex]::Escape($Section))\s*$" -Quiet
}

function Test-VagueDescription([string]$Description) {
    if ([string]::IsNullOrWhiteSpace($Description)) {
        return $true
    }

    if ($Description.Length -lt 80) {
        return $true
    }

    if ($Description -match '^[Hh]elps\s') {
        return $true
    }

    if ($Description -notmatch '[Uu]se when' -and $Description -notmatch '[Ww]hen ') {
        return $true
    }

    if ($Description -notmatch '[Dd]o not use' -and $Description -notmatch '[Nn]ot for') {
        return $true
    }

    return $false
}

function Test-HighRiskSkill([string]$SkillName) {
    return $SkillName -match '^(code|db|ops)-'
}

function Get-IndexInfo([string]$SkillsRoot, [string]$ExplicitIndexPath) {
    $candidate = $null

    if (-not [string]::IsNullOrWhiteSpace($ExplicitIndexPath)) {
        $candidate = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExplicitIndexPath)
    }
    else {
        $parentDir = Split-Path -Parent $SkillsRoot
        $defaultIndex = Join-Path $parentDir "SKILLS_INDEX.md"
        if (Test-Path -LiteralPath $defaultIndex -PathType Leaf) {
            $candidate = $defaultIndex
        }
    }

    if ([string]::IsNullOrWhiteSpace($candidate)) {
        return $null
    }

    return @{
        Path = $candidate
        Exists = (Test-Path -LiteralPath $candidate -PathType Leaf)
    }
}

function Parse-IndexRows([string]$FilePath) {
    $rows = @()
    $lines = Get-Content -LiteralPath $FilePath

    foreach ($line in $lines) {
        if ($line -notmatch '^\|') {
            continue
        }

        if ($line -match '^\|\s*Skill\s*\|' -or $line -match '^\|\s*-') {
            continue
        }

        $parts = $line.Trim('|').Split('|') | ForEach-Object { $_.Trim() }
        if ($parts.Count -lt 7) {
            continue
        }

        $rows += [pscustomobject]@{
            Skill       = $parts[0]
            Domain      = $parts[1]
            Scope       = $parts[2]
            Status      = $parts[3]
            Risk        = $parts[4]
            AutoTrigger = $parts[5]
            Purpose     = $parts[6]
        }
    }

    return $rows
}

function Validate-Index([string]$SkillsRoot, [object[]]$SkillSummaries) {
    $indexInfo = Get-IndexInfo -SkillsRoot $SkillsRoot -ExplicitIndexPath $IndexPath

    if ($null -eq $indexInfo) {
        Add-Warning "SKILLS_INDEX.md not found next to the Skills directory. Recommended for active Skill collections."
        return
    }

    Write-Header "SKILLS_INDEX.md"
    Add-Ok "Index path: $($indexInfo.Path)"

    $headerPattern = '^\|\s*Skill\s*\|\s*Domain\s*\|\s*Scope\s*\|\s*Status\s*\|\s*Risk\s*\|\s*Auto trigger\s*\|\s*Purpose\s*\|$'
    if (-not (Select-String -LiteralPath $indexInfo.Path -Pattern $headerPattern -Quiet)) {
        Add-Error "Index header does not match the required format."
    }
    else {
        Add-Ok "Index header matches the required format"
    }

    $rows = Parse-IndexRows -FilePath $indexInfo.Path
    if ($rows.Count -eq 0) {
        Add-Warning "Index contains no Skill rows."
        return
    }

    foreach ($summary in $SkillSummaries) {
        $matchingRows = @($rows | Where-Object { $_.Skill -eq $summary.Skill })
        if ($matchingRows.Count -eq 0) {
            Add-Warning "Missing index row for Skill: $($summary.Skill)"
            continue
        }

        if ($matchingRows.Count -gt 1) {
            Add-Warning "Duplicate index rows found for Skill: $($summary.Skill)"
        }

        $row = $matchingRows[0]
        if ($row.Domain -ne $summary.Domain) {
            Add-Warning "Index domain mismatch for $($summary.Skill): $($row.Domain) != $($summary.Domain)"
        }

        if ($row.AutoTrigger -ne $summary.AutoTrigger) {
            Add-Warning "Index auto trigger mismatch for $($summary.Skill): $($row.AutoTrigger) != $($summary.AutoTrigger)"
        }

        if ([string]::IsNullOrWhiteSpace($row.Purpose)) {
            Add-Warning "Index purpose is empty for Skill: $($summary.Skill)"
        }
    }
}

function Validate-OneSkill([string]$SkillDir) {
    $skillName = Split-Path -Leaf $SkillDir
    $skillMd = Join-Path $SkillDir "SKILL.md"

    Write-Header $skillName

    if ($skillName -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        Add-Error "Invalid directory name. Use lowercase kebab-case."
    }
    else {
        Add-Ok "Directory name uses lowercase kebab-case"
    }

    if (-not (Test-Path -LiteralPath $skillMd -PathType Leaf)) {
        Add-Error "Missing SKILL.md"
        return $null
    }
    else {
        Add-Ok "SKILL.md exists"
    }

    $firstLine = Get-Content -LiteralPath $skillMd -TotalCount 1
    if ($firstLine -ne "---") {
        Add-Error "SKILL.md must start with YAML frontmatter"
    }
    else {
        Add-Ok "Frontmatter detected"
    }

    $fmName = Get-FrontmatterValue -FilePath $skillMd -Key "name"
    if ($null -eq $fmName) {
        Add-Error "Frontmatter missing name"
    }
    else {
        Add-Ok "Frontmatter includes name: $fmName"
        if ($fmName -ne $skillName) {
            Add-Warning "Frontmatter name does not match directory name: $fmName != $skillName"
        }
    }

    $description = Get-FrontmatterValue -FilePath $skillMd -Key "description"
    if ($null -eq $description) {
        Add-Error "Frontmatter missing description"
    }
    else {
        Add-Ok "Frontmatter includes description"
        if (Test-VagueDescription -Description $description) {
            Add-Warning "Description may be too vague. Use: what it does + when to use + when not to use + keywords."
        }
        else {
            Add-Ok "Description looks specific"
        }
    }

    $requiredSections = @(
        "Purpose",
        "Best for",
        "Not for",
        "Required inputs",
        "Workflow",
        "Output format",
        "Safety rules"
    )

    foreach ($section in $requiredSections) {
        if (Test-RequiredSection -FilePath $skillMd -Section $section) {
            Add-Ok "Section exists: $section"
        }
        else {
            Add-Warning "Missing recommended section: $section"
        }
    }

    if (Test-HighRiskSkill -SkillName $skillName) {
        if (Test-FrontmatterTrue -FilePath $skillMd -Key "disable-model-invocation") {
            Add-Ok "High-risk Skill disables automatic invocation"
        }
        else {
            Add-Warning "High-risk Skill should usually include: disable-model-invocation: true"
        }
    }

    $scriptsDir = Join-Path $SkillDir "scripts"
    if (Test-Path -LiteralPath $scriptsDir -PathType Container) {
        Add-Warning "scripts/ exists. Ensure scripts are necessary and safe."
        $patterns = @(
            "rm -rf",
            "curl\s",
            "wget\s",
            "ssh\s",
            "scp\s",
            "git push",
            "git reset --hard",
            "sudo\s",
            "chmod\s+777",
            "\.env",
            "~/.ssh",
            "id_rsa",
            "id_ed25519"
        )
        $combinedPattern = ($patterns -join "|")
        $matches = Select-String -Path (Join-Path $scriptsDir "*") -Pattern $combinedPattern -AllMatches -SimpleMatch:$false -ErrorAction SilentlyContinue
        if ($matches) {
            Add-Warning "Risky commands or sensitive patterns found under scripts/:"
            foreach ($match in $matches) {
                Write-Host "     $($match.Path):$($match.LineNumber): $($match.Line.Trim())"
            }
        }
        else {
            Add-Ok "No risky script commands detected"
        }
    }
    else {
        Add-Ok "No scripts/ directory"
    }

    foreach ($dirName in @("references", "templates", "examples")) {
        $dirPath = Join-Path $SkillDir $dirName
        if (Test-Path -LiteralPath $dirPath -PathType Container) {
            Add-Ok "$dirName/ exists"
        }
        else {
            Add-Warning "$dirName/ missing. Recommended for non-trivial Skills."
        }
    }

    return [pscustomobject]@{
        Skill       = $skillName
        Domain      = ($skillName -split '-')[0]
        AutoTrigger = $(if (Test-FrontmatterTrue -FilePath $skillMd -Key "disable-model-invocation") { "No" } else { "Yes" })
    }
}

Write-Header "Validating Skills"
Write-Host "Root: $resolvedRoot"

$skillDirs = Get-ChildItem -LiteralPath $resolvedRoot -Directory | Sort-Object Name
if ($skillDirs.Count -eq 0) {
    Write-Host "No Skill directories found under: $resolvedRoot"
    exit 0
}

$summaries = @()
foreach ($skillDir in $skillDirs) {
    $summary = Validate-OneSkill -SkillDir $skillDir.FullName
    if ($null -ne $summary) {
        $summaries += $summary
    }
}

Validate-Index -SkillsRoot $resolvedRoot -SkillSummaries $summaries

Write-Header "Summary"
Write-Host "Skills checked: $($skillDirs.Count)"
Write-Host "Errors: $Errors"
Write-Host "Warnings: $Warnings"

if ($Errors -gt 0) {
    Write-Host ""
    Write-Host "Validation failed with blocking errors."
    exit 1
}

Write-Host ""
Write-Host "Validation completed."
exit 0
