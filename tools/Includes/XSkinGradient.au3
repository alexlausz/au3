
#include-once
#include <Color.au3>
#include <GUIConstants.au3>

#cs Demo
#include <XSkin.au3>

$Skin_Folder = @ScriptDir & "\Skins\Defacto"
$XSkinGui = XSkinGUICreate("Gradient Demo", 400, 450, $Skin_Folder)

$Back_Color = XSkinGradient($XSkinGui, $btn_color, $bkg_color)
GUISetState()

While 1
    $msg = GUIGetMsg()
    If $msg = -3 Then Exit
Wend

#ce

Func XSkinGradient($nXSkinGUI, $nStartColor, $nEndColor)
    Local $nSize = WinGetClientSize($nXSkinGUI)
	Local $nX=0, $nY=0, $nWidth=$nSize[0], $nHeight=$nSize[1]
	Local $color1R = _ColorGetRed($nStartColor)
    Local $color1G = _ColorGetGreen($nStartColor)
    Local $color1B = _ColorGetBlue($nStartColor)
    Local $nStepR = (_ColorGetRed($nEndColor) - $color1R) / $nHeight
    Local $nStepG = (_ColorGetGreen($nEndColor) - $color1G) / $nHeight
    Local $nStepB = (_ColorGetBlue($nEndColor) - $color1B) / $nHeight
    Local $nGraph = GuiCtrlCreateGraphic($nX, $nY, $nWidth, $nHeight)
    For $i = 0 To $nHeight - $nY
        $sColor = "0x" & StringFormat("%02X%02X%02X", $color1R+$nStepR*$i, $color1G+$nStepG*$i, $color1B+$nStepB*$i)
        GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $sColor, 0xffffff)
        GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $i)
        GUICtrlSetGraphic(-1, $GUI_GR_LINE, $nWidth, $i)
    Next
	GUICtrlSetState( $nGraph, $GUI_DISABLE)
	Return $nGraph
EndFunc