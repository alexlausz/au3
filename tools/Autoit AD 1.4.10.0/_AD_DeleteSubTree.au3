#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $sObject = InputBox("Active Directory Example Skript - _AD_DeleteSubtree", "Please specify the object (OU) to be deleted:", default, "", 400, 130)
If @error Then Exit

; Delete Subtree
Global $sReturn = _AD_DeleteSubtree($sObject)
If @error Then
	Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_DeleteSubtree encountered a problem. @error = " & @error & ", @extended = " & @extended & ", return value = " & $sReturn)
Else
	MsgBox(16, "Active Directory Example Skript", "Function _AD_DeleteSubtree deleted " & $sObject & " and all contained OUs and all leaf objects")
EndIf
; Close Connection to the Active Directory
_AD_Close()

Exit
