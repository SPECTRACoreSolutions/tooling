# Bulk Workflow Migration Script
# This script migrates ALL SPECTRA repositories to standard workflows
#
# Usage:
#   .\bulk-migrate-workflows.ps1 -DryRun          # Preview changes
#   .\bulk-migrate-workflows.ps1 -Apply           # Apply changes
#   .\bulk-migrate-workflows.ps1 -Apply -AutoCommit  # Apply and commit

param(
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Apply = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoCommit = $false,
    
    [Parameter(Mandatory=$false)]
    [string]$BaseDir = "C:\Users\markm\OneDrive\SPECTRA"
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       SPECTRA Bulk Workflow Migration                    ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not $Apply) {
    Write-Host "⚠️  DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host "   Run with -Apply to make changes`n" -ForegroundColor Yellow
}

# Repository configuration
# Maps subfolder to repository type and whether it needs Railway CD
$Repositories = @(
    # Core org
    @{Path="Core\.github"; Type="python"; Railway=$false},
    @{Path="Core\.github-private"; Type="python"; Railway=$false},
    @{Path="Core\academy"; Type="python"; Railway=$false},
    @{Path="Core\assistant"; Type="python"; Railway=$false},
    @{Path="Core\foundation"; Type="python"; Railway=$false},
    @{Path="Core\onboarding"; Type="python"; Railway=$false},
    @{Path="Core\operations"; Type="python"; Railway=$false},
    @{Path="Core\opinions"; Type="python"; Railway=$false},
    @{Path="Core\portal"; Type="node"; Railway=$true},  # Astro
    @{Path="Core\support"; Type="python"; Railway=$false},
    @{Path="Core\Vault"; Type="python"; Railway=$false},
    
    # Data org
    @{Path="Data\.github"; Type="python"; Railway=$false},
    @{Path="Data\.github-private"; Type="python"; Railway=$false},
    @{Path="Data\branding"; Type="python"; Railway=$false},
    @{Path="Data\bridge"; Type="python"; Railway=$false},
    @{Path="Data\context"; Type="python"; Railway=$true},  # MCP server
    @{Path="Data\design"; Type="python"; Railway=$false},
    @{Path="Data\framework"; Type="python"; Railway=$false},
    @{Path="Data\graph"; Type="python"; Railway=$false},
    @{Path="Data\jira"; Type="python"; Railway=$false},
    @{Path="Data\media"; Type="python"; Railway=$false},
    @{Path="Data\unifi"; Type="python"; Railway=$false},
    @{Path="Data\xero"; Type="python"; Railway=$true},  # Flask app
    @{Path="Data\zephyr"; Type="python"; Railway=$false},
    
    # Design org
    @{Path="Design\.github"; Type="python"; Railway=$false},
    @{Path="Design\.github-private"; Type="python"; Railway=$false},
    @{Path="Design\library"; Type="python"; Railway=$false},
    
    # Engagement org
    @{Path="Engagement\.github"; Type="python"; Railway=$false},
    @{Path="Engagement\.github-private"; Type="python"; Railway=$false},
    @{Path="Engagement\discovery"; Type="python"; Railway=$false},
    
    # Engineering org
    @{Path="Engineering\.github"; Type="python"; Railway=$false},
    
    # Media org
    @{Path="Media\.github"; Type="python"; Railway=$false},
    @{Path="Media\.github-private"; Type="python"; Railway=$false},
    
    # Security org
    @{Path="Security\.github"; Type="python"; Railway=$false},
    @{Path="Security\.github-private"; Type="python"; Railway=$false},
    @{Path="Security\CRISC"; Type="python"; Railway=$false},
    @{Path="Security\iso27001"; Type="python"; Railway=$false}
)

# Track overall progress
$TotalRepos = $Repositories.Count
$ProcessedRepos = 0
$SuccessfulRepos = 0
$FailedRepos = @()
$SkippedRepos = @()

Write-Host "Found $TotalRepos repositories to process`n" -ForegroundColor Cyan

# Process each repository
foreach ($repo in $Repositories) {
    $ProcessedRepos++
    $repoPath = Join-Path $BaseDir $repo.Path
    $repoName = $repo.Path -replace '\\', '/'
    
    Write-Host "[$ProcessedRepos/$TotalRepos] Processing: $repoName" -ForegroundColor Yellow
    
    # Check if path exists
    if (-not (Test-Path $repoPath)) {
        Write-Host "  ⊘ Skipped: Directory not found" -ForegroundColor Gray
        $SkippedRepos += $repoName
        Write-Host ""
        continue
    }
    
    # Check if it's actually a repository (has README or some code)
    $hasContent = (Get-ChildItem $repoPath -File -Recurse -Include "*.py","*.js","*.ts","README.md" -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
    
    if (-not $hasContent) {
        Write-Host "  ⊘ Skipped: No content found" -ForegroundColor Gray
        $SkippedRepos += $repoName
        Write-Host ""
        continue
    }
    
    try {
        # Call the migration script
        $migrationScript = Join-Path $BaseDir "Core\infrastructure\tooling\scripts\migrate-workflows.ps1"
        
        $params = @{
            RepoPath = $repoPath
            RepoType = $repo.Type
        }
        
        if ($Apply) {
            $params.Add("Apply", $true)
        } else {
            $params.Add("DryRun", $true)
        }
        
        if ($repo.Railway) {
            $params.Add("AddRailwayCD", $true)
        }
        
        # Run migration
        $result = & $migrationScript @params
        
        # Check if changes were made
        $changesMade = $false
        if ($result) {
            $totalChanges = $result.FilesDeleted.Count + $result.FilesCreated.Count + $result.FilesModified.Count + $result.DirectoriesDeleted.Count
            $changesMade = $totalChanges -gt 0
        }
        
        if ($changesMade) {
            Write-Host "  ✓ Migration successful ($totalChanges changes)" -ForegroundColor Green
            $SuccessfulRepos++
            
            # Auto-commit if requested and applied
            if ($Apply -and $AutoCommit) {
                Push-Location $repoPath
                
                # Check if it's a git repo
                $isGit = Test-Path (Join-Path $repoPath ".git")
                
                if ($isGit) {
                    Write-Host "  → Auto-committing changes..." -ForegroundColor Cyan
                    
                    git add .github/ railway.json 2>$null
                    git add -u  # Stage deletions
                    
                    $commitMsg = @"
chore: standardise workflows

- Remove obsolete context generation workflows
- Add standard CI workflows (lint, test, security)
- Add Dependabot configuration
$(if ($repo.Railway) { "- Add Railway CD workflow`n- Add Railway configuration" } else { "" })

Part of SPECTRA workflow standardisation initiative.
Ref: WORKFLOWS-ASSESSMENT-2025-11-29.md
"@
                    
                    git commit -m $commitMsg
                    
                    Write-Host "  ✓ Changes committed" -ForegroundColor Green
                    Write-Host "  → Run 'git push' to deploy" -ForegroundColor Yellow
                } else {
                    Write-Host "  ⚠️  Not a git repository, skipping commit" -ForegroundColor Yellow
                }
                
                Pop-Location
            }
        } else {
            Write-Host "  ✓ No changes needed (already clean)" -ForegroundColor Green
            $SuccessfulRepos++
        }
        
    } catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        $FailedRepos += $repoName
    }
    
    Write-Host ""
}

# Final summary
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                     SUMMARY                                " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "Total repositories: $TotalRepos" -ForegroundColor White
Write-Host "Processed: $ProcessedRepos" -ForegroundColor Cyan
Write-Host "Successful: $SuccessfulRepos" -ForegroundColor Green
Write-Host "Failed: $($FailedRepos.Count)" -ForegroundColor $(if ($FailedRepos.Count -gt 0) { 'Red' } else { 'Green' })
Write-Host "Skipped: $($SkippedRepos.Count)" -ForegroundColor Gray
Write-Host ""

if ($FailedRepos.Count -gt 0) {
    Write-Host "Failed repositories:" -ForegroundColor Red
    $FailedRepos | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host ""
}

if ($SkippedRepos.Count -gt 0) {
    Write-Host "Skipped repositories:" -ForegroundColor Gray
    $SkippedRepos | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    Write-Host ""
}

if (-not $Apply) {
    Write-Host "ℹ️  This was a dry run. Run with -Apply to make changes." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✅ Migration complete!" -ForegroundColor Green
    Write-Host ""
    
    if ($AutoCommit) {
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Review commits in each repository" -ForegroundColor White
        Write-Host "  2. Push to remote: cd into each repo and run 'git push'" -ForegroundColor White
        Write-Host "  3. Monitor CI runs in GitHub Actions" -ForegroundColor White
        Write-Host "  4. Open test PRs to verify workflows" -ForegroundColor White
    } else {
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Review changes: git status in each repo" -ForegroundColor White
        Write-Host "  2. Commit: git add . && git commit (or use -AutoCommit)" -ForegroundColor White
        Write-Host "  3. Push: git push" -ForegroundColor White
        Write-Host "  4. Monitor CI runs" -ForegroundColor White
    }
}

Write-Host ""


