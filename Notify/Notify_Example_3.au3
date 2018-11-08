
#include "Notify.au3"

Opt("TrayAutoPause", 0)

; Press ESC to exit script
HotKeySet("{ESC}", "_Exit")

; Register message for click event
_Notify_RegMsg()

; Set notification location
_Notify_Locate(0)

; Just for the example, get max visible number for this display
$iMax = $aNotify_Data[0][1]

; Settings for visible notifications
_Notify_Set(0, Default, 0xCCFFCC, Default, Default, 250, 100)

; Show immediately visible
For $i = 1 To $iMax
	_Notify_Show(0, "No " & $i, "Immediately visible", 20)
Next

; Change colour and in/out type for the invisible notifications to show that they retain their settings
_Notify_Set(0, Default, 0xFFCCCC, Default, Default, -500, -250)

For $i = $iMax + 1 To $iMax + 5
	_Notify_Show(0, "No " & $i, "Orginally hidden", 20)
Next

While 1
	Sleep(10)
WEnd

Func _Exit()
	Exit
EndFunc