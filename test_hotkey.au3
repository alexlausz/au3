#include <MsgBoxConstants.au3>
#include <GUIConstants.au3>

; Press Esc to terminate script, Pause/Break to "pause"
Global $g_bPaused = False

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("^g", "AutoDo") ; Shift-Alt-d

While 1
    Sleep(100)
WEnd

Func TogglePause()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
    Exit
EndFunc   ;==>Terminate

Func AutoDo()
   ;MsgBox($MB_SYSTEMMODAL, "循环处理任务", "任务将在5秒内启动...", 3)
   ;Sleep(3000)
   ; == GUI generated with Koda ==
   GUICreate("自动操作任务", 500, 200, 200, 125)
   ;$idCancelBtn = GUICtrlCreateButton("取消", 210, 150, 75, 25)
   $Label = GUICtrlCreateLabel("", 100, 70, 300, 50, $SS_CENTER)

   GUICtrlSetFont(-1, 12, 400, 0)
   GUISetState(@SW_SHOW)
   While 1
	  For $i = 20 to 0 Step -1
	  GUICtrlSetData($Label, "自动操作任务将在 " & $i & " 秒内启动..." & @CRLF & @CRLF & "要取消任务请按 ESC 键！ ")
	  Sleep(500)
	   Next
	   ;GUICtrlSetData($Label, "开始")
	   ;Sleep(2000)
	   ExitLoop
	;WEnd
   ;While 1


   WEnd

   Local $hWnd = WinExists("佰赢资产_分机号总表_backup.xlsx - Excel")
   If @error Then
	  MsgBox(0, "", "未捕获到窗口")
	  Exit
   EndIf
   Local $Chrome = WinExists("OK-CC呼叫中心系统 - Google Chrome")
   If @error Then
	  MsgBox(0, "", "未捕获到Chrome窗口")
	  Exit
   EndIf
   Local $i = 0
   While $i <= 10
	  ;WinActive($hWnd)
	  ;MouseClick("left",1674,10,1)
	  Sleep(250)
	  Send("{CTRLDOWN}")
	  Sleep(50)
	  Send("c")
	  Sleep(50)
	  Send("{CTRLUP}")
	  Sleep(250)
	  WinActive($Chrome)
	  Sleep(250)
	  MouseClick("left",1085,226,1)
	  Sleep(250)
	  MouseClick("left",877,264,1)
	  Sleep(250)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(250)
	  ;Send("{CTRLDOWN}v{CTRLUP}")
	  Send("{CTRLDOWN}")
	  Sleep(50)
	  Send("v")
	  Sleep(50)
	  Send("{CTRLUP}")
	  Sleep(250)
	  MouseClick("left",841,491,1)
	  Sleep(250)
	  WinActive($hWnd)
	  MouseClick("left",1674,10,1)
	  Sleep(250)
	  Send("{RIGHT}")
	  Sleep(500)
	  ;Send("{CTRLDOWN}c{CTRLUP}")
	  Send("{CTRLDOWN}")
	  Sleep(50)
	  Send("c")
	  Sleep(50)
	  Send("{CTRLUP}")
	  Sleep(250)
	  WinActive($Chrome)
	  MouseClick("left",719,10,1)
	  Sleep(250)
	  MouseClick("left",1084,347,1)
	  Sleep(250)
	  MouseClick("left",540,322,1)
	  Sleep(250)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  Send("{BACKSPACE}")
	  Sleep(100)
	  ;Send("{CTRLDOWN}v{CTRLUP}")
	  Send("{CTRLDOWN}")
	  Sleep(50)
	  Send("v")
	  Sleep(50)
	  Send("{CTRLUP}")
	  Sleep(250)
	  MouseClick("left",723,920,1)
	  Sleep(250)
	  WinActive($hWnd)
	  MouseClick("left",1674,10,1)
	  Sleep(250)
	  Send("{DOWN}")
	  Sleep(250)
	  Send("{LEFT}")
	  Sleep(250)
	  $i = $i + 1
   WEnd

EndFunc   ;==>ShowMessage
