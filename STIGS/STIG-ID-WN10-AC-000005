<#
.SYNOPSIS
    This Powershell script sets the Account Lockout Duration to 15 minutes via secedit. 

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-13
    Last Modified   : 2025-05-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005 
.TESTED ON
    Date(s) Tested  : 2025-05-13
    Tested By       : 2025-05-13
    Systems Tested  : 2025-05-13
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000005.ps1 
#>
# Requires: Run as Administrator

# Function to check for administrative privileges
function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Relaunch script as Administrator if not already
if (-not (Test-IsAdmin)) {
    Write-Host "Not running as Administrator. Relaunching..." -ForegroundColor Yellow
    Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Setting Account Lockout Policy..." -ForegroundColor Cyan

# Set Lockout Duration to 15 minutes
Start-Process cmd -ArgumentList "/c net accounts /lockoutduration:15" -Wait

# Set Lockout Threshold to 5 failed attempts
Start-Process cmd -ArgumentList "/c net accounts /lockoutthreshold:5" -Wait

# Set Lockout Window (observation period) to 15 minutes
Start-Process cmd -ArgumentList "/c net accounts /lockoutwindow:15" -Wait

# Optional: Display current policy to confirm
Write-Host "Current Lockout Policy:" -ForegroundColor Green
$output = cmd /c "net accounts"
$output | Select-String "lockout"

Write-Host "Lockout policy updated successfully." -ForegroundColor Green
