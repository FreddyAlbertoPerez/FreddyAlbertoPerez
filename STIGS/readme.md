# 🛡️ Windows 10 STIG Implementation Using PowerShell

This repository contains PowerShell scripts implementing various Windows 10 STIG (Security Technical Implementation Guide) controls. Each script corresponds to a specific STIG ID and helps automate compliance for security hardening.

---

## Available STIG Implementations

| STIG ID                | Description                                                      | Script File                        |
|------------------------|-----------------------------------------------------------------|----------------------------------|
| WN10-00-000090         | Enforce account lockout threshold to prevent brute-force attacks | `STIG-ID-WN10-00-000090.ps1`     |
| WN10-00-000155         | Configure system inactivity timeout to lock workstation          | `STIG-ID-WN10-00-000155.ps1`     |
| WN10-AC-000005         | Enforce password complexity requirements                         | `STIG-ID-WN10-AC-000005.ps1`     |
| WN10-AC-000020         | Require password history to prevent reuse of recent passwords   | `STIG-ID-WN10-AC-000020.ps1`     |
| WN10-AU-000500         | Enable audit logging of account logon events                    | `STIG-ID-WN10-AU-000500.ps1`     |
| WN10-AU-000505         | Configure retention period for audit logs                        | `STIG-ID-WN10-AU-000505.ps1`     |
| WN10-CC-000005         | Disable insecure protocols (e.g., SMBv1)                         | `STIG-ID-WN10-CC-000005.ps1`     |
| WN10-CC-000040         | Configure Windows Defender Antivirus real-time protection       | `STIG-ID-WN10-CC-000040.ps1`     |
| WN10-CC-000044         | Enforce Windows Firewall to be enabled and configured properly  | `STIG-ID-WN10-CC-000044.ps1`     |
| WN10-CC-000110         | Enforce encryption on removable drives using BitLocker          | `STIG-ID-WN10-CC-000110.ps1`     |
| WN10-CC-000210         | Restrict use of removable media to authorized devices only      | `STIG-ID-WN10-CC-000210.ps1`     |

---

## Example: STIG-ID-WN10-00-000090.ps1

**Description:**  
Enforce account lockout threshold to lock user accounts after a defined number of failed login attempts to mitigate brute-force attacks.

**Example PowerShell snippet:**

```powershell
# Example enforcement for STIG WN10-00-000090
Write-Host "Setting account lockout threshold to 5 invalid attempts..."
secedit /export /cfg C:\secpol.cfg
# Replace LockoutBadCount=0 with LockoutBadCount=5
(gc C:\secpol.cfg) -replace "LockoutBadCount = 0", "LockoutBadCount = 5" | Out-File C:\secpol.cfg -Encoding ascii
secedit /configure /db %windir%\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
Remove-Item C:\secpol.cfg
