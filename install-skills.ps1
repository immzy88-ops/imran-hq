# Claude Skills Installer — runs automatically, no interaction needed
$ErrorActionPreference = "SilentlyContinue"

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsSrc = "$repo\.claude\skills"
$marketplace = "$env:USERPROFILE\.claude\plugins\marketplaces\claude-plugins-official\plugins"
$skillsDir = "$env:USERPROFILE\.claude\skills"

$skills = @("caveman","decision-framer","expand-and-contract","find-skills","hook-forge","humanizer","infographic-builder","karpathy-guidelines")

Write-Host ""
Write-Host "Installing 8 Claude skills..." -ForegroundColor Cyan
Write-Host ""

foreach ($skill in $skills) {
    $src = "$skillsSrc\$skill"

    # Install into marketplace (shows in Skills panel)
    if (Test-Path $marketplace) {
        $dst = "$marketplace\$skill"
        New-Item -ItemType Directory -Force -Path "$dst\.claude-plugin" | Out-Null
        Copy-Item -Recurse -Force "$src\*" "$dst\" 2>$null
        Write-Host "  [marketplace] $skill" -ForegroundColor Green
    }

    # Also install into skills dir (fallback)
    $dst2 = "$skillsDir\$skill"
    New-Item -ItemType Directory -Force -Path "$dst2\.claude-plugin" | Out-Null
    Copy-Item -Recurse -Force "$src\*" "$dst2\" 2>$null
    Write-Host "  [skills-dir]  $skill" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done! Type /reload-plugins in Claude to activate them." -ForegroundColor Yellow
Write-Host ""
