#Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"
$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)
$progress1 = XSkinProgress( 90, 140, 2 00, 2 0 )
GUICtrlSetData($progress1, 50)

GUISetState()

While 1
    Sleep(10)
WEnd
 
