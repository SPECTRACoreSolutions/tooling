# Code Snippets for Stream Deck
# Usage: .\code-snippets.ps1 -Snippet "python-function"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("python-function", "python-class", "test-function", "spectra-service", "spectra-activity")]
    [string]$Snippet
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colours for output
$InfoColour = "Cyan"

Write-Host "`nInserting code snippet: $Snippet`n" -ForegroundColor $InfoColour

# Get active window (assumes Cursor/VS Code is active)
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@

# Activate Cursor/VS Code window
$cursorProcess = Get-Process | Where-Object { $_.ProcessName -like "*cursor*" -or $_.ProcessName -like "*Code*" } | Select-Object -First 1
if ($cursorProcess) {
    $hwnd = [Win32]::GetForegroundWindow()
    [Win32]::SetForegroundWindow($cursorProcess.MainWindowHandle)
    Start-Sleep -Milliseconds 200
}

# Define snippets
$snippets = @{
    "python-function" = @"
def function_name():
    """Docstring here."""
    pass
"@
    
    "python-class" = @"
class ClassName:
    """Class docstring."""
    
    def __init__(self):
        """Initialize instance."""
        pass
"@
    
    "test-function" = @"
def test_function_name():
    """Test description."""
    # Arrange
    # Act
    # Assert
    assert True
"@
    
    "spectra-service" = @"
# SPECTRA Service Template
# Service: service-name
# Level: L1-MVP
# Status: In Development

from typing import Dict, Any

def main():
    """Service entry point."""
    pass

if __name__ == "__main__":
    main()
"@
    
    "spectra-activity" = @"
# SPECTRA Activity Template
# Stage: extract
# Activity: activity-name

def execute(context: Dict[str, Any]) -> Dict[str, Any]:
    """Execute activity."""
    # Implementation here
    return context
"@
}

# Get snippet text
$snippetText = $snippets[$Snippet]

if (-not $snippetText) {
    Write-Host "ERROR: Snippet not found" -ForegroundColor "Red"
    exit 1
}

# Use SendKeys to type snippet (requires Windows Forms)
Add-Type -AssemblyName System.Windows.Forms

# Type the snippet
foreach ($line in $snippetText -split "`n") {
    [System.Windows.Forms.SendKeys]::SendWait($line)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Milliseconds 50
}

Write-Host "Snippet inserted!" -ForegroundColor "Green"
Start-Sleep -Seconds 1





