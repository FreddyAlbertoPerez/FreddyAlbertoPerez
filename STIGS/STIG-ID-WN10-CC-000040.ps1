<#
.SYNOPSIS
    This Powershell script disables insecure logons to an SMB server.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-14
    Last Modified   : 2025-05-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000040
.TESTED ON
    Date(s) Tested  : 2025-05-14
    Tested By       : 2025-05-14
    Systems Tested  : 2025-05-14
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000040.ps1 
#>

# Run as Administrator
Write-Output "Checking and Enforcing Insecure Guest Logon Policy..."

# Define registry path and key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$regName = "AllowInsecureGuestAuth"
$expectedValue = 0

# Skip enforcement on Windows 10 LTSB v1507
$winVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
if ($winVer -eq "1507") {
    Write-Output "Windows 10 v1507 LTSB detected. This setting is not applicable."
    return
}

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Output "Created registry path: $regPath"
}

# Set the policy value
Set-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -Type DWord
Write-Output "Policy applied: Insecure guest logons are disabled."

# Verify the setting
$currentValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($currentValue -eq $expectedValue) {
    Write-Output "Verification passed: AllowInsecureGuestAuth is set to 0 (disabled)."
} else {
    Write-Output "Verification failed: AllowInsecureGuestAuth is set to $currentValue (expected 0)."
}

# Group Policy update
gpupdate /force
Write-Output "Group Policy Updated."

# Inform user
Write-Output "Restart may be required for full effect."
