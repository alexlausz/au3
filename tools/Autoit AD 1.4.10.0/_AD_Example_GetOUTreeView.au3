#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <AD.au3>
#include <Excel.au3>
#include <TreeviewConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GuiTreeView.au3>

Global $sTitle = "Active Direcory OU Treeview"
#Region ### START Koda GUI section ### Form=
Global $hMain = GUICreate($sTitle, 743, 683, -1, -1)
Global $idTree = GUICtrlCreateTreeView(6, 6, 600, 666, -1, $WS_EX_CLIENTEDGE)
Global $idExit = GUICtrlCreateButton("Exit", 624, 8, 97, 33)
Global $idExpand = GUICtrlCreateButton("Expand all", 624, 56, 97, 33)
Global $idCollapse = GUICtrlCreateButton("Collapse all", 624, 104, 97, 33)
Global $idSelect = GUICtrlCreateButton("Select OU", 624, 152, 97, 33)
Global $idExport = GUICtrlCreateButton("Export -> Excel", 624, 200, 97, 33)
Global $idProgress = GUICtrlCreateProgress(624, 248, 97, 20)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $__aTreeView
;------------------------------
; Make your changes below
;------------------------------
Global $sOU = "" ; FQDN of the OU where to start
Global $sCategory = "computer" ; Category to select when counts should be displayed or full LDAP query
Global $sText = " (Computer: %)" ; Text to use for the counts to display. % is replaced with the count
Global $iScope = 1 ; Scope for the LDAP search to calculate the count. 1 = Only the OU, 2 = OU + sub-OUs
Global $bCount = True ; True = Display the object count right to the OU
Global $bDisplay = True ; True = Display objects in the OU as well (selection = $sCategory)
Global $iTimerTotal, $iTimerOU, $iTimerGroups, $iTimerTV, $iTimerPerm = 0, $iTimerLoop = 0
Global $iCountSamFQDN = 0, $iCountLoop = 0
Global $oDict = ObjCreate("Scripting.Dictionary")
;------------------------------
; Make your changes above
;------------------------------
$iTimerTotal = TimerInit()
Global $aTreeView = _AD_GetOUTreeView($sOU, $idTree, False, $bCount, $bDisplay, $sCategory, $sText, $iScope, $idProgress)
If @error <> 0 Then MsgBox(16, "Active Direcory OU Treeview", "Error creating list of OUs starting with '" & $sOU & "'." & @CRLF & _
		"Error returned by function _AD_GetALLOUs: @error = " & @error & ", @extended =  " & @extended)
Global $sResult = StringFormat("Total: " & "%.2f" & "sec" & @CRLF & _
		"Get OUs: " & "%.2f sec" & @CRLF & _
		"Get Groups: " & "%.2f sec" & @CRLF & _
		"Check Permissions: " & "%.2f sec" & @CRLF & _
		"  SamToFQDN called: " & "%.0i times" & @CRLF & _
		"  Time in Loop: " & "%.2f sec" & @CRLF & _
		"  Count Loop: " & "%.0i times" & @CRLF & _
		"Display TreeView: " & "%.2f sec", _
		TimerDiff($iTimerTotal)/1000, $iTimerOU/1000 , $iTimerGroups/1000 , $iTimerPerm/1000 , $iCountSamFQDN , $iTimerLoop/1000 , $iCountLoop, $iTimerTV/1000)
