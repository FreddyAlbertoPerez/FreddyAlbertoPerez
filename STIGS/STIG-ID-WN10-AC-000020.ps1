<#
.SYNOPSIS
    This Powershell script enforces 24 unique passwords remembered.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-13
    Last Modified   : 2025-05-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000020 
.TESTED ON
    Date(s) Tested  : 2025-05-13
    Tested By       : 2025-05-13
    Systems Tested  : 2025-05-13
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-AC-000020.ps1 
#>

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Restarting with elevated privileges..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Applying local password policy: enforce 24 unique passwords remembered..."

# Apply the password history setting
try {
    net accounts /uniquepw:24 | Out-Null
    Write-Host "Policy applied: 24 passwords remembered."
} catch {
    Write-Host "Error applying policy: $_"
    exit 1
}
