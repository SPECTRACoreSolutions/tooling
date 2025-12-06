# SPECTRA Cursor Extensions - ACTUAL Cursor Installer
# Fixed: Uses 'cursor' command, not 'code' command

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('essential', 'recommended', 'data', 'all')]
    [string]$Profile = 'essential'
)

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  SPECTRA CURSOR Extensions - Installer (Fixed for Cursor) ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if Cursor CLI is available
$cursorCmd = Get-Command cursor -ErrorAction SilentlyContinue

if (-not $cursorCmd) {
    Write-Host "⚠️  Cursor CLI not found in PATH" -ForegroundColor Yellow
    Write-Host "`nTo enable Cursor CLI:" -ForegroundColor White
    Write-Host "  1. Open Cursor" -ForegroundColor Gray
    Write-Host "  2. Ctrl+Shift+P → 'Shell Command: Install cursor command in PATH'" -ForegroundColor Gray
    Write-Host "  3. Restart PowerShell" -ForegroundColor Gray
    Write-Host "  4. Run this script again`n" -ForegroundColor Gray
    
    Write-Host "OR install manually:" -ForegroundColor Yellow
    Write-Host "  1. Open Cursor" -ForegroundColor Gray
    Write-Host "  2. Ctrl+Shift+X (Extensions)" -ForegroundColor Gray
    Write-Host "  3. Search and install each extension below:`n" -ForegroundColor Gray
    
    # Show list to install manually
    Write-Host "Essential Extensions to Install Manually:" -ForegroundColor Cyan
    Write-Host "  1. Thunder Client          (rangav.vscode-thunder-client)" -ForegroundColor White
    Write-Host "  2. Rainbow CSV             (mechatroner.rainbow-csv)" -ForegroundColor White
    Write-Host "  3. DotENV                  (mikestead.dotenv)" -ForegroundColor White
    Write-Host "  4. GitLens                 (eamodio.gitlens)" -ForegroundColor White
    Write-Host "  5. YAML                    (redhat.vscode-yaml)" -ForegroundColor White
    Write-Host "  6. Python                  (ms-python.python)" -ForegroundColor White
    Write-Host "  7. Pylance                 (ms-python.vscode-pylance)" -ForegroundColor White
    Write-Host "  8. Black Formatter         (ms-python.black-formatter)" -ForegroundColor White
    Write-Host "  9. Markdown All in One     (yzhang.markdown-all-in-one)" -ForegroundColor White
    Write-Host " 10. Docker                  (ms-azuretools.vscode-docker)`n" -ForegroundColor White
    
    exit 1
}

Write-Host "✓ Cursor CLI found: $($cursorCmd.Source)" -ForegroundColor Green
Write-Host "Profile: $Profile" -ForegroundColor Yellow
Write-Host "Quality: Only extensions with >500k downloads or major backing`n" -ForegroundColor Gray

# Extension definitions
$extensions = @{
    essential = @(
        @{ id = "rangav.vscode-thunder-client"; name = "Thunder Client"; downloads = "3M+"; why = "API testing with .env" },
        @{ id = "mechatroner.rainbow-csv"; name = "Rainbow CSV"; downloads = "2M+"; why = "Beautiful CSV viewing" },
        @{ id = "mikestead.dotenv"; name = "DotENV"; downloads = "4M+"; why = ".env syntax highlighting" },
        @{ id = "eamodio.gitlens"; name = "GitLens"; downloads = "25M+"; why = "Git superpowers" },
        @{ id = "redhat.vscode-yaml"; name = "YAML"; downloads = "13M+"; why = "Railway/K8s configs" },
        @{ id = "ms-python.python"; name = "Python"; downloads = "87M+"; why = "Python development" },
        @{ id = "ms-python.vscode-pylance"; name = "Pylance"; downloads = "40M+"; why = "Python IntelliSense" },
        @{ id = "ms-python.black-formatter"; name = "Black Formatter"; downloads = "3M+"; why = "Python formatting" },
        @{ id = "yzhang.markdown-all-in-one"; name = "Markdown All in One"; downloads = "5M+"; why = "Documentation" },
        @{ id = "ms-azuretools.vscode-docker"; name = "Docker"; downloads = "20M+"; why = "Container management" }
    )
    
    recommended = @(
        @{ id = "ms-toolsai.jupyter"; name = "Jupyter"; downloads = "20M+"; why = "Data exploration" },
        @{ id = "mtxr.sqltools"; name = "SQLTools"; downloads = "2M+"; why = "Database queries" },
        @{ id = "humao.rest-client"; name = "REST Client"; downloads = "5M+"; why = "File-based API tests" },
        @{ id = "Gruntfuggly.todo-tree"; name = "Todo Tree"; downloads = "2M+"; why = "Track TODOs" },
        @{ id = "GrapeCity.gc-excelviewer"; name = "Excel Viewer"; downloads = "2M+"; why = "Spreadsheets" },
        @{ id = "donjayamanne.githistory"; name = "Git History"; downloads = "4M+"; why = "Git visualization" },
        @{ id = "oderwat.indent-rainbow"; name = "Indent Rainbow"; downloads = "5M+"; why = "Code readability" },
        @{ id = "aaron-bond.better-comments"; name = "Better Comments"; downloads = "3M+"; why = "Comment highlighting" },
        @{ id = "alefragnani.project-manager"; name = "Project Manager"; downloads = "2M+"; why = "Multi-project work" },
        @{ id = "usernamehw.errorlens"; name = "Error Lens"; downloads = "3M+"; why = "Inline errors" }
    )
    
    data = @(
        @{ id = "ms-toolsai.jupyter"; name = "Jupyter"; downloads = "20M+"; why = "Notebooks" },
        @{ id = "ms-toolsai.jupyter-renderers"; name = "Jupyter Renderers"; downloads = "3M+"; why = "Plot rendering" },
        @{ id = "ms-toolsai.datawrangler"; name = "Data Wrangler"; downloads = "500k+"; why = "Pandas UI" },
        @{ id = "mechatroner.rainbow-csv"; name = "Rainbow CSV"; downloads = "2M+"; why = "CSV visualization" },
        @{ id = "RandomFractalsInc.vscode-data-preview"; name = "Data Preview"; downloads = "500k+"; why = "Multi-format preview" },
        @{ id = "mtxr.sqltools"; name = "SQLTools"; downloads = "2M+"; why = "Database client" },
        @{ id = "rangav.vscode-thunder-client"; name = "Thunder Client"; downloads = "3M+"; why = "API testing" },
        @{ id = "GrapeCity.gc-excelviewer"; name = "Excel Viewer"; downloads = "2M+"; why = "Excel files" },
        @{ id = "charliermarsh.ruff"; name = "Ruff"; downloads = "1M+"; why = "Fast Python linter" }
    )
}

