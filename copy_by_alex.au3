#include <GUIConstants.au3>
#Include <APIFileReadWrite.au3>
#include <FileConstants.au3>

;Local $Source = "E:\sample\SubDir\UltraVNC_1_2_22_X64_Setup.exe"
Local $Source = "E:\sample\Total_Control_6_8_2_Install.exe"

Local $Dest = @DesktopDir & "\Total_Control_6_8_2_Install.exe"
CopyWithProg($Source,$Dest)
Exit

Func CopyWithProg($szSource, $szDest)

   if $szSource ="" or $szDest ="" then
	  SetError(1)
	  Return 0
   EndIf

   ;Local $Progress1 = GUICtrlCreateProgress(8, 56, 417, 25)
   Local $Form1 = GUICreate("Copy File", 369, 128, 193, 126)
   Local $lblProgress = GUICtrlCreateLabel("", 8, 16,355, 25)
   Local $Progress1 = GUICtrlCreateProgress(8, 56, 353, 17)
   Local $btnProgress = GUICtrlCreateButton("Close", 136, 88, 75, 25, 0)
   GUICtrlSetState($btnProgress,$GUI_DISABLE)
   GUISetState(@SW_SHOW)
   ; get file size in bytes
   Local $iProgress = FileGetSize($szSource) ;FileGetSize 的是一个数字，单位是bytes
   ;figure Number of 1k reads 换算成KB
   If $iProgress >1024 Then $iProgress = $iProgress / 1024
   Local $x,$pos,$retv
	   ;open source file
	   $hSource = FileOpen($szSource,16) ;过使用带有二进制标志(16)的FileOpen（），可以将文件读取为二进制（字节）数据
		if $hSource = 0 then Return SetError(2) ;如果 FileOpen 命令的返回值为0
		;open dest file overwrite or create if not exist
		$hDest = FileOpen($szDest,10) ;以覆盖（2）或者新建（8）模式打开目标文件
		if $hDest =0  Then ;如果返回值0
			FileClose($hSource)
			Return SetError(3)
		EndIf
		GUICtrlSetData($lblProgress,"正在复制 " & $szSource & " 到 " & $szDest)
		While 1
			;read 1k blocks
			$hSourceData =FileRead($hSource,1024) ;
			if @error = -1 then ;-1 = if end-of-file is reached ，-1表示到达文件末尾
				;write the last block
				$retv= FileWrite($hDest,($hSourceData))
				GUICtrlSetData($lblProgress,"Done.")
				ExitLoop
			EndIf
		   ;increment progress bar
			;$pos = $pos +(100/$iProgress)
			$pos = 100 * (100/$iProgress)
			GUICtrlSetData($Progress1,$pos)
			if $iProgress <100 Then sleep(10) ; slow down progress so it can be seen
			;write block
			$retv= FileWrite($hDest,($hSourceData))
	   WEnd
		FileClose($hSource)
		FileClose($hDest)
		GUICtrlSetState($btnProgress,$GUI_ENABLE)
		While 1
			Local $prgMsg = GUIGetMsg()
			if $prgMsg = $GUI_EVENT_CLOSE or $prgMsg= $btnProgress Then ExitLoop
			;if $prgMsg = $GUI_EVENT_CLOSE Then ExitLoop
		   sleep(10)
	   WEnd
	GUIDelete($Form1)
 EndFunc
