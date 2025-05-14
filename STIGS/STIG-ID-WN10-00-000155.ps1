<#
.SYNOPSIS
    This Powershell script disables Windows PowerShell 2.0 feature on the system.

.NOTES
    Author          : Freddy Perez
    LinkedIn        : https://www.linkedin.com/in/freddy-perez/
    GitHub          : https://github.com/freddyalbertoperez
    Date Created    : 2025-05-14
    Last Modified   : 2025-05-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000155
.TESTED ON
    Date(s) Tested  : 2025-05-14
    Tested By       : 2025-05-14
    Systems Tested  : 2025-05-14
    PowerShell Ver. : 5.1

.USAGE
    PS C:\> .\STIG-ID-WN10-00-000155.ps1
#>
# Run as Administrator
Write-Output "Starting PowerShell 2.0 removal..."

# Disable PowerShell V2 Root first — this disables both V2 and V2Root
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart -ErrorAction SilentlyContinue
Write-Output "Sent command to disable MicrosoftWindowsPowerShellV2Root..."

Start-Sleep -Seconds 3

# Confirm status of V2
$powershellV2 = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
if ($powershellV2.State -eq "Enabled") {
    Write-Output "PowerShell V2 still enabled. Attempting to disable explicitly..."
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 -NoRestart -ErrorAction SilentlyContinue
    Write-Output "Sent command to disable MicrosoftWindowsPowerShellV2..."
}

Start-Sleep -Seconds 2

# Final verification
$powershellV2 = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
$powershellV2Root = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root

Write-Output "Status after disable attempt:"
Write-Output "MicrosoftWindowsPowerShellV2      : $($powershellV2.State)"
Write-Output "MicrosoftWindowsPowerShellV2Root  : $($powershellV2Root.State)"

Write-Output "`n✅ PowerShell 2.0 should now be disabled. Please restart your system to finalize."
