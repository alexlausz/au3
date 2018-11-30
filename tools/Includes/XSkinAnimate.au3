
#include-once
#cs
#include <GUIConstants.au3>
Dim $repeat = 1
$hwnd = GUICreate("XSkin Animate", 300, 300)

$ret = XSkinAnimate($hwnd, 1, $repeat)
Sleep(2000)

While $repeat <= 28 ;*********** will error - for testing
	$repeat += 1
	XSkinAnimate($hwnd, "", $repeat)
	
	Sleep(1000)
	
	$repeat += 1
	XSkinAnimate($hwnd, "", $repeat)
	Sleep(1000)
WEnd
#ce



Func XSkinAnimate($Xwnd, $Xstate = 1, $Xstyle = 0, $Xtrans = 0, $Xspeed = 1000)
	; $Xstate  - 1 = Show, 2 = Hide, "" = No State Set
	; $Xstyle - 1=Fade, 3=Explode, 5=L-Slide, 7=R-Slide, 9=T-Slide, 11=B-Slide, 13=TL-Diag-Slide, 15=TR-Diag-Slide, 17=BL-Diag-Slide, 19=BR-Diag-Slide
	Local $Xpick = StringSplit('80000,90000,40010,50010,40001,50002,40002,50001,40004,50008,40008,50004,40005,5000a,40006,50009,40009,50006,4000a,50005', ",")
	If Not WinExists($Xwnd) Then XSkinAnError("XSkinAnimate, $Xwnd - Window not found   ")
	If $Xstyle > $Xpick[0] Then XSkinAnError("XSkinAnimate, $Xstyle max is 19  ")
	If $Xstyle <> 0 Then Local $ret = DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Xwnd, "int", $Xspeed, "long", "0x000" & $Xpick[$Xstyle])
	If $Xtrans <> 0 Then WinSetTrans($Xwnd, "", $Xtrans)
	If $Xstate = 1 Then GUISetState(@SW_SHOW, $Xwnd)
	If $Xstate = 2 Then GUISetState(@SW_HIDE, $Xwnd)
	If $Xstyle <> 0 Then Return $ret
EndFunc   ;==>XSkinAnimate

Func XSkinAnError($XE_msg)
	MsgBox(262208, "XSkin Error", $XE_msg, 5)
	Exit
EndFunc   ;==>XSkinAnError
