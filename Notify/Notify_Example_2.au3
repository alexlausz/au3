#include <Array.au3>

#include "Notify.au3"

_Notify_RegMsg()

; Initialise task timers
Global $nTask1 = TimerInit()
Global $nTask2 = TimerInit()
Global $nTask3 = TimerInit()

; Set task delays
Global $iDelay1 = 1000 * Random(5, 20, 1)
Global $iDelay2 = 1000 * Random(5, 20, 1)
Global $iDelay3 = 1000 * Random(5, 20, 1)

; Display notifications
Global $sGUID = "Notify_UDF"
_Notify_Set(1, Default, 0xFFCCCC, Default, Default, Default, Default, Default, $sGUID)
Global $hNotify1 = _Notify_Show(0, "Task 1", "Running")
Global $hNotify2 = _Notify_Show(0, "Task 2", "Running")
Global $hNotify3 = _Notify_Show(0, "Task 3", "Running")

While 1

    If $nTask1 Then
        If TimerDiff($nTask1) > $iDelay1 Then
            $nTask1 = 0
			; Recolour notification, change message text and set as "clickable"
            _Notify_Modify($hNotify1, Default, 0xCCFFCC, Default, "Completed", 1)
        EndIf

    EndIf

    If $nTask2 Then
        If TimerDiff($nTask2) > $iDelay2 Then
            $nTask2 = 0
            ; Recolour, change message text and set as "clickable"
            _Notify_Modify($hNotify2, Default, 0xCCFFCC, Default, "Completed", 1)
        EndIf

    EndIf

    If $nTask3 Then
        If TimerDiff($nTask3) > $iDelay3 Then
            $nTask3 = 0
            ; Recolour, change message text and set as "clickable"
            _Notify_Modify($hNotify3, Default, 0xCCFFCC, Default, "Completed", 1)
        EndIf

    EndIf

	If $nTask1 + $nTask2 + $nTask3 = 0 Then ExitLoop

WEnd

; List visible notifications
Global $aList = WinList($sGUID)
_ArrayDisplay($aList, "Notifications", Default, 8)