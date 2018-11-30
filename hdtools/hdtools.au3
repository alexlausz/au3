#include <Array.au3>
#Include <Misc.au3>
;#Include "Copy.au3"
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
;#include <StringSize.au3>
#RequireAdmin

;检查共享盘是否可以访问，如果访问不了则添加网盘映射
Global $SharePath = "\\10.80.7.252\File_share\IT部\4.工具软件"
If FileExists($SharePath & "\") = 0 Then
   RunWait(@ComSpec & " /c net use * /del /y", "", @SW_HIDE)
;~    If @error Then
;~ 	  MsgBox(16, "", "comspec command error")
;~    EndIf
   Sleep(1000)
   RunWait(@ComSpec & ' /c net use K: \\10.80.7.252\File_share "bill@123admin" /user:by\byadmin /persistent:no', "", @SW_HIDE)
   If @error Then
	  MsgBox(16, "设置共享盘", "无法访问网络共享，请检查网络设置！")
   EndIf
EndIf

$Form1 = GUICreate("Desktop Helper", 615, 573, -1, -1, $WS_SYSMENU)

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

;GUISetBkColor($COLOR_GREEN)
$Group2 = GUICtrlCreateGroup("添加打印机", 32, 142, 550, 160)
$ButtonAddPrinter01 = GUICtrlCreateButton(" No.1  佳能 Canon 5255 （ 靠近属地管理部 ）", 70, 170, 300, 30)
$ButtonAddPrinter02 = GUICtrlCreateButton(" No.2  佳能 Canon 5255 （ 靠近会议室 ）    ", 70, 210, 300, 30)
$ButtonAddPrinter03 = GUICtrlCreateButton(" No.3  佳能 Canon 5255 （ 靠近行政部 ）    ", 70, 250, 300, 30)
$ButtonSetPrinter01 = GUICtrlCreateButton("设为默认", 390, 170, 80, 30)
$ButtonSetPrinter02 = GUICtrlCreateButton("设为默认", 390, 210, 80, 30)
$ButtonSetPrinter03 = GUICtrlCreateButton("设为默认", 390, 250, 80, 30)

$ButtonDelPrinter01 = GUICtrlCreateButton("删除", 490, 170, 60, 30)
$ButtonDelPrinter02 = GUICtrlCreateButton("删除", 490, 210, 60, 30)
$ButtonDelPrinter03 = GUICtrlCreateButton("删除", 490, 250, 60, 30)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("常用工具", 32, 332, 553, 200)
$Button21 = GUICtrlCreateButton("创建 新催收系统 桌面图标", 70, 360, 300, 30)
$Button22 = GUICtrlCreateButton("安装 Chrome   谷歌浏览器", 70, 400, 300, 30)
$Button23 = GUICtrlCreateButton("安装 Firefox  火狐浏览器", 70, 440, 300, 30)
$Button24 = GUICtrlCreateButton("安装 eysBeam  众投软电话", 70, 480, 300, 30)

;$Button2 = GUICtrlCreateButton("Button2", 450, 320, 80, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;$Button3 = GUICtrlCreateButton("退出", 474, 416, 80, 25)
GUISetState(@SW_SHOW)

$aPrinterList = _PrintMgr_EnumPrinter()
Local Const $Printer215 = "\\10.80.7.247\Canon_C5255_2.15"
Local Const $Printer216 = "\\10.80.7.247\Canon_C5255_2.16"
Local Const $Printer252 = "\\10.80.7.247\Canon_C5255_2.252"

_ArraySearch($aPrinterList, $Printer215)
If @error Then
   GUICtrlSetState($ButtonSetPrinter01, $GUI_DISABLE)
   GUICtrlSetState($ButtonDelPrinter01, $GUI_DISABLE)
Else
   GUICtrlSetState($ButtonSetPrinter01, $GUI_ENABLE)
   GUICtrlSetState($ButtonDelPrinter01, $GUI_ENABLE)
   GUICtrlSetState($ButtonAddPrinter01, $GUI_DISABLE)
EndIf

_ArraySearch($aPrinterList, $Printer216)
If @error Then
   GUICtrlSetState($ButtonSetPrinter02, $GUI_DISABLE)
   GUICtrlSetState($ButtonDelPrinter02, $GUI_DISABLE)
Else
   GUICtrlSetState($ButtonSetPrinter02, $GUI_ENABLE)
   GUICtrlSetState($ButtonDelPrinter02, $GUI_ENABLE)
   GUICtrlSetState($ButtonAddPrinter02, $GUI_DISABLE)
EndIf

_ArraySearch($aPrinterList, $Printer252)
If @error Then
   GUICtrlSetState($ButtonSetPrinter03, $GUI_DISABLE)
   GUICtrlSetState($ButtonDelPrinter03, $GUI_DISABLE)
Else
   GUICtrlSetState($ButtonSetPrinter03, $GUI_ENABLE)
   GUICtrlSetState($ButtonDelPrinter03, $GUI_ENABLE)
   GUICtrlSetState($ButtonAddPrinter03, $GUI_DISABLE)
EndIf

While 1

   $iMsg = GUIGetMsg()

   Select

   Case $iMsg = $GUI_EVENT_CLOSE
	  Exit

   Case $iMsg = $ButtonAddPrinter01
	  _PrintMgr_AddWindowsPrinterConnection("\\10.80.7.247\Canon_C5255_2.15")
	  If Not @error Then
		 MsgBox(8256, "添加打印机", "操作成功！")
		 GUICtrlSetState($ButtonAddPrinter01, $GUI_DISABLE)
		 GUICtrlSetState($ButtonSetPrinter01, $GUI_ENABLE)
		 GUICtrlSetState($ButtonDelPrinter01, $GUI_ENABLE)
	  Else
		 MsgBox(16, "添加打印机", "操作失败，请联系IT处理。")
	  EndIf

   Case $iMsg = $ButtonAddPrinter02
	  _PrintMgr_AddWindowsPrinterConnection("\\10.80.7.247\Canon_C5255_2.16")
	  If Not @error Then
		 MsgBox(8256, "添加打印机", "操作成功！")
		 GUICtrlSetState($ButtonAddPrinter02, $GUI_DISABLE)
		 GUICtrlSetState($ButtonSetPrinter02, $GUI_ENABLE)
		 GUICtrlSetState($ButtonDelPrinter02, $GUI_ENABLE)
	  Else
		 MsgBox(16, "添加打印机", "操作失败，请联系IT处理。")
	  EndIf

   Case $iMsg = $ButtonAddPrinter03
	  _PrintMgr_AddWindowsPrinterConnection("\\10.80.7.247\Canon_C5255_2.252")
	  If Not @error Then
		 MsgBox(8256, "添加打印机", "操作成功！")
		 GUICtrlSetState($ButtonAddPrinter03, $GUI_DISABLE)
		 GUICtrlSetState($ButtonSetPrinter03, $GUI_ENABLE)
		 GUICtrlSetState($ButtonDelPrinter03, $GUI_ENABLE)
	  Else
		 MsgBox(16, "添加打印机", "操作失败，请联系IT处理。")
	  EndIf

   Case $iMsg = $ButtonSetPrinter01
	  RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n " & $Printer215 , "",@SW_HIDE)
		 GUICtrlSetState($ButtonSetPrinter01, $GUI_DISABLE)
		 $aPrinterList = _PrintMgr_EnumPrinter()
		 _ArraySearch($aPrinterList, $Printer216)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter02, $GUI_ENABLE)
		 EndIf
		 _ArraySearch($aPrinterList, $Printer252)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter03, $GUI_ENABLE)
		 EndIf
		 MsgBox(8256, "设置默认打印机", "操作成功！")

   Case $iMsg = $ButtonSetPrinter02
	  RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n " & $Printer216 , "",@SW_HIDE)
		 GUICtrlSetState($ButtonSetPrinter02, $GUI_DISABLE)
		 $aPrinterList = _PrintMgr_EnumPrinter()
		 _ArraySearch($aPrinterList, $Printer215)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter01, $GUI_ENABLE)
		 EndIf
		 _ArraySearch($aPrinterList, $Printer252)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter03, $GUI_ENABLE)
		 EndIf
		 MsgBox(8256, "设置默认打印机", "操作成功！")

   Case $iMsg = $ButtonSetPrinter03
	  RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n " & $Printer252 , "",@SW_HIDE)
		 GUICtrlSetState($ButtonSetPrinter03, $GUI_DISABLE)
		 $aPrinterList = _PrintMgr_EnumPrinter()
		 _ArraySearch($aPrinterList, $Printer215)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter01, $GUI_ENABLE)
		 EndIf
		 _ArraySearch($aPrinterList, $Printer216)
		 If Not @error Then
			GUICtrlSetState($ButtonSetPrinter02, $GUI_ENABLE)
		 EndIf
		 MsgBox(8256, "设置默认打印机", "操作成功！")

   Case $iMsg = $ButtonDelPrinter01
		 _PrintMgr_RemovePrinter($Printer215)
		 If Not @error Then
			GUICtrlSetState($ButtonAddPrinter01, $GUI_ENABLE)
			GUICtrlSetState($ButtonDelPrinter01, $GUI_DISABLE)
			GUICtrlSetState($ButtonSetPrinter01, $GUI_DISABLE)
			MsgBox(8256, "删除打印机", "操作成功！")
		 Else
			GUICtrlSetState($ButtonDelPrinter01, $GUI_DISABLE)
			MsgBox(16, "删除打印机", "操作失败，请联系IT处理。")
		 EndIf
   Case $iMsg = $ButtonDelPrinter02
		 _PrintMgr_RemovePrinter($Printer216)
		 If Not @error Then
			GUICtrlSetState($ButtonAddPrinter02, $GUI_ENABLE)
			GUICtrlSetState($ButtonDelPrinter02, $GUI_DISABLE)
			GUICtrlSetState($ButtonSetPrinter02, $GUI_DISABLE)
			MsgBox(8256, "删除打印机", "操作成功！")
		 Else
			GUICtrlSetState($ButtonDelPrinter02, $GUI_DISABLE)
			MsgBox(16, "删除打印机", "操作失败，请联系IT处理。")
		 EndIf
   Case $iMsg = $ButtonDelPrinter03
		 _PrintMgr_RemovePrinter($Printer252)
		 If Not @error Then
			GUICtrlSetState($ButtonAddPrinter03, $GUI_ENABLE)
			GUICtrlSetState($ButtonDelPrinter03, $GUI_DISABLE)
			GUICtrlSetState($ButtonSetPrinter03, $GUI_DISABLE)
			MsgBox(8256, "删除打印机", "操作成功！")
		 Else
			GUICtrlSetState($ButtonDelPrinter03, $GUI_DISABLE)
			MsgBox(16, "删除打印机", "操作失败，请联系IT处理。")
		 EndIf

   Case $iMsg = $Button21
		 cbpShortcut()

   Case $iMsg = $Button22
		 Local $ChromeReg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome", "UninstallString")
		 If Not @error Then
			MsgBox(16, "安装谷歌浏览器", "检测到系统已经安装了Chrome浏览器。")
		 Else
			ChromeSetup()
		 EndIf

   Case $iMsg = $Button23
		 Local $FirefoxReg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe", "")
		 If Not @error Then
			MsgBox(16, "安装火狐浏览器", "检测到系统已经安装了火狐浏览器。")
		 Else
			FirefoxSetup()
		 EndIf

   Case $iMsg = $Button24
		 Local $FirefoxReg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\eyeBeam 1.5_is1", "UninstallString")
		 If Not @error Then
			MsgBox(16, "程序按装", "检测到系统已经安装了EyeBeam 软件。")
		 Else
			EyeBeamSetup()
		 EndIf


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

