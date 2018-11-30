 #Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"

$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)

GUISetState()

While 1
    Sleep(10)
WEnd 