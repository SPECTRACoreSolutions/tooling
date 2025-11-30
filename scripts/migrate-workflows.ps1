# Workflow Migration Script
# This script migrates repositories to use standard SPECTRA workflows
#
# Usage:
#   .\migrate-workflows.ps1 -RepoPath "C:\path\to\repo" -RepoType "python" -DryRun
#   .\migrate-workflows.ps1 -RepoPath "C:\path\to\repo" -RepoType "node" -Apply

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoPath,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("python", "node", "both")]
    [string]$RepoType,
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Apply = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$CleanupOnly = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$AddRailwayCD = $false
)

# Script configuration
$ErrorActionPreference = "Stop"
$TemplateBase = "C:\Users\markm\OneDrive\SPECTRA\Core\infrastructure\tooling\workflows"

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       SPECTRA Workflow Migration Script                  ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Validate repo path
if (-not (Test-Path $RepoPath)) {
    Write-Error "Repository path does not exist: $RepoPath"
    exit 1
}

# Validate template base exists
if (-not (Test-Path $TemplateBase)) {
    Write-Error "Template base does not exist: $TemplateBase`nRun this script from a machine with SPECTRA workspace available."
    exit 1
}

# Get repo name
$RepoName = Split-Path -Leaf $RepoPath
Write-Host "Repository: $RepoName" -ForegroundColor Yellow
Write-Host "Path: $RepoPath" -ForegroundColor Gray
Write-Host "Type: $RepoType" -ForegroundColor Gray
Write-Host "Mode: $(if ($DryRun) { 'DRY RUN (no changes)' } elseif ($Apply) { 'APPLY (will make changes)' } else { 'PREVIEW' })" -ForegroundColor $(if ($DryRun -or -not $Apply) { 'Yellow' } else { 'Green' })
Write-Host ""

# Track changes
$Changes = @{
    FilesDeleted = @()
    FilesCreated = @()
    FilesModified = @()
    DirectoriesDeleted = @()
}

# Function to safely delete file
function Remove-SafeFile {
    param([string]$Path)
    if (Test-Path $Path) {
        $Changes.FilesDeleted += $Path
        if ($Apply) {
            Remove-Item $Path -Force
            Write-Host "  ✓ Deleted: $(Split-Path -Leaf $Path)" -ForegroundColor Red
        } else {
            Write-Host "  ⊘ Would delete: $(Split-Path -Leaf $Path)" -ForegroundColor Yellow
        }
    }
}

# Function to safely delete directory
function Remove-SafeDirectory {
    param([string]$Path)
    if (Test-Path $Path) {
        $Changes.DirectoriesDeleted += $Path
        if ($Apply) {
            Remove-Item $Path -Recurse -Force
            Write-Host "  ✓ Deleted directory: $(Split-Path -Leaf $Path)" -ForegroundColor Red
        } else {
            Write-Host "  ⊘ Would delete directory: $(Split-Path -Leaf $Path)" -ForegroundColor Yellow
        }
    }
}

# Function to safely copy file
function Copy-SafeFile {
    param([string]$Source, [string]$Destination)
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        if ($Apply) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }
    
    if (Test-Path $Destination) {
        $Changes.FilesModified += $Destination
        if ($Apply) {
            Copy-Item $Source $Destination -Force
            Write-Host "  ✓ Updated: $(Split-Path -Leaf $Destination)" -ForegroundColor Yellow
        } else {
            Write-Host "  ⊘ Would update: $(Split-Path -Leaf $Destination)" -ForegroundColor Yellow
        }
    } else {
        $Changes.FilesCreated += $Destination
        if ($Apply) {
            Copy-Item $Source $Destination -Force
            Write-Host "  ✓ Created: $(Split-Path -Leaf $Destination)" -ForegroundColor Green
        } else {
            Write-Host "  ⊘ Would create: $(Split-Path -Leaf $Destination)" -ForegroundColor Yellow
        }
    }
}

# ========================================
# PHASE 1: CLEANUP
# ========================================

Write-Host "═══ Phase 1: Cleanup ═══" -ForegroundColor Cyan
Write-Host ""

Write-Host "Removing obsolete context generation files..." -ForegroundColor Yellow

# Delete validate-context-artifacts.yml workflows
$obsoleteWorkflows = @(
    ".github/workflows/validate-context-artifacts.yml",
    "scripts/context/validate-context-artifacts.yml",
    "templates/context/validate-context-artifacts.yml"
)

foreach ($workflow in $obsoleteWorkflows) {
    $fullPath = Join-Path $RepoPath $workflow
    Remove-SafeFile $fullPath
}

# Delete generate_context.py scripts
$contextScriptPaths = @(
    "scripts/context/generate_context.py",
    "templates/context/generate_context.py"
)

foreach ($scriptPath in $contextScriptPaths) {
    $fullPath = Join-Path $RepoPath $scriptPath
    Remove-SafeFile $fullPath
}

# Delete entire scripts/context directory if empty or only has context files
$scriptsContextDir = Join-Path $RepoPath "scripts/context"
if (Test-Path $scriptsContextDir) {
    $remainingFiles = Get-ChildItem $scriptsContextDir -File
    if ($remainingFiles.Count -eq 0) {
        Remove-SafeDirectory $scriptsContextDir
    }
}

# Delete templates/context directory
$templatesContextDir = Join-Path $RepoPath "templates/context"
Remove-SafeDirectory $templatesContextDir

# Delete .spectra directories
$spectraDir = Join-Path $RepoPath ".spectra"
Remove-SafeDirectory $spectraDir

Write-Host ""