ChromeSetup()
Func ChromeSetup()
   Local $SourceSize = $SharePath & "\ChromeStandaloneSetup64.exe"
   Local $DestinationSize = @DesktopDir & "\ChromeStandaloneSetup64.exe"
   If Not FileExists($DestinationSize) Then
	  ;_FileCopy("\\10.80.7.252\File_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe", @DesktopDir)
	  CopyWithProg($SourceSize, $DestinationSize)
   EndIf
   While 1
	  If Not FileExists($DestinationSize) Then
		 Sleep(500)
	  Else
		 ExitLoop
	  EndIf
   WEnd
   Sleep(500)
   Run($DestinationSize)
   Sleep(3000)
   While 1
	  Local $ChromeReg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome", "UninstallString")
	  If @error Then
		 Sleep(1000)
	  Else
		 Local $hWnd = WinWaitActive("[CLASS:Chrome_WidgetWin_1]", "", 10)
		 ;Local $hWnd = WinWaitActive("欢迎使用 Chrome - Google Chrome", "", 2)
		 WinClose($hWnd)
		 MsgBox(8256, "程序安装", "谷歌浏览器安装成功。")
		 ExitLoop
	  EndIf
   WEnd

EndFunc

FirefoxSetup()
Func FirefoxSetup()

   Local $SourceSize = $SharePath & "\Firefox Setup 62.0.3.exe"
   Local $DestinationSize = @DesktopDir & "\Firefox Setup 62.0.3.exe"
   If Not FileExists($DestinationSize) Then
	  ;_FileCopy("\\10.80.7.252\File_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe", @DesktopDir)
	  CopyWithProg($SourceSize, $DestinationSize)
   EndIf
   While 1
	  If Not FileExists($DestinationSize) Then
		 Sleep(500)
	  Else
		 ExitLoop
	  EndIf
   WEnd
   Sleep(500)
   $Pid = Run($DestinationSize)
   WinWait("Mozilla Firefox 安装")
   Local $hWnd = WinGetHandle("Mozilla Firefox 安装")
   If Not @error Then
	  WinActivate($hWnd)
	  Send("!n")
	  Sleep(250)
	  Send("!n")
	  Sleep(250)
	  ControlClick($hWnd, "", "Button4")
	  Sleep(250)
	  Send("!i")
	  Sleep(250)
	  Send("!l")
   EndIf
   Local $hWnd = WinWait("Mozilla Firefox 安装 ", "Mozilla Firefox 已经安装至您的计算机。")
   WinActivate($hWnd)
   Sleep(250)
   Send("!f")
   Sleep(1000)
   If Not ProcessExists($Pid) Then
	  MsgBox(8256, "程序安装", "火狐浏览器安装成功。")
   EndIf

