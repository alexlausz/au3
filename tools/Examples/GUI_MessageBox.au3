#Include <XSkin.au3> 

; folder of skin
$Skin_Folder = @ScriptDir & "\Skins\Black-Yellow"
$XSkinGui = XSkinGUICreate( "My GUI", 400, 450, $Skin_Folder)
$button_1 = XSkinButton("Dialog Box (Ok/Cancel)", 145, 100, 100, 35, "OkCancel")
$button_2 = XSkinButton("Dialog Box (Ok Only)", 145, 60, 100, 35, "OkOnly")

GUISetState()

While 1
    MouseOver()
    Sleep(10)
WEnd

Func OkCancel()
    XSkin MsgBox( "Ok Cancel Dialog", "Hello")
EndFunc

Func OkOnly()
    XSkinMsgBoxOK("Ok Only Dialog", "Hello")
EndFunc
