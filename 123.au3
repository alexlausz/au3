#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <MenuConstants.au3>
GUIRegisterMsg($WM_COMMAND, "_WM_EXTRACTOR")
GUIRegisterMsg($WM_SYSCOMMAND, "_WM_EXTRACTOR")
GUIRegisterMsg($WM_HSCROLL, "_WM_EXTRACTOR")
$GUI = GUICreate("Test GUI", 200, 200, -1, -1, BitOR($WS_THICKFRAME, $gui_ss_default_gui))
$Button = GUICtrlCreateButton("Test", 20, 20)
$Button2 = GUICtrlCreateButton(" Another Test ", 20, 100)
$Slider = GUICtrlCreateSlider(20, 60, 150)
$hSlider = GUICtrlGetHandle($Slider)
GUISetState()
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $Button
            MsgBox(0, "", "You pressed the button marked TEST")
        Case $Button2
            MsgBox(0, "", "You pressed the button marked 'Another Test'")
    EndSwitch
WEnd
Func _WM_EXTRACTOR($hWnd, $iMsg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0x0000FFFF)
    Local $hCtrl = $lParam
    #forceref $hWnd, $iMsg, $wParam, $lParam
    Switch $iMsg
        Case $WM_HSCROLL
            Switch $lParam
                Case $hSlider
                    ConsoleWrite("+Slider moved to: " & GUICtrlRead($Slider) & @LF)
            EndSwitch
        Case $WM_VSCROLL
        Case $WM_COMMAND
            Switch $nID
                Case $Button
                    ConsoleWrite(">Button Test pressed" & @LF)
                Case $Button2
                    ConsoleWrite(">Button Another Test pressed" & @LF)
                Case Else
                    MsgBox(0, "MY_WM_COMMAND", "GUIHWnd" & @TAB & ":" & $hWnd & @LF & _
                            "MsgID" & @TAB & ":" & $msg & @LF & _
                            "wParam" & @TAB & ":" & $wParam & @LF & _
                            "lParam" & @TAB & ":" & $lParam & @LF & @LF & _
                            "WM_COMMAND - Infos:" & @LF & _
                            "-----------------------------" & @LF & _
                            "Code" & @TAB & ":" & $nNotifyCode & @LF & _
                            "CtrlID" & @TAB & ":" & $nID & @LF & _
                            "CtrlHWnd" & @TAB & ":" & $hCtrl)
            EndSwitch
        Case $WM_SYSCOMMAND
            Switch $wParam
                Case $SC_CLOSE
                    ConsoleWrite("!Exit pressed" & @LF)
                    Exit
                Case $SC_RESTORE
                    ConsoleWrite("!Restore window" & @LF)
                Case $SC_MINIMIZE
                    ConsoleWrite("!Minimize Window" & @LF)
                Case $SC_MOUSEMENU + 3
                    ConsoleWrite("!System menu pressed" & @LF)
                Case $SC_MOVE
                    ConsoleWrite("!System menu Move Option pressed" & @LF)
                    Return 0
                Case $SC_SIZE
                    ConsoleWrite("!System menu Size Option pressed" & @LF)
                    Return 0
                Case $SC_MOUSEMENU + 2 ; This and the following case statements are only valid when the GUI is resizable
                    ConsoleWrite("!Right side of GUI clicked" & @LF)
                    Return 0
                Case $SC_MOUSEMENU + 1
                    ConsoleWrite("!Left side of GUI clicked" & @LF)
                    Return 0
                Case $SC_MOUSEMENU + 8
                    ConsoleWrite("!Lower Right corner of GUI clicked" & @LF)
                    Return 0
                Case $SC_MOUSEMENU + 7
                    ConsoleWrite("!Lower Left corner of GUI clicked" & @LF)
                    Return 0
                Case $SC_MOUSEMENU + 6
                    ConsoleWrite("!Bottom side of GUI clicked" & @LF)
                    Return 0
                Case Else
                    MsgBox(0, "MY_WM_COMMAND", "GUIHWnd" & @TAB & ":" & $hWnd & @LF & _
                            "MsgID" & @TAB & ":" & $msg & @LF & _
                            "wParam" & @TAB & ":" & $wParam & @LF & _
                            "lParam" & @TAB & ":" & $lParam & @LF & @LF & _
                            "WM_COMMAND - Infos:" & @LF & _
                            "-----------------------------" & @LF & _
                            "Code" & @TAB & ":" & $nNotifyCode & @LF & _
                            "CtrlID" & @TAB & ":" & $nID & @LF & _
                            "CtrlHWnd" & @TAB & ":" & $hCtrl)
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_EXTRACTOR