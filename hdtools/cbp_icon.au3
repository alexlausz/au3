#include <Array.au3>
#Include <Misc.au3>
#include <File.au3>
#include <FileConstants.au3>
#Include <APIFileReadWrite.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <Constants.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <PrintMgr.au3>
#include "ExtMsgBox.au3"
;~ #RequireAdmin

$Form1 = GUICreate("Desktop Helper", 615, 300, -1, -1, $WS_SYSMENU)

;GUISetFont(8.5, 400, $GUI_FONTNORMAL, "微软雅黑")
GUISetFont(8.5, 400, $GUI_FONTNORMAL, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("本机信息", 32, 32, 550, 90)
GUICtrlCreateLabel("计算机名", 70, 60, 50, 20)
GUICtrlCreateLabel("当前用户", 70, 90, 50, 20)
GUICtrlCreateLabel("IP地址", 330, 60, 50, 20)
GUICtrlCreateLabel("操作系统", 330, 90, 50, 20) ;@OSVersion @OSArch @OSLang

Local Const $ComputerDomain = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "Domain")
Local Const $UserDomain = EnvGet("USERDOMAIN")
$Input_ComputerName = GUICtrlCreateInput("" & @ComputerName & "." & $ComputerDomain, 130, 56, 120, 20)
;GUICtrlSetFont(-1, 8.5, $FW_NORMAL, $GUI_FONTNORMAL, "Comic Sans Ms")
$Input_IpAddress = GUICtrlCreateInput("" & $UserDomain & "\" & @UserName, 130, 86, 120, 20)
$Input_IpAddress = GUICtrlCreateInput("" & @IPAddress1, 400, 56, 120, 20)
$Input_IpAddress = GUICtrlCreateInput("" & @OSVersion & " " & @OSArch, 400, 86, 120, 20)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("常用工具", 32, 150, 553, 80)
$Button21 = GUICtrlCreateButton("创建 新催收系统 桌面图标 （ 限内网使用 ）", 70, 180, 450, 30)

;$Button2 = GUICtrlCreateButton("Button2", 450, 320, 80, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;$Button3 = GUICtrlCreateButton("退出", 474, 416, 80, 25)
GUISetState(@SW_SHOW)


While 1

   $iMsg = GUIGetMsg()

   Select

   Case $iMsg = $GUI_EVENT_CLOSE
	  Exit

   Case $iMsg = $Button21
		 cbpShortcut()

	EndSelect
 WEnd

Func cbpShortcut()

   Local $ChromePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe", "")
   If @error Then
	  MsgBox(48, "谷歌浏览器路径", "请先安装谷歌浏览器")
   Else
	  Local Const $ShortcutPath = @DesktopDir & "\佰赢催收业务平台.lnk"
	  If Not @error Then
		 FileDelete($ShortcutPath)
	  EndIf

	  FileCreateShortcut($ChromePath, $ShortcutPath, @WindowsDir, "--allow-running-insecure-content https://cbp.bycollection.cn", _
			"快速启动佰赢催收业务平台", @SystemDir & "\shell32.dll", "", "130", @SW_SHOWMAXIMIZED)
	  Local $aDetails = FileGetShortcut($ShortcutPath)
	  If Not @error Then
		 MsgBox(64, "CBP快捷方式", "新催收系统 桌面图标创建完成。")
	  EndIf
   EndIf

EndFunc