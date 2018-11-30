#include-once
#include <GUIConstants.au3>
;Opt("MustDeclareVars", 1)

; ver 1.0.0
; $h_ToolBar = XSkinToolBarCreate($Xh_Gui, $tool_left, $tool_top, $tool_width, $tool_bkcolor = "")
; XSkinToolBarButton($iNumber, $iDLL = "shell32.dll")
; XSkinToolBarSeparator()

Global $TBcnt = -1

Func XSkinToolBarCreate($Xh_Gui, $tool_left, $tool_top, $tool_width, $tool_bkcolor = "")
	Local $Xh_ToolBar
	$Xh_ToolBar = GUICreate("", $tool_width, 24, $tool_left, $tool_top, $WS_CHILD, $WS_EX_STATICEDGE, $Xh_Gui)
	If $tool_bkcolor <> "" Then GUISetBkColor($tool_bkcolor, $Xh_ToolBar)
	Return $Xh_ToolBar
EndFunc   ;==>XSkinToolBarCreate

Func XSkinToolBarButton($iNumber, $iDLL = "shell32.dll")
	Local $Xhadd, $TBBleft
	$TBcnt = $TBcnt + 1
	$TBBleft = $TBcnt * 24
	$Xhadd = GUICtrlCreateButton("", $TBBleft, 1, 24, 24, $BS_ICON)
	GUICtrlSetImage($Xhadd, $iDLL, $iNumber, 0)
	Return $Xhadd
EndFunc   ;==>XSkinToolBarButton

Func XSkinToolBarSeparator()
	Local $TBBleft
	$TBcnt = $TBcnt + .5
	$TBBleft = $TBcnt * 24
	GUICtrlCreateLabel("", $TBBleft + 17, 2, 2, 22, $SS_ETCHEDVERT)
EndFunc   ;==>XSkinToolBarSeparator



