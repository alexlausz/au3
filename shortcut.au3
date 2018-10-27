;#RequireAdmin
#include <Constants.au3>
#include <AutoItConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

Local $ChromePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe", "")
If @error Then
   MsgBox(48, "谷歌浏览器路径", "未找到应用程序，请先安装谷歌浏览器")
   Exit
EndIf

If ProcessExists("chrome.exe") Then
    MsgBox(48, "清除浏览器缓存数据", "请关闭谷歌浏览器再执行此项操作")
	Exit
Else
	Local Const $ChromeCache = @LocalAppDataDir & "\Google\Chrome\User Data\Default\Cache"
	  ; MsgBox (0,"",$ChromeCache)
    If Not @error Then
	   $FILE = _FileListToArray($ChromeCache)
	   If IsArray($FILE) Then
		  Dim $PATH[5]
		  ProgressOn("清除浏览器缓存数据",$ChromeCache)
		  For $INDEX = 1 To $FILE[0]
			 ProgressSet($INDEX*100/$FILE[0],$FILE[$INDEX])
			 _PathSplit($ChromeCache & "\" & $FILE[$INDEX],$PATH[1],$PATH[2],$PATH[3],$PATH[4])
			 If $PATH[3] <> "" Then ;如果文件名存在（不包括扩展名）
				FileDelete($ChromeCache & "\" & $FILE[$INDEX])
			 Else
				DirRemove($ChromeCache & "\" & $FILE[$INDEX],1)
				;DirRemove($ChromeCache)
			 EndIf
			 Sleep(250)
		  Next
		  ProgressOff()
	   EndIf
	;DirRemove($ChromeCache)
	EndIf
EndIf

Shortcut()
Func Shortcut()
    Local Const $ShortcutPath = @DesktopDir & "\佰赢催收业务平台.lnk"
	If Not @error Then
	   FileDelete($ShortcutPath)
    EndIf
    FileCreateShortcut($ChromePath, $ShortcutPath, @WindowsDir, "--allow-running-insecure-content https://cbp.bycollection.cn", _
            "快速启动佰赢催收业务平台", @SystemDir & "\shell32.dll", "", "130", @SW_SHOWMAXIMIZED)
    Local $aDetails = FileGetShortcut($ShortcutPath)
    If Not @error Then
        MsgBox(64, "CBP快捷方式", "OK！佰赢催收业务平台快捷方式安装完成")
    EndIf

EndFunc

