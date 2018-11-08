; _APIFileOpen( <FileName> )
;
; Returns a "REAL" file handle for reading and writing.
; The return value comes directly from "CreateFile" api.
Func _APIFileLock( $szFile )

	;returns handle, or 0 if it failed

	Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000
	Local $STANDARD_RIGHTS_REQUIRED = 0x000f0000
	Local $SYNCHRONIZE = 0x00100000
	Local $FILE_ALL_ACCESS = BitOR(0x1FF, $STANDARD_RIGHTS_REQUIRED, $SYNCHRONIZE)

	if not FileExists($szFile) Then
		return 0
	EndIf

#comments-start
 Create File API from http://msdn2.microsoft.com/en-us/library/aa363858.aspx

; share mode used here is 7 - what is that?
; 0 is locked
; FILE_SHARE_DELETE
; FILE_SHARE_READ
; FILE_SHARE_WRITE
HANDLE CreateFile(
  LPCTSTR lpFileName,
  DWORD dwDesiredAccess,
  DWORD dwShareMode,
  LPSECURITY_ATTRIBUTES lpSecurityAttributes,
  DWORD dwCreationDisposition,
  DWORD dwFlagsAndAttributes,
  HANDLE hTemplateFile
);


#comments-end

	Local $LOCK_MODE_NO_SHARING = 0

	Local $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $AFO_h, $AFO_ret
	Local $AFO_bWrite = 1
	$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
			"str", $szFile, _
			"long", $FILE_ALL_ACCESS, _
			"long", $LOCK_MODE_NO_SHARING, _
			"ptr", 0, _
			"long", $OPEN_ALWAYS, _
			"long", $FILE_ATTRIBUTE_NORMAL, _
			"long", 0 )
	If $AFO_h[0] = 0xFFFFFFFF Then
		$AFO_bWrite = 0
		$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
				"str", $szFile, _
				"long", $GENERIC_READ, _
				"long", $LOCK_MODE_NO_SHARING, _
				"ptr", 0, _
				"long", $OPEN_ALWAYS, _
				"long", $FILE_ATTRIBUTE_NORMAL, _
				"long", 0 )
	EndIf
	$AFO_ret = DLLCall("kernel32.dll","int","GetLastError")
	SetError($AFO_ret[0]) ;,$AFO_bWrite)
	Return $AFO_h[0]
EndFunc

; _APIFileClose( <FileHandle> )
;
; The return value comes directly from "CloseHandle" api.
Func _APIFileClose( ByRef $hFile )
	Local $AFC_r
	$AFC_r = DllCall( "kernel32.dll", "int", "CloseHandle", _
			"hwnd", $hFile )
	Return $AFC_r[0]
EndFunc