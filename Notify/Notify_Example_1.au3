#include "Notify.au3"

Opt("TrayAutoPause", 0)

; Press ESC to exit script
HotKeySet("{ESC}", "On_Exit")

Global $fNot_1_Vis = True, $iBegin = 0

Global $sAutoIt_Path = StringRegExpReplace(@AutoItExe, "(^.*\\)(.*)", "\1")

; Register message for click event
_Notify_RegMsg()

; Set notification location
_Notify_Locate(0)

; Show notifications

; Set all values to default
_Notify_Set(Default)
_Notify_Show(@AutoItExe, "Not Clickable with EXE icon", "Retracts after 20 secs", 20, 0)

; Set Show time to 250 ms - note fast entry
_Notify_Set(0, 0xFF0000, 0xFFFF00, "Courier New", False, 250)
_Notify_Show(0, "Clickable", "Coloured - stays 40 secs if not clicked", 40)

; Change colours and font
_Notify_Set(4, 0x0000FF, 0xCCFFCC, "Arial")
_Notify_Show(0, "Clickable", "Only in margin until clicked - click again to retract", 50)

; Reset all values to default
_Notify_Set(Default)
_Notify_Show($sAutoIt_Path & "Examples\GUI\Torus.png", "Clickable with PNG", "Reset to default colours")

; Change justification, colours, font, Reset mode to Slide and Show mode to "fade in" 1000ms
_Notify_Set(6, 0x0000FF, 0xCCCCFF, "Comic MS", True, -1000)
_Notify_Show(48, "Not Clickable", "With an icon - stays 30 secs", 30, 0)

; Change them all again
_Notify_Set(0, Default, 0xCCFF00, "Arial", True, Default)
; This one is clickable, but will only remain in the margin until clicked
$hNot_1 = _Notify_Show(0, "", "No title so the message can span both lines without problem if it is long enough to need it")

; And again
_Notify_Set(0, Default, 0xFF80FF, "MS Comic Sans", True)
; This one can only be retracted programatically 2 secs after the one above and will fade out, overriding the default setting
$hNot_2 = _Notify_Show(0, "Programmed Fade", "This will disappear 2 seconds after the 'No Title' one", 0, 0, Default, -1000)

While 1
    Sleep(10)
	If Not WinExists($hNot_1) And $fNot_1_Vis = True Then
		$iBegin = TimerInit()
		$fNot_1_Vis = False
	EndIf
	If $iBegin And TimerDiff($iBegin) > 2000 And WinExists($hNot_2) Then
		_Notify_Hide($hNot_2)
		$iBegin = 0
	EndIf
WEnd

Func On_Exit()
    Exit
EndFunc