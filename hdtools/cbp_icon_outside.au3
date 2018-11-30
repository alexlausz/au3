#include <File.au3>

cbpShortcut()

Func cbpShortcut()

   Local $ChromePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe", "")
   If @error Then
	  MsgBox(48, "谷歌浏览器", "请先安装谷歌浏览器")
   Else
	  Local Const $ShortcutPath = @DesktopDir & "\佰赢催收业务平台.lnk"
	  If Not @error Then
		 FileDelete($ShortcutPath)
	  EndIf

	  FileCreateShortcut($ChromePath, $ShortcutPath, @WindowsDir, "--allow-running-insecure-content https://cbp.bycollection.cn:8443", _
			"快速启动佰赢催收业务平台", @SystemDir & "\shell32.dll", "", "130", @SW_SHOWMAXIMIZED)
	  Local $aDetails = FileGetShortcut($ShortcutPath)
	  If Not @error Then
		 MsgBox(64, "CBP快捷方式", "恭喜，佰赢催收业务平台 桌面图标创建完成！")
	  EndIf
   EndIf

EndFunc