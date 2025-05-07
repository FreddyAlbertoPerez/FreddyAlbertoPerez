<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-07
    Last Modified   : 2025-05-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 2025-05-07
    Tested By       : 2025-05-07
    Systems Tested  : 2025-05-07
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000505.ps1 
#>

# Define registry keys and target value
$baseKey = "HKLM:\SOFTWARE\Policies\Microsoft"
$eventLogKey = "$baseKey\Windows\EventLog"
$securityKey = "$eventLogKey\Security"
$valueName = "MaxSize"
$minValue = 1024000

# Step 1: Ensure Windows key exists
if (-not (Test-Path "$baseKey\Windows")) {
    New-Item -Path $baseKey -Name "Windows" -Force | Out-Null
    Write-Output "Created key: Windows"
}

# Step 2: Ensure EventLog key exists
if (-not (Test-Path $eventLogKey)) {
    New-Item -Path "$baseKey\Windows" -Name "EventLog" -Force | Out-Null
    Write-Output "Created key: EventLog"
}

# Step 3: Ensure Security key exists
if (-not (Test-Path $securityKey)) {
    New-Item -Path $eventLogKey -Name "Security" -Force | Out-Null
    Write-Output "Created key: Security"
}

# Step 4: Check and set the MaxSize value
$currentValue = Get-ItemProperty -Path $securityKey -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # Value does not exist, create it
    New-ItemProperty -Path $securityKey -Name $valueName -PropertyType DWord -Value $minValue -Force | Out-Null
    Write-Output "Created MaxSize and set to $minValue."
} elseif ($currentValue.$valueName -lt $minValue) {
    # Value exists but is too small, update it
    Set-ItemProperty -Path $securityKey -Name $valueName -Value $minValue
    Write-Output "Updated MaxSize to $minValue (was $($currentValue.$valueName))."
} else {
    Write-Output "Compliant: MaxSize is set to $($currentValue.$valueName), which is >= $minValue."
}

# Reminder for ISSO documentation
Write-Output "NOTE: If this system forwards audit logs directly to a server, this check is NA and must be documented with the ISSO."
