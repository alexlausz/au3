#Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"
$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)
$button_1 = XSkinButton("Button 1", 145, 100, 100, 35, "Hello")
GUISetState()

While 1
    MouseOver() ;makes the button flash on mouseover
    Sleep(10)
WEnd

Func Hello()
    MsgBox(64, "XSkin", "Test Button 1", 3)
EndFunc
 