MsgBox(0, "Timers and Counters", $sResult)
; Sleep(1000)
GUICtrlDelete($idProgress)
While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $idExit
			Exit
		Case $idExpand
			_GUICtrlTreeView_Expand($idTree)
		Case $idCollapse
			_GUICtrlTreeView_Expand($idTree, 0, False)
		Case $idSelect
			$hSelection = _GUICtrlTreeView_GetSelection($idTree)
			$sSelection = _GUICtrlTreeView_GetText($idTree, $hSelection)
			For $i = 1 To $aTreeView[0][0]
				If $hSelection = $aTreeView[$i][2] Then ExitLoop
			Next
			$sOU = $aTreeView[$i][1]
			MsgBox(64, $sTitle & " - Selected OU", "Name: " & $sSelection & @CRLF & "FQDN: " & $sOU)
		Case $idExport
			If IsArray($__aTreeView) Then
				Global $aExcelData[$__aTreeView[0][0]][99]
				For $i = 1 To $__aTreeView[0][0]
					$iPos = StringInStr($__aTreeView[$i][0], "#")
					$aExcelData[$i - 1][$iPos - 1] = StringMid($__aTreeView[$i][0], $iPos + 1)
				Next
				$oExcel = _Excel_Open()
				$oWorkbook = _Excel_BookNew($oExcel)
				_Excel_RangeWrite($oWorkbook, Default, $aExcelData)
				_Excel_Close($oExcel)
			EndIf
	EndSwitch
