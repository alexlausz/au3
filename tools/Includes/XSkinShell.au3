
; XSkinShell.au3 Ver 1.0.0

#include <GUIConstants.au3>
#include-once
;#include <XSkin.au3>
;Opt("MustDeclareVars", 1)

Func XSkinReSize($XRS_Program, $XSR_Width, $XSR_Height)
	Local $XSPID, $XhWnd = 0, $XstPID = DllStructCreate("int"), $XSWinList, $XSdll, $XPID
	$XSPID = Run($XRS_Program, '', @SW_HIDE)
	Do
		$XSWinList = WinList()
		For $i = 1 To $XSWinList[0][0]
			If $XSWinList[$i][0] <> "" Then
				DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $XSWinList[$i][1], "ptr", DllStructGetPtr($XstPID))
				If DllStructGetData($XstPID, 1) = $XSPID Then
					$XhWnd = $XSWinList[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
		Sleep(20)
	Until $XhWnd <> 0
	$XSdll = ""
	$XstPID = 0
	If $XhWnd <> 0 Then
		WinMove($XhWnd, "", 200, 200, $XSR_Width, $XSR_Height)
		Sleep(100)
		WinClose($XhWnd)
	EndIf
EndFunc   ;==>XSkinReSize

Func XSkinRun($XR_Title, $XR_Program = "") ; thanks holger
	If $XR_Program = "" Then Return
	Local $XhWnd = 0, $XstPID = DllStructCreate("int"), $XSWinList, $XhWinSize, $XSdll, $XPID, $XPID2, $XR_Ret[3], $Xh_ret, $oxStyle, $ostyle
	$XPID = Run($XR_Program, '', @SW_HIDE)
	Do
		$XSWinList = WinList()
		For $i = 1 To $XSWinList[0][0]
			If $XSWinList[$i][0] <> "" Then
				DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $XSWinList[$i][1], "ptr", DllStructGetPtr($XstPID))
				If DllStructGetData($XstPID, 1) = $XPID Then
					$XhWnd = $XSWinList[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
		Sleep(20)
	Until $XhWnd <> 0
	$XSdll = ""
	$XstPID = 0
	If $XhWnd <> 0 Then
		$XhWinSize = WinGetPos($XhWnd)
		$XPID2 = XSkinGUICreate ( $XR_Title, ($XhWinSize[2]) + ($tile_size * 2) , ($XhWinSize[3]) + ($tile_size * 2), $Skin_Folder)
		If FileExists($Icon_Folder) Then $Xh_ret = XSkinIcon ($XPID2)
		$oxStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $XPID2, "int", -16)
		DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $XPID2, "int", -16, "long", BitOR($oxStyle[0], $WS_CLIPCHILDREN))
		$ostyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $XhWnd, "int", -16)
		DllCall("user32.dll", "int", "SetParent", "hwnd", $XhWnd, "hwnd", $XPID2)
		DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $XhWnd, "int", -16, "long", BitOR($WS_POPUP, $WS_CHILD, $WS_VISIBLE, $WS_CLIPSIBLINGS))
		GUISetState()
		WinMove($XhWnd, "", $tile_size, $tile_size)
		WinSetState($XhWnd, "", @SW_SHOW)
		WinActivate($XhWnd)
		$XR_Ret[0] = $XPID2
		$XR_Ret[1] = $XhWnd
		$XR_Ret[2] = $Xh_ret[1]
		Return $XR_Ret
	EndIf
EndFunc   ;==>XSkinRun

Func XSkinExplore($XSI_Title, $XSI_Location, $XSI_Width, $XSI_Height)
	Local $oXIE, $XSI_Ret[3], $XSI_but, $XSI_gui, $oXActiveX
	$oXIE = ObjCreate("Shell.Explorer.2")
	$XSI_gui = XSkinGUICreate ($XSI_Title, $XSI_Width + ($tile_size * 2), $XSI_Height + ($tile_size * 2), $Skin_Folder)
	If FileExists($Icon_Folder) Then $XSI_but = XSkinIcon ($XSI_gui)
	$oXActiveX = GUICtrlCreateObj($oXIE, $tile_size, $tile_size, $XSI_Width, $XSI_Height)
	$oXIE.navigate ($XSI_Location)
	GUISetState()
	$XSI_Ret[1] = $XSI_Ret[0]
	$XSI_Ret[2] = $XSI_but[1]
	Return $XSI_Ret
EndFunc   ;==>XSkinExplore
