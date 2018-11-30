#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Create a mailbox for a user by using PowerShell
; *****************************************************************************
#include <AD.au3>
#include <MsgBoxConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox($MB_ICONERROR, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
; Query data needed for the function call
Global $sUser = InputBox("Active Directory Example Skript", "User account (SamAccountName or FQDN) for which you want to create the mailbox.", @Username, Default, 400, 150)
If @error Then Exit
Global $sURI = InputBox("Active Directory Example Skript", "URI of the Exchange server you want to connect to.", "http://YourExchangeServerNameGoesHere.CompanyName.com", Default, 400, 150)
If @error Then Exit
; Let the user confirm the data before creating the mailbox
If MsgBox($MB_YESNOCANCEL, "Active Directory Example Skript", "Are you sure that you want to connect to" & @CRLF & "  " & $sURI & @CRLF & "and create a mailbox for user" & @CRLF & "  " & $sUser) <> $IDYES Then Exit
; Create the mailbox
Global $vResult = _AD_CreateMailboxPS($sUser, $sURI)
If @error > 0 Then
    If @error < 7 Then
        MsgBox($MB_ICONERROR, "Error!", "_AD_CreateMailboxPS returned @error = " & @error & ", @extended = " & @extended)
    Else
        _ArrayDisplay($vResult, "_AD_CreateMailboxPS returned @error = " & @error & ", @extended = " & @extended)
    EndIf
Else
    _ArrayDisplay($vResult, "_AD_CreateMailboxPS successfully created the mailbox!")
EndIf
_AD_Close()
Exit