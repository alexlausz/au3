#RequireAdmin
#include <MsgBoxConstants.au3>
Run(@DesktopDir & "\qhb-release-1.1.0.exe")
Local $hWnd = WinWait("企话宝 安装程序")
WinActivate($hWnd)
Send("!n")
Sleep(500)
ControlClick($hWnd, "使快捷方式对所有用户都可用", "[CLASS:Button; INSTANCE:4]")
Sleep(500)
Send("!n")
WinWait("企话宝 安装程序", "完成(&F)")
Send("!f")
Sleep(500)
Exit