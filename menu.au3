#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <PrintMgr.au3>
#Include <Array.au3>

_Main()

Func _Main()
	Local $idFileMenu, $idFileItem, $idRecentFilesMenu, $idSeparator1
	Local $idExitItem, $idHelpMenu, $idAboutItem, $idAddPrtButton,  $idDelPrtButton, $idOkButton, $idCancelButton
	Local $iMsg, $sFile
	#forceref $idSeparator1

	GUICreate("桌面自助工具", 300, 200)

	;$idFileMenu = GUICtrlCreateMenu("File")
	;$idFileItem = GUICtrlCreateMenuItem("Open...", $idFileMenu)
	;$idRecentFilesMenu = GUICtrlCreateMenu("Recent Files", $idFileMenu)
	;$idSeparator1 = GUICtrlCreateMenuItem("", $idFileMenu)
	;$idExitItem = GUICtrlCreateMenuItem("Exit", $idFileMenu)
	;$idHelpMenu = GUICtrlCreateMenu("?")
	;$idAboutItem = GUICtrlCreateMenuItem("About", $idHelpMenu)

    $idAddPrtButton = GUICtrlCreateButton("添加打印机 Canon_C5255_2.15", 30, 20, 230, 30)
    $idDelPrtButton = GUICtrlCreateButton("删除打印机 Canon_C5255_2.15", 30, 60, 230, 30)
	$idOkButton = GUICtrlCreateButton("OK", 50, 130, 70, 20)

	$idCancelButton = GUICtrlCreateButton("Cancel", 180, 130, 70, 20)

	GUISetState()

	While 1
		$iMsg = GUIGetMsg()

		Select
			Case $iMsg = $GUI_EVENT_CLOSE Or $iMsg = $idCancelButton
				ExitLoop

			;Case $iMsg = $idFileItem
				;$sFile = FileOpenDialog("Choose file...", @TempDir, "All (*.*)")
				;If @error <> 1 Then GUICtrlCreateMenuItem($sFile, $idRecentFilesMenu)

			;Case $iMsg = $idExitItem
			;	ExitLoop

			Case $iMsg = $idOkButton
			   $aPrinterList = _PrintMgr_PrinterExists()
			   _ArrayDisplay($aPrinterList)
				;MsgBox($MB_SYSTEMMODAL, "Click", "You clicked OK!")

			Case $iMsg = $idAddPrtButton
				;RunWait(@ComSpec & " /c rundll32 printui.dll,PrintUIEntry /in /u /z /q /n \\10.80.7.247\Canon_C5255_2.15", @SW_HIDE)
				_PrintMgr_AddWindowsPrinterConnection("\\10.80.7.247\Canon_C5255_2.15")
				_PrintMgr_AddWindowsPrinterConnection("\\10.80.7.247\Canon_C5255_2.16")
				;_PrintMgr_SetDefaultPrinter("\\10.80.7.247\Canon_C5255_2.16")

			Case $iMsg = $idDelPrtButton
				;RunWait(@ComSpec & " /c rundll32 printui.dll,PrintUIEntry /in /u /z /q /n \\10.80.7.247\Canon_C5255_2.15" @SW_HIDE)
				_PrintMgr_RemovePrinter("\\10.80.7.247\Canon_C5255_2.15")
				_PrintMgr_RemovePrinter("\\10.80.7.247\Canon_C5255_2.16")

			;Case $iMsg = $idAboutItem
			;	MsgBox($MB_SYSTEMMODAL, "About", "GUI Menu Test")
		EndSelect
	WEnd

	GUIDelete()

	Exit
EndFunc   ;==>_Main