EndFunc

EyeBeamSetup()
Func EyeBeamSetup()
   Local $EyeBeamSN = "FU9E8UQKSFUNY73B2TH4CZB9SACZE84LDBXKXBQQ-Q3FH285YB2U6X7J3MW88559J"
   Local $SourceSize = $SharePath & "\eyeBeam1.5.exe"
   Local $DestinationSize = @DesktopDir & "\eyeBeam1.5.exe"
   If Not FileExists($DestinationSize) Then
	  ;_FileCopy("\\10.80.7.252\File_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe", @DesktopDir)
	  CopyWithProg($SourceSize, $DestinationSize)
   EndIf
   While 1
	  If Not FileExists($DestinationSize) Then
		 Sleep(500)
	  Else
		 ExitLoop
	  EndIf
   WEnd
   Sleep(500)
   Run($DestinationSize)
   Local $hWnd = WinWaitActive("安装程序 - eyeBeam", "", 5)
   If Not @error Then
	  WinActivate($hWnd)
	  Send("!n")
	  Sleep(250)
	  ControlClick($hWnd, "", "TRadioButton1")
	  Sleep(250)
	  Send("!n")
	  Sleep(250)
	  Send("!n")
	  Sleep(250)
	  Send("!n")
	  Local $hWnd = WinWaitActive("安装程序 - eyeBeam", "完成 eyeBeam 安装向导", 3)
	  Sleep(250)
	  Send("!f")
	  Local $hWnd = WinWaitActive("错误", "", 3)
	  If $hWnd == 0 Then
		 Local $Pid = ProcessExists("eyeBeam.exe")
		 If $Pid <> 0 Then
			ProcessClose("eyeBeam.exe")
			MsgBox(8256, "程序安装", "EyeBeam 众投软电话安装成功。")
		 EndIf
	  Else
		 Send("{ENTER}")
		 Sleep(250)
		 Local $hWnd = WinWaitActive("输入软件许可", "", 3)
		 If $hWnd == 0 Then
			MsgBox(8256, "程序安装", "EyeBeam 众投软电话安装成功。")
		 Else
			ControlSend($hWnd, "", "[CLASS:Edit; INSTANCE:1]", $EyeBeamSN)
			Sleep(250)
			Send("{ENTER}")
			Sleep(250)
		 EndIf
	  EndIf

	  Local $Pid = ProcessExists("eyeBeam.exe")
	  If $Pid <> 0 Then
		 ProcessClose("eyeBeam.exe")
	  EndIf
   Else
	  MsgBox(48, "Installation", "Installation failed.")
   EndIf


