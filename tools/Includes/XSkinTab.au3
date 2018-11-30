
; XSkinTab.au3 January 10, 2007

#include-once
#include <XSkin.au3>
#include <GUIConstants.au3>
#include <_ButtonHover.au3>
;Opt("MustDeclareVars", 1)
;Opt("TrayIconDebug", 1)

Global $XS_tab[1], $TControl[1]
Global $tempID2, $CtrlId2, $tabhold, $Tnumc
Global $Tcount, $Tleft, $Ttop, $Twidth, $Theight

Func XSkinListTabCreate($Tcounter, $TBleft, $TBtop, $TBwidth, $TBheight)
	If $Tcounter = "" Or $Tcounter = "0" Or $Tcounter > 5 Then XSkinTabError("XSkinListTabCreate, $Tcounter must be > 0 and < 5    ")
	$Tcount = $Tcounter
	$Tleft = $TBleft
	$Ttop = $TBtop
	$Twidth = $TBwidth
	$Theight = $TBheight
	ReDim $XS_tab[$Tcount + 1]
	ReDim $TControl[$Tcount + 1]
	$XS_tab[0] = $Tcount
	Local $XS_tabm = GUICtrlCreateDummy()
	Return $XS_tabm
EndFunc   ;==>XSkinListTabCreate

Func XSkinListTabItem($Tnum, $Tname, $Tcolor, $Ttype, $TIconNum = 0, $TIDLL = "shell32.dll")
	If $Tnum = "" Or $Tnum = 0 Or $Tnum > 5 Then XSkinTabError("XSkinListTabItem, $Tnum must be > 0 and < 5    ")
	If $Tnum > $Tcount Then XSkinTabError("XSkinListTabItem, $Tnum (" & $Tnum & ") is greater than XSkinListTabCreate $Tcount (" & $Tcount & ")   ")
	$Tnumc = $Tnumc + 1
	If $Tnumc <> $Tnum Then XSkinTabError("XSkinTabItem, Created in an incorrect order #" & $Tnum & "   ")
	Local $TitemL = $Tleft + 1
	Local $TitemW = $Twidth - 3
	Local $TitemT = $Ttop + (($Tnumc - 1) * 25) + 2
	Local $TitemH = 25
	$XS_tab[$Tnum] = _HoverButton ($Tname, $TitemL, $TitemT, $TitemW, $TitemH, $Tcolor)
	If $TIconNum <> 0 Then GUICtrlCreateIcon($TIDLL, $TIconNum, $TitemL + 5, $TitemT + (($TitemH - 16) / 2), 16, 16)
	If $TIconNum <> 0 Then GUICtrlSetState(-1, $GUI_DISABLE)
	$TitemT = $Ttop + (($XS_tab[0]) * 25) + 2
	$TitemH = $Theight - $TitemT + 37
	If $Ttype = "list" Then
		$TControl[$Tnum] = GUICtrlCreateList("", $TitemL, $TitemT, $TitemW, $TitemH)
		If $Tnum < $XS_tab[0] Then GUICtrlSetState($TControl[$Tnum], $GUI_HIDE)
	ElseIf $Ttype = "Edit" Then
		$TControl[$Tnum] = GUICtrlCreateEdit("", $TitemL, $TitemT, $TitemW, $TitemH)
		If $Tnum < $XS_tab[0] Then GUICtrlSetState($TControl[$Tnum], $GUI_HIDE)
	ElseIf $Ttype = "Label" Then
		$TControl[$Tnum] = GUICtrlCreateLabel("", $TitemL, $TitemT, $TitemW - 1, $TitemH, $SS_SUNKEN)
		GUICtrlSetBkColor($TControl[$Tnum], 0xFFFFFF)
		If $Tnum < $XS_tab[0] Then GUICtrlSetState($TControl[$Tnum], $GUI_HIDE)
	ElseIf $Ttype = "Custom" Then                                 ; ************** Create your own ***** Custom *******
		$TControl[$Tnum] = GUICtrlCreateMonthCal("", $TitemL, $TitemT, $TitemW, $TitemH)
		If $Tnum < $XS_tab[0] Then GUICtrlSetState($TControl[$Tnum], $GUI_HIDE)
	Else
		XSkinTabError("XSkinTabItem, Unknown control ( list, edit, label ) #" & $Tnum & "   ")
	EndIf
	Return $TControl[$Tnum]
EndFunc   ;==>XSkinListTabItem

Func Tabover()
	For $x = 1 To $XS_tab[0]
		If $tabhold <> $XS_tab[$x] And $CtrlId2 And $tempID2 - 1 = $XS_tab[$x] Then
			For $i = 1 To $XS_tab[0]
				GUICtrlSetState($TControl[$i], $GUI_HIDE)
			Next
			GUICtrlSetState($TControl[$x], $GUI_SHOW)
			$tabhold = $XS_tab[$x]
		EndIf
	Next
EndFunc   ;==>Tabover

Func XSkinTabError($XE_msg)
	MsgBox(64, "XSkin Error", $XE_msg, 5)
	Exit
EndFunc   ;==>XSkinTabError

Func XSkinColorTabCreate($XTleft, $XTtop, $XTwidth, $XTlength, $XTcolor)
	Local $XTab1 = GUICtrlCreateTab($XTleft, $XTtop, $XTwidth, $XTlength, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	GUICtrlCreateLabel("", $XTleft + 2, $XTtop + 24, $XTwidth - 6, $XTlength - 28)
	GUICtrlSetBkColor(-1, $XTcolor)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Return $XTab1
EndFunc   ;==>XSkinColorTabCreate