#Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"
$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)
$XIcon = XSkinIcon( $XSkinGui, 3 ) 

GUISetState()

While 1
    $msg = GUIGetMsg()
    If $msg = $XIcon[1] Then Exit
    If $msg = $XIcon[2] Then GUISetState(@SW_MINIMIZE
    If $msg = $XIcon[3] Then MsgBox(0, 0, "Help", 1)
WEnd
 