EndFunc


Func CopyWithProg($SourceSize, $DestinationSize)

   if $SourceSize ="" or $DestinationSize ="" then
	  SetError(1)
	  Return 0
   EndIf

   ;Local $Progress1 = GUICtrlCreateProgress(8, 56, 417, 25)
   Local $Form2 = GUICreate("复制文件", 400, 80, -1, -1)
   Local $lblProgress = GUICtrlCreateLabel("", 10, 10,380, 20)
   Local $Progress1 = GUICtrlCreateProgress(10, 40, 380, 30)
   ;Local $btnProgress = GUICtrlCreateButton("Close", 136, 88, 75, 25, 0)
   ;GUICtrlSetState($btnProgress,$GUI_DISABLE)
   GUISetState(@SW_SHOW)
   ; get file size in bytes
   Local $iProgress = FileGetSize($SourceSize) ;FileGetSize 的是一个数字，单位是bytes
   ;figure Number of 1k reads 换算成KB
   If $iProgress >1024 Then $iProgress = $iProgress / 1024
   Local $x,$pos,$retv
	   ;open source file
	   $hSource = FileOpen($SourceSize,16) ;过使用带有二进制标志(16)的FileOpen（），可以将文件读取为二进制（字节）数据
		if $hSource = 0 then Return SetError(2) ;如果 FileOpen 命令的返回值为0
		;open dest file overwrite or create if not exist
		$hDest = FileOpen($DestinationSize,10) ;以覆盖（2）或者新建（8）模式打开目标文件
		if $hDest =0  Then ;如果返回值0
			FileClose($hSource)
			Return SetError(3)
		EndIf
		;GUICtrlSetData($lblProgress,"正在复制 " & $SourceSize & @CRLF & @CRLF & " 到 " & @CRLF & @CRLF & $DestinationSize)
		GUICtrlSetData($lblProgress, "正在复制安装程序...")
		While 1
			;read 1k blocks
			$hSourceData =FileRead($hSource,1024) ;
			if @error = -1 then ;-1 = if end-of-file is reached ，-1表示到达文件末尾
				;write the last block
				$retv= FileWrite($hDest,($hSourceData))
				GUICtrlSetData($lblProgress,"复制完成.")
				Sleep(250)
				ExitLoop
			EndIf
		   ;increment progress bar
			$pos = $pos +(100/$iProgress)
			GUICtrlSetData($Progress1,$pos)
			if $iProgress <100 Then sleep(100) ; slow down progress so it can be seen
			;write block
			$retv= FileWrite($hDest,($hSourceData))
	   WEnd
		FileClose($hSource)
		FileClose($hDest)
		;GUICtrlSetState($btnProgress,$GUI_ENABLE)
;~ 		While 1
;~ 			Local $prgMsg = GUIGetMsg()
;~ 			if $prgMsg = $GUI_EVENT_CLOSE or $prgMsg= $btnProgress Then ExitLoop
;~ 			if $prgMsg = $GUI_EVENT_CLOSE Then ExitLoop
;~ 		   sleep(10)
;~ 	   WEnd
	GUIDelete($Form2)
 EndFunc

;~ _FileCopy("\\10.80.7.252\File_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe", @DesktopDir)
;~ Func _FileCopy()
;~     Local $FOF_RESPOND_YES = 16
;~     Local $FOF_SIMPLEPROGRESS = 256
;~     $winShell = ObjCreate("shell.application")
;~     $winShell.namespace($tofile).CopyHere($fromFile,$FOF_RESPOND_YES)
;~ EndFunc