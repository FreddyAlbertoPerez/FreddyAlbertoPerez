<#
.SYNOPSIS
    This Powershell script disables internet connection sharing. 

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-14
    Last Modified   : 2025-05-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000044
.TESTED ON
    Date(s) Tested  : 2025-05-14
    Tested By       : 2025-05-14
    Systems Tested  : 2025-05-14
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000044.ps1 
#>
# Run as Administrator
Write-Output "Checking and Enforcing Internet Connection Sharing Restriction..."

# Define registry path and key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$regName = "NC_ShowSharedAccessUI"
$expectedValue = 0

# Ensure registry path exists
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Output "Created registry path: $regPath"
}

# Apply the policy setting
Set-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -Type DWord
Write-Output "Policy applied: Internet Connection Sharing UI is hidden (disabled)."

# Verify the setting
$currentValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
if ($currentValue -eq $expectedValue) {
    Write-Output "Verification passed: NC_ShowSharedAccessUI is set to 0."
} else {
    Write-Output "Verification failed: NC_ShowSharedAccessUI is set to $currentValue (expected 0)."
}

# Force Group Policy update
gpupdate /force
Write-Output "Group Policy Updated."

# Notify user
Write-Output "A system restart may be required for changes to take full effect."
