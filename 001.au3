#region --- Au3Recorder generated code Start (v3.3.9.5 KeyboardLayout=00000804)  ---

#region --- Internal functions Au3Recorder Start ---
Func _Au3RecordSetup()
Opt('WinWaitDelay',100)
Opt('WinDetectHiddenText',1)
Opt('MouseCoordMode',0)
Local $aResult = DllCall('User32.dll', 'int', 'GetKeyboardLayoutNameW', 'wstr', '')
If $aResult[1] <> '00000804' Then
  MsgBox(64, 'Warning', 'Recording has been done under a different Keyboard layout' & @CRLF & '(00000804->' & $aResult[1] & ')')
EndIf

EndFunc

Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc

_AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---

_WinWaitActivate("佰赢资产_分机号总表_backup.xlsx - Excel","")
;MouseClick("left",499,10,1)
Send("{CTRLDOWN}c{CTRLUP}")
_WinWaitActivate("OK-CC呼叫中心系统 - Google Chrome","")
MouseClick("left",1106,218,1)
MouseClick("left",866,261,2)
Send("{CTRLDOWN}v{CTRLUP}")
MouseClick("left",838,495,1)
_WinWaitActivate("佰赢资产_分机号总表_backup.xlsx - Excel","")
MouseClick("left",242,10,1)
Send("{RIGHT}{CTRLDOWN}c{CTRLUP}")
_WinWaitActivate("OK-CC呼叫中心系统 - Google Chrome","")
MouseClick("left",1090,350,1)
MouseClick("left",588,316,2)

#endregion --- Au3Recorder generated code End ---
