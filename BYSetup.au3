;#RequireAdmin
#include <Constants.au3>
#include <AutoItConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>

; 先映射好网络盘，以便后面复制安装程序
RunWait(@ComSpec & " /c net use * /del /yes", @SW_HIDE)
RunWait(@ComSpec & " /c net use K: \\10.80.7.252\file_share bill@123admin /user:by\byadmin", @SW_HIDE)

Local Const $SwSource = "\\10.80.7.252\file_share\IT部\4.工具软件"
Local Const $ChromePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe", "")
If @error Then
   Local Const $ChromeSource = $SwSource & "\ChromeStandaloneSetup64.exe"
   _FileCopy($ChromeSource, @DesktopDir)
   ;Run(@DesktopDir & "\ChromeStandaloneSetup64.exe")
EndIf

Local Const $FirefoxPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe", "")
If @error Then
   Local Const $FirefoxSource = $SwSource & "\Firefox Setup 62.0.3.exe"
   _FileCopy($FirefoxSource, @DesktopDir)
   Run(@DesktopDir & "\Firefox Setup 62.0.3.exe")
EndIf

Local Const $QhbPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\企话宝1.1.0", "UninstallString")
If @error Then
   Local Const $QhbSource = $SwSource & "\qhb-release-1.1.0.exe"
   _FileCopy($QhbSource, @DesktopDir)
   Run(@DesktopDir & "\qhb-release-1.1.0.exe")
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

Func _FileCopy($sCopySource,$sCopyTargetDir)
    Local $FOF_RESPOND_YES = 16
    Local $FOF_SIMPLEPROGRESS = 256
    If Not FileExists($sCopyTargetDir) Then DirCreate($sCopyTargetDir)
    $winShell = ObjCreate("shell.application")
    $winShell.namespace($sCopyTargetDir).CopyHere($sCopySource,$FOF_RESPOND_YES)
 EndFunc

 FileDelete(@DesktopDir & "\qhb-release-1.1.0.exe")
 FileDelete(@DesktopDir & "\ChromeStandaloneSetup64.exe")
 FileDelete(@DesktopDir & "\Firefox Setup 62.0.3.exe")


