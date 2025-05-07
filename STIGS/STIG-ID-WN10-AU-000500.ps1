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
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-05-07
    Tested By       : 2025-05-07
    Systems Tested  : 2025-05-07
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# Define base registry keys
$baseKey = "HKLM:\SOFTWARE\Policies\Microsoft"
$eventLogKey = "$baseKey\Windows\EventLog"
$appKey = "$eventLogKey\Application"
$valueName = "MaxSize"
$minValue = 32768

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

# Step 3: Ensure Application key exists
if (-not (Test-Path $appKey)) {
    New-Item -Path $eventLogKey -Name "Application" -Force | Out-Null
    Write-Output "Created key: Application"
}

# Step 4: Check and set the MaxSize value
$currentValue = Get-ItemProperty -Path $appKey -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # Value does not exist, create it
    New-ItemProperty -Path $appKey -Name $valueName -PropertyType DWord -Value $minValue -Force | Out-Null
    Write-Output "Created MaxSize and set to $minValue."
} elseif ($currentValue.$valueName -lt $minValue) {
    # Value exists but is too small, update it
    Set-ItemProperty -Path $appKey -Name $valueName -Value $minValue
    Write-Output "Updated MaxSize to $minValue (was $($currentValue.$valueName))."
} else {
    Write-Output "Compliant: MaxSize is set to $($currentValue.$valueName), which is >= $minValue."
}

