#Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"
$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)
$button_1 = XSkinButton( "Input Dialog", 145, 100, 100, 35, "Input")

GUISetState()

While 1
    MouseOver()
    Sleep(10)
WEnd

Func OkCancel()
    XSkinTray Box( "XSkin", "Text Here")
EndFunc
