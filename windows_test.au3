#RequireAdmin
#include <MsgBoxConstants.au3>

Run(@DesktopDir & "\qhb-release-1.1.0.exe")
Local $hWnd = WinWait("企话宝 安装程序")
If IsHWnd($wHWnd) Then
   WinActivate($hWnd)
   Send("!n")
   Sleep(500)
   ControlClick($hWnd, "使快捷方式对所有用户都可用", "[CLASS:Button; INSTANCE:4]")
   Exit
   ;MsgBox(0, "", "捕捉到窗口")
Else
   MsgBox(0, "", "未捕捉到窗口")
EndIf



