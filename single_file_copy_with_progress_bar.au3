$sSource = "\\10.80.7.252\file_share\IT部\4.工具软件\ChromeStandaloneSetup64.exe"
$sTarget = @DesktopDir
_FileCopy($sSource, $sTarget)
Sleep(1000)
Func _FileCopy($sCopySource,$sCopyTargetDir)
    Local $FOF_RESPOND_YES = 16
    Local $FOF_SIMPLEPROGRESS = 256
    If Not FileExists($sCopyTargetDir) Then DirCreate($sCopyTargetDir)
    $winShell = ObjCreate("shell.application")
    $winShell.namespace($sCopyTargetDir).CopyHere($sCopySource,$FOF_RESPOND_YES)
EndFunc