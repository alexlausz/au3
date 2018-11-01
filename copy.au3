#include "D:\temp\Copy.au3"
#Include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <Constants.au3>

; 先映射好网络盘，以便后面复制安装程序
; RunWait(@ComSpec & " /c net use * /del /yes", @SW_HIDE)
; RunWait(@ComSpec & ' /c net use K: \\10.80.7.252\file_share "bill@123admin" /user:by\byadmin /persistent:no', @SW_HIDE)

Opt('TrayAutoPause', 0)

$Source1 = '\\10.80.7.252\file_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe'
$Destination1 = @DesktopDir

$Source2 = '\\10.80.7.252\file_share\IT部\4.工具软件\qhb-release-1.1.0.exe'
;$Destination2 = 'C:\Test2 (2).tmp'

_Copy_OpenDll()
_Copy_CopyFile($Source1, $Destination1, 0, 0)
_Copy_CopyFile($Source2, $Destination1, 0, 1)
Do
    Sleep(250)
    $State1 = _Copy_GetState(0)
    $State2 = _Copy_GetState(1)
    ConsoleWrite(StringFormat('%.2f%   %.2f%', $State1[1] / $State1[2] * 100, $State2[1] / $State2[2] * 100) & @CR)
    If _IsPressed('1B') Then
        _Copy_Abort(0)
        _Copy_Abort(1)
    EndIf
Until (Not $State1[0]) And (Not $State2[0])
ConsoleWrite('Return code #1: ' & $State1[5] & @CR)
ConsoleWrite('Return code #2: ' & $State2[5] & @CR)
_Copy_CloseDll()