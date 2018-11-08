;~ 4 Do not display a progress dialog box.
;~ 8 Give the file being operated on a new name in a move, copy, or rename operation if a file with the target name already exists.
;~ 16 Respond with "Yes to All" for any dialog box that is displayed.
;~ 64 Preserve undo information, if possible.
;~ 128 Perform the operation on files only if a wildcard file name (*.*) is specified.
;~ 256 Display a progress dialog box but do not show the file names.
;~ 512 Do not confirm the creation of a new directory if the operation requires one to be created.
;~ 1024 Do not display a user interface if an error occurs.
;~ 2048 Version 4.71. Do not copy the security attributes of the file.
;~ 4096 Only operate in the local directory. Don't operate recursively into subdirectories.
;~ 9182 Version 5.0. Do not copy connected files as a group. Only copy the specified files.

_FileCopy("\\10.80.7.252\File_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe", @DesktopDir)

Func _FileCopy($fromFile,$tofile)
    Local $FOF_RESPOND_YES = 16
    Local $FOF_SIMPLEPROGRESS = 256
    $winShell = ObjCreate("shell.application")
    $winShell.namespace($tofile).CopyHere($fromFile,$FOF_RESPOND_YES)
EndFunc