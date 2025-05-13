<#
.SYNOPSIS
    This Powershell script ensures passwords never expire is unchecked for all active accounts.  

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-13
    Last Modified   : 2025-05-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000090 
.TESTED ON
    Date(s) Tested  : 2025-05-13
    Tested By       : 2025-05-13
    Systems Tested  : 2025-05-13
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-00-000090.ps1 
#>
# This script ensures that "Password never expires" is unchecked for all local user accounts.

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

# Get all active local user accounts
$users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }

# Loop through each user and ensure "Password never expires" is unchecked
foreach ($user in $users) {
    Write-Host "Configuring password expiration for user: $($user.Name)" -ForegroundColor Cyan
    
    # Ensure the "Password never expires" option is unchecked
    Set-LocalUser -Name $user.Name -PasswordNeverExpires $false
    
    Write-Host "Password expiration set for user: $($user.Name)" -ForegroundColor Green
}

Write-Host "All user passwords are now configured to expire." -ForegroundColor Green
