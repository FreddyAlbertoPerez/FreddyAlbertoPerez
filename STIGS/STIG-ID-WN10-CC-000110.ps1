<#
.SYNOPSIS
    This Powershell script disables printing over HTTP.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-14
    Last Modified   : 2025-05-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110
.TESTED ON
    Date(s) Tested  : 2025-05-13
    Tested By       : 2025-05-13
    Systems Tested  : 2025-05-13
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000110.ps1 
#>

# Run as Administrator
Write-Output "Starting HTTP Printing Disable Enforcement..."

# Define the registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$parentPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT"

# Ensure registry paths exist
if (!(Test-Path $parentPath)) {
    New-Item -Path $parentPath -Force | Out-Null
}
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply policy setting to disable HTTP printing
Set-ItemProperty -Path $regPath -Name "DisableHTTPPrinting" -Value 1 -Type DWord
Write-Output "Registry Setting Applied: HTTP Printing Disabled"

# Force Group Policy update
gpupdate /force
Write-Output "Group Policy Updated"

# Verify registry change
$confirmSetting = Get-ItemProperty -Path $regPath -Name "DisableHTTPPrinting"
Write-Output "HTTP Printing Disabled: $($confirmSetting.DisableHTTPPrinting)"

# OPTIONAL: Check applied policies (not strictly necessary for this setting)
Write-Output "Checking Group Policy Application..."
gpresult /r | Out-File C:\Windows\Temp\GPResult.txt
Write-Output "Policy report saved to C:\Windows\Temp\GPResult.txt"

Write-Output "Restart Required for Full Enforcement"