# ========================================
# PHASE 2: ADD CI WORKFLOWS
# ========================================

if (-not $CleanupOnly) {
    Write-Host "═══ Phase 2: Add CI Workflows ═══" -ForegroundColor Cyan
    Write-Host ""

    $githubDir = Join-Path $RepoPath ".github"
    $workflowsDir = Join-Path $githubDir "workflows"

    # Create .github/workflows directory if needed
    if ($Apply -and -not (Test-Path $workflowsDir)) {
        New-Item -ItemType Directory -Path $workflowsDir -Force | Out-Null
        Write-Host "  ✓ Created .github/workflows directory" -ForegroundColor Green
    }

    # Copy appropriate CI template
    if ($RepoType -eq "python" -or $RepoType -eq "both") {
        Write-Host "Adding Python CI workflow..." -ForegroundColor Yellow
        $source = Join-Path $TemplateBase "templates/ci-python.yml"
        $dest = Join-Path $workflowsDir "ci.yml"
        Copy-SafeFile $source $dest
    }

    if ($RepoType -eq "node" -or $RepoType -eq "both") {
        Write-Host "Adding Node.js CI workflow..." -ForegroundColor Yellow
        $source = Join-Path $TemplateBase "templates/ci-node.yml"
        $dest = Join-Path $workflowsDir "ci-node.yml"
        Copy-SafeFile $source $dest
    }

    # Copy Dependabot config
    Write-Host "Adding Dependabot configuration..." -ForegroundColor Yellow
    $source = Join-Path $TemplateBase "templates/dependabot.yml"
    $dest = Join-Path $githubDir "dependabot.yml"
    Copy-SafeFile $source $dest

    # Optional: Add security workflow
    Write-Host "Adding security scanning workflow..." -ForegroundColor Yellow
    $source = Join-Path $TemplateBase "templates/security.yml"
    $dest = Join-Path $workflowsDir "security.yml"
    Copy-SafeFile $source $dest

    Write-Host ""
}

# ========================================
# PHASE 3: ADD CD WORKFLOWS (OPTIONAL)
# ========================================

if ($AddRailwayCD -and -not $CleanupOnly) {
    Write-Host "═══ Phase 3: Add Railway CD ═══" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Adding Railway deployment workflow..." -ForegroundColor Yellow
    $source = Join-Path $TemplateBase "templates/cd-railway.yml"
    $dest = Join-Path (Join-Path $RepoPath ".github/workflows") "deploy.yml"
    Copy-SafeFile $source $dest

    Write-Host "Adding Railway configuration..." -ForegroundColor Yellow
    $source = Join-Path $TemplateBase "templates/railway.json"
    $dest = Join-Path $RepoPath "railway.json"
    Copy-SafeFile $source $dest

    Write-Host ""
}

# ========================================
# SUMMARY
# ========================================

Write-Host "═══ Summary ═══" -ForegroundColor Cyan
Write-Host ""

Write-Host "Files to delete: $($Changes.FilesDeleted.Count)" -ForegroundColor $(if ($Changes.FilesDeleted.Count -gt 0) { 'Red' } else { 'Gray' })
if ($Changes.FilesDeleted.Count -gt 0) {
    $Changes.FilesDeleted | ForEach-Object { 
        Write-Host "  - $($_ -replace [regex]::Escape($RepoPath), '')" -ForegroundColor Gray
    }
}

Write-Host "Directories to delete: $($Changes.DirectoriesDeleted.Count)" -ForegroundColor $(if ($Changes.DirectoriesDeleted.Count -gt 0) { 'Red' } else { 'Gray' })
if ($Changes.DirectoriesDeleted.Count -gt 0) {
    $Changes.DirectoriesDeleted | ForEach-Object { 
        Write-Host "  - $($_ -replace [regex]::Escape($RepoPath), '')" -ForegroundColor Gray
    }
}

Write-Host "Files to create: $($Changes.FilesCreated.Count)" -ForegroundColor $(if ($Changes.FilesCreated.Count -gt 0) { 'Green' } else { 'Gray' })
if ($Changes.FilesCreated.Count -gt 0) {
    $Changes.FilesCreated | ForEach-Object { 
        Write-Host "  - $($_ -replace [regex]::Escape($RepoPath), '')" -ForegroundColor Gray
    }
}

Write-Host "Files to modify: $($Changes.FilesModified.Count)" -ForegroundColor $(if ($Changes.FilesModified.Count -gt 0) { 'Yellow' } else { 'Gray' })
if ($Changes.FilesModified.Count -gt 0) {
    $Changes.FilesModified | ForEach-Object { 
        Write-Host "  - $($_ -replace [regex]::Escape($RepoPath), '')" -ForegroundColor Gray
    }
}

Write-Host ""

if ($Apply) {
    Write-Host "✅ Migration complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review changes: git status" -ForegroundColor White
    Write-Host "  2. Test locally if needed" -ForegroundColor White
    Write-Host "  3. Commit: git add . && git commit -m 'chore: standardise workflows'" -ForegroundColor White
    Write-Host "  4. Push: git push" -ForegroundColor White
    Write-Host "  5. Open PR and verify CI runs" -ForegroundColor White
} elseif ($DryRun) {
    Write-Host "ℹ️  This was a dry run. No changes were made." -ForegroundColor Yellow
    Write-Host "   Run with -Apply to make changes." -ForegroundColor Yellow
} else {
    Write-Host "ℹ️  Preview complete. Run with -Apply to make changes." -ForegroundColor Yellow
}

Write-Host ""

# Return summary for scripting
return $Changes