# Combine profiles if 'all' selected
if ($Profile -eq 'all') {
    $toInstall = ($extensions['essential'] + $extensions['recommended'] + $extensions['data']) | 
        Sort-Object -Property id -Unique
} else {
    $toInstall = $extensions[$Profile]
}

Write-Host "Installing $($toInstall.Count) extensions to CURSOR...`n" -ForegroundColor White

$installed = 0
$failed = 0
$skipped = 0

foreach ($ext in $toInstall) {
    Write-Host "[$($installed + $failed + $skipped + 1)/$($toInstall.Count)] " -NoNewline -ForegroundColor Cyan
    Write-Host "$($ext.name)" -NoNewline -ForegroundColor White
    Write-Host " ($($ext.downloads))" -ForegroundColor Gray
    Write-Host "  → $($ext.why)" -ForegroundColor DarkGray
    
    try {
        # Use 'cursor' command instead of 'code'
        $output = cursor --install-extension $ext.id 2>&1 | Out-String
        
        if ($output -match "already installed") {
            Write-Host "  ✓ Already installed" -ForegroundColor Yellow
            $skipped++
        }
        elseif ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Installed" -ForegroundColor Green
            $installed++
        }
        else {
            Write-Host "  ✗ Failed" -ForegroundColor Red
            $failed++
        }
    }
    catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
        $failed++
    }
    
    Start-Sleep -Milliseconds 300
    Write-Host ""
}

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Installation Complete!                                   ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Summary:" -ForegroundColor White
Write-Host "  ✓ Extensions processed: $($toInstall.Count)" -ForegroundColor Gray
Write-Host "  ✓ Newly installed: $installed" -ForegroundColor Green
Write-Host "  ✓ Already installed: $skipped" -ForegroundColor Yellow
if ($failed -gt 0) {
    Write-Host "  ✗ Failed: $failed" -ForegroundColor Red
}

Write-Host "`nExtensions installed to:" -ForegroundColor Cyan
Write-Host "  $env:USERPROFILE\.cursor\extensions\" -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Extensions are active immediately (no restart needed)" -ForegroundColor White
Write-Host "  2. Try Thunder Client: Ctrl+Shift+P → 'Thunder Client'" -ForegroundColor White
Write-Host "  3. Try Rainbow CSV: Open any .csv file in Data/" -ForegroundColor White
Write-Host "  4. Check installed: Ctrl+Shift+X → Extensions panel" -ForegroundColor White

Write-Host "`nProfiles available:" -ForegroundColor Cyan
Write-Host "  .\install-cursor-extensions.ps1 -Profile essential    (10 extensions)" -ForegroundColor Gray
Write-Host "  .\install-cursor-extensions.ps1 -Profile recommended  (10 more)" -ForegroundColor Gray
Write-Host "  .\install-cursor-extensions.ps1 -Profile data         (9 data tools)" -ForegroundColor Gray
Write-Host "  .\install-cursor-extensions.ps1 -Profile all          (All above)" -ForegroundColor Gray

Write-Host "`nFor full list, see: Core/tooling/cursor-extensions-curated.md`n" -ForegroundColor Cyan

