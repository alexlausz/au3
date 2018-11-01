#RequireAdmin
Run(@DesktopDir & "\ChromeStandaloneSetup64.exe")
WinWaitActive("打开文件 - 安全警告", "", 5)
Send("!r")
Sleep(500)
Local $hWnd = WinWait("欢迎使用 Chrome - Google Chrome")
WinClose($hWnd)
Exit