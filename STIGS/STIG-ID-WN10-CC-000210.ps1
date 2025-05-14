<#
.SYNOPSIS
    This Powershell script enables Windows Defender SmartScreen for Explorer.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-14
    Last Modified   : 2025-05-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000210
.TESTED ON
    Date(s) Tested  : 2025-05-14
    Tested By       : 2025-05-14
    Systems Tested  : 2025-05-14
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-CC-000210.ps1 
#>
# Run as Administrator
Write-Output "Starting SmartScreen Registry Enforcement (No ELSE, One Entry at a Time)..."

# Define registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Output "Created registry path: $regPath"
}

# Detect Windows release version
$releaseId = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
Write-Output "Detected OS Release ID: $releaseId"

# ---- Apply EnableSmartScreen based on OS version ----
if ($releaseId -eq "1507") {
    Set-ItemProperty -Path $regPath -Name "EnableSmartScreen" -Value 2 -Type DWord
    Write-Output "Set EnableSmartScreen = 2 (for Windows 10 v1507 LTSB)"
}

if ($releaseId -ne "1507") {
    Set-ItemProperty -Path $regPath -Name "EnableSmartScreen" -Value 1 -Type DWord
    Write-Output "Set EnableSmartScreen = 1"
}

# ---- Set ShellSmartScreenLevel if not 1507 or 1607 ----
if (($releaseId -ne "1507") -and ($releaseId -ne "1607")) {
    Set-ItemProperty -Path $regPath -Name "ShellSmartScreenLevel" -Value "Block" -Type String
    Write-Output "Set ShellSmartScreenLevel = Block"
}

# ---- Final: Group Policy Update ----
gpupdate /force
Write-Output "Group Policy Updated. A restart may be required for full enforcement."
