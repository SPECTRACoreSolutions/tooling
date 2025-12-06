# SPECTRA Essential Extensions - Quick Install
# Installs the curated, community-backed extensions for SPECTRA workflow
# Quality threshold: >500k downloads OR >1k GitHub stars OR official

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('essential', 'recommended', 'data', 'all')]
    [string]$Profile = 'essential'
)

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  SPECTRA Cursor Extensions - Community Curated Installer  ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Profile: $Profile" -ForegroundColor Yellow
Write-Host "Quality: Only extensions with >500k downloads or major backing`n" -ForegroundColor Gray

# Extension definitions with metrics
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
    $toInstall = $extensions['essential'] + $extensions['recommended'] + $extensions['data'] | Select-Object -Unique -Property id
} else {
    $toInstall = $extensions[$Profile]
}

Write-Host "Installing $($toInstall.Count) extensions...`n" -ForegroundColor White

$installed = 0
$failed = 0

foreach ($ext in $toInstall) {
    Write-Host "[$($installed + 1)/$($toInstall.Count)] " -NoNewline -ForegroundColor Cyan
    Write-Host "$($ext.name)" -NoNewline -ForegroundColor White
    Write-Host " ($($ext.downloads))" -ForegroundColor Gray
    Write-Host "  → $($ext.why)" -ForegroundColor DarkGray
    
    try {
        $result = code --install-extension $ext.id 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Installed" -ForegroundColor Green
            $installed++
        } else {
            Write-Host "  ✗ Failed or already installed" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
        $failed++
    }
    
    Write-Host ""
}

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Installation Complete!                                   ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Summary:" -ForegroundColor White
Write-Host "  ✓ Extensions processed: $($toInstall.Count)" -ForegroundColor Gray
Write-Host "  ✓ Successfully installed: $installed" -ForegroundColor Green
if ($failed -gt 0) {
    Write-Host "  ✗ Failed: $failed" -ForegroundColor Red
}

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Restart Cursor to activate new extensions" -ForegroundColor White
Write-Host "  2. Try Thunder Client: Ctrl+Shift+P → 'Thunder Client'" -ForegroundColor White
Write-Host "  3. Try Rainbow CSV: Open any .csv file" -ForegroundColor White
Write-Host "  4. Configure extensions as needed" -ForegroundColor White

Write-Host "`nProfiles available:" -ForegroundColor Cyan
Write-Host "  .\install-spectra-extensions.ps1 -Profile essential    (10 extensions, fastest)" -ForegroundColor Gray
Write-Host "  .\install-spectra-extensions.ps1 -Profile recommended  (10 more extensions)" -ForegroundColor Gray
Write-Host "  .\install-spectra-extensions.ps1 -Profile data         (9 data tools)" -ForegroundColor Gray
Write-Host "  .\install-spectra-extensions.ps1 -Profile all          (All of the above)" -ForegroundColor Gray

Write-Host "`nFor full list, see: Core/tooling/cursor-extensions-curated.md`n" -ForegroundColor Cyan

