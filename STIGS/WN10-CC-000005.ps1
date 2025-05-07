<#
.SYNOPSIS
    Camera access from the lock screen must be disabled.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-07
    Last Modified   : 2025-05-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005
.TESTED ON
    Date(s) Tested  : 2025-05-07
    Tested By       : 2025-05-07
    Systems Tested  : 2025-05-07
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000005.ps1 
#>


# Define registry keys and target value
$baseKey = "HKLM:\SOFTWARE\Policies\Microsoft"
$personalizationKey = "$baseKey\Windows\Personalization"
$valueName = "NoLockScreenCamera"
$expectedValue = 1

# Step 1: Ensure Windows key exists
if (-not (Test-Path "$baseKey\Windows")) {
    New-Item -Path $baseKey -Name "Windows" -Force | Out-Null
    Write-Output "Created key: Windows"
}

# Step 2: Ensure Personalization key exists
if (-not (Test-Path $personalizationKey)) {
    New-Item -Path "$baseKey\Windows" -Name "Personalization" -Force | Out-Null
    Write-Output "Created key: Personalization"
}

# Step 3: Check and set the NoLockScreenCamera value
$currentValue = Get-ItemProperty -Path $personalizationKey -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # Value does not exist, create it
    New-ItemProperty -Path $personalizationKey -Name $valueName -PropertyType DWord -Value $expectedValue -Force | Out-Null
    Write-Output "Created NoLockScreenCamera and set to $expectedValue."
} elseif ($currentValue.$valueName -ne $expectedValue) {
    # Value exists but is not set to 1, update it
    Set-ItemProperty -Path $personalizationKey -Name $valueName -Value $expectedValue
    Write-Output "Updated NoLockScreenCamera to $expectedValue (was $($currentValue.$valueName))."
} else {
    Write-Output "Compliant: NoLockScreenCamera is set to $($currentValue.$valueName)."
}