WEnd

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetOUTreeView
; Description ...: Fills a given TreeView control with all OUs starting with a given OU.
; Syntax.........: _AD_GetOUTreeView($sOU, $idTreeView[, $bIsADOpen = False[, $bCount = False[, $bDisplay = False[, $sCategory = ""[, $sText = " (%)"[, $iSearchScope = 1[, $idProgress = Default]]]]]]])
; Parameters ....: $sOU          - FQDN of the OU where to start. "" displays all OUs
;                  $idTreeView   - Handle of the TreeView where the OUs will be displayed. Has to be created in advance
;                  $bIsADOpen    - Optional: Pass as True if the connection to the AD has already been made by the calling script (default = False)
;                  $bCount       - Optional: True will display the count of objects in the OU right to the OU name (default = False)
;                                  The LDAP query to determine the count is built from $sCategory
;                  $bDisplay     - Optional: True will display the objects in the OU below the OU itself (default = False)
;                  $sCategory    - Optional: Category to search for or the complete LDAP search string e.g. "computer" and "(objectcategory=computer)" are equivalent
;                                  The number of found objects is added to the OUs name (default = "" = don't count objects)
;                  $sText        - Optional: Text to display the count. Must contain a % which will be replaced by the actual number (default = " (%)")
;                  $iSearchScope - Optional: Search scope for function _AD_GetObjectsInOU: 0 = base, 1 = one-level, 2 = sub-tree (default = 1)
;                  $idProgress   - Optional: ControlID of a progress bar to show during creation of the TreeView (default = Default)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |x - Function _AD_Open or _AD_GetAllOUs failed. @error and @extended are set by _AD_Open or _AD_GetAllOUs
; Author ........: water based on code by ReFran - http://www.autoitscript.com/forum/topic/84119-treeview-read-to-from-file
; Modified.......: water including ideas by HaeMHuK
; Remarks .......: Use $iSearchScope = 1 to get the number of objects of a single OU.
;                  Use $iSearchScope = 2 to get the number of objects in the OU plus all sub-OUs.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AD_GetOUTreeView($sOU, $idTreeView, $bIsADOpen = False, $bCount = False, $bDisplay = False, $sCategory = "", $sText = " (%)", $iSearchScope = 1, $idProgress = Default)

	Local $iCount, $aObjects
	If $bIsADOpen = False Then
		_AD_Open()
		If @error Then Return SetError(@error, @extended, 0)
	EndIf
	$sSeparator = "\"
	$iTimerOU = TimerInit()
	Local $aOUs = _AD_GetAllOUs($sOU, $sSeparator)
	If @error <> 0 Then Return SetError(@error, @extended, 0)
	$iTimerOU = TimerDiff($iTimerOU)
	Global $__aTreeView[$aOUs[0][0] + 1][3] = [[$aOUs[0][0], 3]]
	Local $aResult = $__aTreeView
	Local $iIndexTV = 0, $sIgnoreOU = ""
	$iTimerGroups = TimerInit()
	Local $aMemberOf = _AD_GetUserGroups(@UserName) ; Dummy can be removed
	$iTimerGroups = TimerDiff($iTimerGroups)
	For $i = 1 To $aOUs[0][0]
		If $idProgress <> Default Then GUICtrlSetData($idProgress, $i * 100 / $aOUs[0][0] / 2) ; 50 of the progress by processing the OUs
		If $sIgnoreOU = "" Or ($sIgnoreOU <> "" And StringInStr($aOUs[$i][1], $sIgnoreOU, -1) = 0) Then ; OU to ignore if not set or OU to ignore is set and entry to check isn't a sub-OU of the ignored OU then check permissions
			If _AD_HasRequiredRights__GivenMembers($aOUs[$i][1], 0, @UserName, $aMemberOf) = 0 Then ; User doesn't have needed permissions. Ignore this OU and all sub-OUs
				$sIgnoreOU = $aOUs[$i][1]
			Else
				$sIgnoreOU = ""
			EndIf
		EndIf
		If $sIgnoreOU = "" Then
			$iIndexTV = $iIndexTV + 1
			$aTemp = StringSplit($aOUs[$i][0], $sSeparator)
			$__aTreeView[$iIndexTV][0] = StringFormat("%" & $aTemp[0] - 1 & "s", "") & "#" & $aTemp[$aTemp[0]]
			$__aTreeView[$iIndexTV][1] = $aOUs[$i][1]
		EndIf
	Next
	ReDim $__aTreeView[$iIndexTV + 1][3]
	$__aTreeView[0][0] = $iIndexTV
	$iTimerTV = TimerInit()
	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $ah[50], $sLDAPString
	If $sCategory <> "" And StringIsAlNum($sCategory) Then
		$sLDAPString = "(objectcategory=" & $sCategory & ")"
	Else
		$sLDAPString = $sCategory
	EndIf
	$iOutIndex = 0
	For $iIndex = 1 To $__aTreeView[0][0]
		If $idProgress <> Default Then GUICtrlSetData($idProgress, 50 + $iIndex * 100 / $__aTreeView[0][0] / 2) ; 50 of the progress by processing the result
		$iOutIndex += 1
		$aObjects = ""
		$sLine = StringSplit(StringStripCR($__aTreeView[$iIndex][0]), @TAB)
		$iLevel = StringInStr($sLine[1], "#")
		If $iLevel = 0 Then ExitLoop
		If ($bCount Or $bDisplay) And $sLDAPString <> "" Then
			If $bDisplay Then
				$aObjects = _AD_GetObjectsInOU($__aTreeView[$iIndex][1], $sLDAPString, 1, "samaccountname,distinguishedname", "", False)
				If @error Then
					$iCount = 0
				Else
					$iCount = $aObjects[0][0]
				EndIf
			Else
				$iCount = _AD_GetObjectsInOU($__aTreeView[$iIndex][1], $sLDAPString, $iSearchScope, "samaccountname,distinguishedname", "", True)
			EndIf
		EndIf
		$sTemp = ""
		If $bCount And $sLDAPString <> "" Then $sTemp = StringReplace($sText, "%", $iCount)
		If $iLevel = 1 Then
			$ah[$iLevel] = _GUICtrlTreeView_Add($idTreeView, 0, StringMid($sLine[1], $iLevel + 1) & $sTemp)
		Else
			$ah[$iLevel] = _GUICtrlTreeView_AddChild($idTreeView, $ah[$iLevel - 1], StringMid($sLine[1], $iLevel + 1) & $sTemp)
		EndIf
		$aResult[$iOutIndex][0] = $__aTreeView[$iIndex][0]
		$aResult[$iOutIndex][1] = $__aTreeView[$iIndex][1]
		$aResult[$iOutIndex][2] = $ah[$iLevel]
		; Add the objects of the OU to the TreeView
		If IsArray($aObjects) Then
			ReDim $aResult[UBound($aResult, 1) + $aObjects[0][0]][UBound($aResult, 2)]
			For $iIndex2 = 1 To $aObjects[0][0]
				$iOutIndex += 1
				If StringRight($aObjects[$iIndex2][0], 1) = "$" Then $aObjects[$iIndex2][0] = StringLeft($aObjects[$iIndex2][0], StringLen($aObjects[$iIndex2][0]) - 1)
				$aResult[$iOutIndex][0] = $aObjects[$iIndex2][0]
				$aResult[$iOutIndex][1] = $aObjects[$iIndex2][1]
				$aResult[$iOutIndex][2] = _GUICtrlTreeView_AddChild($idTreeView, $ah[$iLevel], $aObjects[$iIndex2][0])
			Next
		EndIf
	Next
	If $bIsADOpen = False Then _AD_Close()
	_GUICtrlTreeView_EndUpdate($idTreeView)
	$aResult[0][0] = UBound($aResult, 1) - 1
	$aResult[0][1] = UBound($aResult, 2)
	$iTimerTV = TimerDiff($iTimerTV)
	Return $aResult

EndFunc   ;==>_AD_GetOUTreeView

Func _AD_HasRequiredRights__GivenMembers($sAD_Object, $iAD_Right = 983551, $sAD_User = @UserName, $aAD_MemberOf = "")
	Local $iPerm = TimerInit()
	Local $iLoop = TimerInit()
	If StringMid($sAD_Object, 3, 1) <> "=" Then $sAD_Object = _AD_SamAccountNameToFQDN($sAD_Object) ; sAMAccountName provided
	Local $aAD_TrusteeArray, $sAD_TrusteeGroup, $sAD_TrusteeArrayFQDN
	Local $oAD_Object = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sAD_Object)
	If IsObj($oAD_Object) Then
		Local $oAD_Security = $oAD_Object.Get("ntSecurityDescriptor")
		Local $oAD_DACL = $oAD_Security.DiscretionaryAcl
		For $oAD_ACE In $oAD_DACL
			If BitAND($oAD_ACE.AccessMask, $iAD_Right) <> $iAD_Right Then ContinueLoop
			$aAD_TrusteeArray = StringSplit($oAD_ACE.Trustee, "\")
			$sAD_TrusteeGroup = "CN=" & $aAD_TrusteeArray[$aAD_TrusteeArray[0]] & ","
			If $aAD_TrusteeArray[0] = 2 Then
				If $aAD_TrusteeArray[2] = $sAD_User And BitAND($oAD_ACE.AccessMask, $iAD_Right) = $iAD_Right Then Return 1
				; Check if the entry exists in the Dictionary
				If $oDict.Exists($aAD_TrusteeArray[2]) Then
					$sAD_TrusteeArrayFQDN = $oDict.Item($aAD_TrusteeArray[2])
				Else
					$iCountSamFQDN = $iCountSamFQDN + 1
					$sAD_TrusteeArrayFQDN = _AD_SamAccountNameToFQDN($aAD_TrusteeArray[2])
					$oDict.Add($aAD_TrusteeArray[2], $sAD_TrusteeArrayFQDN)
				EndIf
			EndIf
			$iLoop = TimerInit()
			For $iCount1 = 0 To UBound($aAD_MemberOf) - 1
				$iCountLoop = $iCountLoop + 1
				If StringInStr($aAD_MemberOf[$iCount1], $sAD_TrusteeArrayFQDN) Then
					$iTimerPerm = $iTimerPerm + TimerDiff($iPerm)
					Return 1
				ElseIf StringInStr($aAD_MemberOf[$iCount1], $sAD_TrusteeGroup) Then
					$iTimerPerm = $iTimerPerm + TimerDiff($iPerm)
					Return 1
				EndIf
			Next
			$iTimerLoop = $iTimerLoop + TimerDiff($iLoop)
		Next
	EndIf
	$iTimerPerm = $iTimerPerm + TimerDiff($iPerm)
	Return 1 ; 1: Test. Change to 0 for production
EndFunc   ;==>_AD_HasRequiredRights__GivenMembers

