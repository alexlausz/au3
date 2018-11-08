#CS

UDF title : Printmgr.au3

Available functions :
_Printmgr_AddLocalPort
_Printmgr_AddLPRPort
_PrintMgr_AddPrinter
_PrintMgr_AddPrinterDriver
_PrintMgr_AddTCPIPPrinterPort
_PrintMgr_AddWindowsPrinterConnection
_PrintMgr_CancelAllJobs
_Printmgr_EnumPorts
_PrintMgr_EnumPrinter
_PrintMgr_EnumPrinterConfiguration
_PrintMgr_EnumPrinterDriver
_PrintMgr_EnumPrinterProperties
_PrintMgr_EnumTCPIPPrinterPort
_Printmgr_Pause
_Printmgr_PortExists
_Printmgr_PrinterExists
_Printmgr_PrinterSetComment
_Printmgr_PrinterSetDriver
_Printmgr_PrinterSetPort
_Printmgr_PrinterShare
_Printmgr_PrintTestPage
_PrintMgr_RemoveLocalPort
_PrintMgr_RemoveLPRPort
_PrintMgr_RemovePrinter
_PrintMgr_RemovePrinterDriver
_PrintMgr_RemoveTCPIPPrinterPort
_PrintMgr_RenamePrinter
_Printmgr_Resume
_PrintMgr_SetDefaultPrinter
#CE




; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_AddLocalPort
; Description ...: Add a local port (for printing into a file)
; Syntax.........:  _Printmgr_AddLocalPort($sFileName)
; Parameters ....: $sFileName - Full file name (the directory must exist).
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_AddLocalPort($sFileName)
	If Not IsAdmin() Then Return SetError(1, 0, 0)
	Local $sDir = StringRegExpReplace($sFileName, "\\[^\\]+$", "")
	If $sDir = $sFileName Then $sDir = @ScriptDir
	If StringRegExp($sFileName, "\Q\/:*?""<>|\E") Then Return SetError(1, 0, 0)
	If NOT FileExists($sDir) Then Return SetError(1, 0, 0)
	Local $oShell = ObjCreate("shell.application")
	If NOT IsObj($oShell) Then Return SetError(1, 0, 0)
	$oShell.ServiceStop("spooler",false)
	Local $iRet = RegWrite("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ports", $sFileName, "REG_SZ", "")
	$oShell.ServiceStart("spooler",false)
	Return $iRet
EndFunc ; ==> _Printmgr_AddLocalPort

; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_AddLPRPort
; Description ...: Add a local port (for printing into a file)
; Syntax.........:  _Printmgr_AddLPRPort($sFileName)
; Parameters ....: $sFileName - Full file name (the directory must exist).
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_AddLPRPort($sLPRServer, $sPrinterName)
	If Not IsAdmin() Then Return SetError(1, 0, 0)
	Local $sPortName = $sLPRServer & ":" & $sPrinterName
	Local $sRegKey = "HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors\LPR Port\Ports"
	Local $aValues = [ ["", "EnableBannerPage", "REG_DWORD", 0], _
	                   ["", "HpUxCompatibility", "REG_DWORD", 0], _
	                   ["", "OldSunCompatibility", "REG_DWORD", 0], _
	                   ["", "Printer Name", "REG_SZ", $sPrinterName], _
	                   ["", "Server Name", "REG_SZ", $sLPRServer], _
	                   ["\Timeouts", "CommandTimeout", "REG_DWORD", 120], _
	                   ["\Timeouts", "DataTimeout", "REG_DWORD", 300]]

	If RegRead($sRegKey & "\" & $sPortName, "Printer Name") Then Return SetError(2, 0, 0)
	Local $oShell = ObjCreate("shell.application")
	If NOT IsObj($oShell) Then Return SetError(1, 0, 0)
	$oShell.ServiceStop("spooler",false)
	Local $iRet = 0
	For $i = 0 To UBound($aValues) - 1
		$iRet += RegWrite($sRegKey & "\" & $sPortName & $aValues[$i][0], $aValues[$i][1], $aValues[$i][2], $aValues[$i][3])
	Next
	If Not $iRet Then Return SetError(3, 0, 0)
	$oShell.ServiceStart("spooler",false)
	Return 1
EndFunc ; ==> _Printmgr_AddLPRPort

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_AddPrinter
; Description ...: Adds a Windows printer.
; Syntax.........: _PrintMgr_AddPrinter($sPrinterName, $sDriverName, $sPortName, $sLocation = '', $sComment = '')
; Parameters ....: $sPrinterName - Unique identifier of the printer on the system
;                  $sDriverName - Name of the Windows printer driver.
;                  $sPortName - Port that is used to transmit data to a printer
;                  $sLocation - Physical location of the printer (Example: Bldg. 38, Room 1164)
;                  $sComment - Comment for a print queue
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_AddPrinter($sPrinterName, $sDriverName, $sPortName, $sLocation = '', $sComment = '')
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinter = $oWMIService.Get("Win32_Printer").SpawnInstance_
    If NOT IsObj($oPrinter) Then Return SetError(1, 0, 0)
    $oPrinter.DriverName = $sDriverName
    $oPrinter.PortName   = $sPortName
    $oPrinter.DeviceID   = $sPrinterName
    $oPrinter.Location   = $sLocation
    $oPrinter.Comment    = $sComment
    $oPrinter.Put_
    Return _Printmgr_PrinterExists($sPrinterName)
EndFunc ; ==> _PrintMgr_AddPrinter

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_AddPrinterDriver
; Description ...: Adds a printer driver.
; Syntax.........: _PrintMgr_AddPrinterDriver($sDriverName, $sDriverPlatform, $sDriverPath, $sDriverInfName, $sVersion)
; Parameters ....: $sDriverName - Driver name for this printer
;                  $sDriverPlatform - Operating environments that the driver is intended for (Example: "Windows NT x86")
;                  $sDriverPath - Path for this printer driver -Example: "C:\\drivers\\pscript.dll")
;                  $sDriverInfName - Name of the INF file being used
;                  $sVersion - Operating system version for the printer driver
;                       0 = Win9x
;                       1 = Win351
;                       2 = NT40
;                       3 = Win2k
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_AddPrinterDriver($sDriverName, $sDriverPlatform, $sDriverPath, $sDriverInfName, $sVersion = "3")
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
	If Not StringRegExp($sVersion, "^[1-3]$") Then Return SetError(1, 0, 0)
    $oWMIService.Security_.Privileges.AddAsString ("SeLoadDriverPrivilege", True)
    Local $oDriver = $oWMIService.Get("Win32_PrinterDriver")
    If NOT IsObj($oDriver) Then Return SetError(1, 0, 0)
    $oDriver.Name = $sDriverName
    $oDriver.SupportedPlatform = $sDriverPlatform
    $oDriver.Version = $sVersion
    $oDriver.DriverPath = $sDriverPath
    $oDriver.Infname = $sDriverInfName
    Local $iRet = $oDriver.AddPrinterDriver($oDriver)
	Return ( $iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _PrintMgr_AddPrinterDriver

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_AddTCPIPPrinterPort
; Description ...: Adds a TCP printer port.
; Syntax.........: _PrintMgr_AddTCPIPPrinterPort($sPortName, $sPortIP, $sPortNunber)
; Parameters ....: $sPortName - Name of the port to create
;                  $sPortIP - IP Address of the port
;                  $sPortNumber - Port number
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_AddTCPIPPrinterPort($sPortName, $sPortIP, $sPortNumber)
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oNewPort = $oWMIService.Get ("Win32_TCPIPPrinterPort").SpawnInstance_
    If NOT IsObj($oNewPort) Then Return SetError(1, 0, 0)
    $oNewPort.Name = $sPortName
    $oNewPort.Protocol = 1
    $oNewPort.HostAddress = $sPortIP
    $oNewPort.PortNumber = $sPortNumber
    $oNewPort.SNMPEnabled = True
    $ret = $oNewPort.Put_
    Return 1
EndFunc ; ==> _PrintMgr_AddTCPIPPrinterPort

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_AddWindowsPrinterConnection
; Description ...: Provides a connection to an existing printer on the network, and adds it to the list of available printers.
; Syntax.........: _AddWindowsPrinterConnection($sPrinterPath)
; Parameters ....: $sPrinterPath - Path to the printer connection (must be an UNC path)
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_AddWindowsPrinterConnection($sPrinterPath)
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinter = $oWMIService.Get("Win32_Printer")
	If NOT IsObj($oPrinter) Then Return SetError(1, 0, 0)
    Local $iRet = $oPrinter.AddPrinterConnection($sPrinterPath)
	Return ( $iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _PrintMgr_AddWindowsPrinterConnection

; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_CancelAllJobs
; Description ...: Removes all jobs, including the one currently printing from the queue
; Syntax.........:  _Printmgr_CancelAllJobs($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer to removes all jobs from
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_CancelAllJobs($sPrinterName)
	Local $iRet = 1
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iRet = $oPrinter.CancelAllJobs()
	Next
	Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _Printmgr_CancelAllJobs

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_EnumPorts
; Description ...: Enumerates the ports that are available for printing on a specified server.
; Syntax ........: _Printmgr_EnumPorts()
; Parameters ....: None
; Return values .: Success - Returns a 2D array containing ports informations :
;                    $array[0][0] : 1st port name
;                    $array[0][1] : 1st monitor name
;                    $array[0][2] : 1st port description
;                    $array[0][3] : 1st port type (see remarks)
;                    $array[1][0] : 2nd port name
;                    $array[1][1] : ...
; Author ........: Danyfirex, jguinch
; Remarks .......: A port type can be a combination of the following values :
;                   PORT_TYPE_WRITE         (1)
;                   PORT_TYPE_READ          (2)
;                   PORT_TYPE_REDIRECTED    (4)
;                   PORT_TYPE_NET_ATTACHED  (8)
; ===============================================================================================================================
Func _Printmgr_EnumPorts()
	Local $ERROR_INSUFFICIENT_BUFFER = 122
	Local $tag_PORT_INFO_2 = "ptr pPortName;ptr pMonitorName;ptr pDescription;dword PortType;dword Reserved"
	Local $aRet = DllCall("winspool.drv", "bool", "EnumPortsW", "wstr", "", "dword", 2, "ptr", Null, "dword", 0, "dword*", 0, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aRetError = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Or $aRetError[0] <> $ERROR_INSUFFICIENT_BUFFER Then Return SetError(@error, @extended, 0)
	Local $iSizeNeeded = $aRet[5]
	Local $tPortInfoArray = DllStructCreate("byte[" & $iSizeNeeded & "]")
	Local $pPortInfoArray = DllStructGetPtr($tPortInfoArray)
	Local $aRet = DllCall("winspool.drv", "bool", "EnumPortsW", "wstr", "", "dword", 2, "ptr", $pPortInfoArray, "dword", $iSizeNeeded, "dword*", 0, "dword*", 0)
	If @error Or Not $aRet[6] Then Return SetError(@error, @extended, 0)
	Local $iNumberOfPortInfoStructures = $aRet[6]
	Local $aPorts[$iNumberOfPortInfoStructures][4]
	Local $t_PORT_INFO_2 = DllStructCreate($tag_PORT_INFO_2)
	Local $iPortInfoSize = DllStructGetSize($t_PORT_INFO_2)
	For $i = 0 To $iNumberOfPortInfoStructures - 1
		$t_PORT_INFO_2 = DllStructCreate($tag_PORT_INFO_2, $pPortInfoArray + ($i * $iPortInfoSize))
		$tPortName = DllStructCreate("wchar Data[512]", DllStructGetData($t_PORT_INFO_2, 1))
		$tMonitorName = DllStructCreate("wchar Data[256]", DllStructGetData($t_PORT_INFO_2, 2))
		$tPortDesc = DllStructCreate("wchar Data[256]", DllStructGetData($t_PORT_INFO_2, 3))
		$aPorts[$i][0] = DllStructGetData($tPortName, 1)
		$aPorts[$i][1] = DllStructGetData($tMonitorName, 1)
		$aPorts[$i][2] = DllStructGetData($tPortDesc, 1)
		$aPorts[$i][3] = DllStructGetData($t_PORT_INFO_2, 4)
		If $aPorts[$i][1] == 0 Then $aPorts[$i][1] = ""
		If $aPorts[$i][2] == 0 Then $aPorts[$i][2] = ""
	Next
	Return $aPorts
EndFunc

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_EnumPrinter
; Description ...: Enumerates all installed printers
; Syntax.........:  _PrintMgr_EnumPrinter()
; Parameters ....: $sPrinterName - Name of the printer to list.
;                  Defaut "" returns the list of all printers.
;                  $sPrinterName can be a part of a printer name like "HP*"
; Return values .: Success - Returns an array containing the printer list. See remarks.
;                  Failure - Returns 0 and set @error to non zero value
; Remarks........: The zeroth array element contains the number of printers.
;                  The function returns all installed printers for the user running the script.
; =================================================================================================
Func _PrintMgr_EnumPrinter($sPrinterName = "")
	Local $aRet[10], $sFilter, $iCount = 0
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	If $sPrinterName <> "" Then $sFilter = StringReplace(" Where Name like '" & $sPrinterName & "'", "*", "%")
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer" & $sFilter, "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iCount += 1
		If $iCount >= UBound($aRet) Then ReDim $aRet[UBound($aRet) * 2]
		$aRet[$iCount] = $oPrinter.Name
	Next
	Redim $aRet[$iCount + 1]
	$aRet[0] = $iCount
	Return $aRet
EndFunc ; ==> _PrintMgr_EnumPrinter

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_EnumPrinterConfiguration
; Description ...: Enumerates the configuration of printers
; Syntax.........:  _PrintMgr_EnumPrinterConfiguration([$sPrinterName])
; Parameters ....: $sPrinterName - Name of the printer to retrieve configuration.
;                  Defaut "" returns configuration for all printers
;                  $sPrinterName can be a part of a printer name like "HP*"
; Return values .: Success - Returns an array containing the configuration (see $aRet[$iCount - 1][X] lines in the function)
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_EnumPrinterConfiguration($sPrinterName = "")
    Local $nbCols = 33, $aRet[1][$nbCols], $sFilter, $i = 0, $iCount = 0
    Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
    If $sPrinterName <> "" Then $sFilter = StringReplace(" Where Name like '" & $sPrinterName & "'", "*", "%")
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrintersCfg = $oWMIService.ExecQuery ("Select * from Win32_PrinterConfiguration" & $sFilter, "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrintersCfg) Then Return SetError(1, 0, 0)
    For $oCfg in $oPrintersCfg
        $iCount += 1
		If $iCount > UBound($aRet) Then ReDim $aRet[UBound($aRet) * 2][$nbCols]
        $aRet[$iCount - 1][0]  = $oCfg.BitsPerPel
        $aRet[$iCount - 1][1]  = $oCfg.Caption
        $aRet[$iCount - 1][2]  = $oCfg.Collate
        $aRet[$iCount - 1][3]  = $oCfg.Color
        $aRet[$iCount - 1][4]  = $oCfg.Copies
        $aRet[$iCount - 1][5]  = $oCfg.Description
        $aRet[$iCount - 1][6]  = $oCfg.DeviceName
        $aRet[$iCount - 1][7]  = $oCfg.DisplayFlags
        $aRet[$iCount - 1][8]  = $oCfg.DisplayFrequency
        $aRet[$iCount - 1][9]  = $oCfg.DitherType
        $aRet[$iCount - 1][10] = $oCfg.DriverVersion
        $aRet[$iCount - 1][11] = $oCfg.Duplex
        $aRet[$iCount - 1][12] = $oCfg.FormName
        $aRet[$iCount - 1][13] = $oCfg.HorizontalResolution
        $aRet[$iCount - 1][14] = $oCfg.ICMIntent
        $aRet[$iCount - 1][15] = $oCfg.ICMMethod
        $aRet[$iCount - 1][16] = $oCfg.LogPixels
        $aRet[$iCount - 1][17] = $oCfg.MediaType
        $aRet[$iCount - 1][18] = $oCfg.Name
        $aRet[$iCount - 1][19] = $oCfg.Orientation
        $aRet[$iCount - 1][20] = $oCfg.PaperLength
        $aRet[$iCount - 1][21] = $oCfg.PaperSize
        $aRet[$iCount - 1][22] = $oCfg.PaperWidth
        $aRet[$iCount - 1][23] = $oCfg.PelsHeight
        $aRet[$iCount - 1][24] = $oCfg.PelsWidth
        $aRet[$iCount - 1][25] = $oCfg.PrintQuality
        $aRet[$iCount - 1][26] = $oCfg.Scale
        $aRet[$iCount - 1][27] = $oCfg.SettingID
        $aRet[$iCount - 1][28] = $oCfg.SpecificationVersion
        $aRet[$iCount - 1][29] = $oCfg.TTOption
        $aRet[$iCount - 1][30] = $oCfg.VerticalResolution
        $aRet[$iCount - 1][31] = $oCfg.XResolution
        $aRet[$iCount - 1][32] = $oCfg.YResolution
    Next
	Redim $aRet[$iCount][$nbCols]
    Return $aRet
EndFunc ; ==> _PrintMgr_EnumPrinterConfiguration

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_EnumPrinterDriver
; Description ...: Enumerates all installed printer drivers.
; Syntax.........: _PrintMgr_EnumPrinterDriver([$sPrinterName])
; Parameters ....: $sDriverName - Name of the driver to retrieve informations.
;                  Defaut "" returns informations for all drivers
;                  $sPrinterName can be a part of a printer name like "HP*"
; Return values .: Success - Returns an array containing all informations (see $aRet[$iCount - 1][X] lines in the function)
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_EnumPrinterDriver($sDriverName = "")
    Local $nbCols = 8, $aRet[1][$nbCols], $sFilter, $iCount = 0
    Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
    If $sDriverName <> "" Then $sFilter = StringReplace(" Where Name = '" & $sDriverName & "' Or Name Like '" & $sDriverName & ",%'", "*", "%")
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrintersDrv = $oWMIService.ExecQuery ("Select * from Win32_PrinterDriver" & $sFilter, "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrintersDrv) Then Return SetError(1, 0, 0)
    For $oDrv in $oPrintersDrv
        $iCount += 1
		If $iCount > UBound($aRet) Then ReDim $aRet[UBound($aRet) * 2][$nbCols]
        $aRet[$iCount - 1][0]  = $oDrv.ConfigFile
        $aRet[$iCount - 1][1]  = $oDrv.DataFile
        $aRet[$iCount - 1][2]  = $oDrv.DriverPath
        $aRet[$iCount - 1][3]  = __StringUnSplit ( $oDrv.DependentFiles )
        $aRet[$iCount - 1][4]  = $oDrv.HelpFile
        $aRet[$iCount - 1][5]  = $oDrv.MonitorName
        $aRet[$iCount - 1][6]  = $oDrv.Name
        $aRet[$iCount - 1][7]  = $oDrv.SupportedPlatform
    Next
	Redim $aRet[$iCount][$nbCols]
    Return $aRet
EndFunc ; ==> _PrintMgr_EnumPrinterDriver

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_EnumPrinterProperties
; Description ...: Enumerates all installed printers for the user executing the script.
; Syntax.........: _PrintMgr_EnumPrinterProperties([$sPrinterName])
; Parameters ....: $sPrinterName - Name of the printer to retrieve informations.
;                  Defaut "" returns informations for all printers
;                  $sPrinterName can be a part of a printer name like "HP*"
; Return values .: Success - Returns an array containing all informations (see $aRet[$iCount - 1][X] lines in the function)
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_EnumPrinterProperties($sPrinterName = "")
    Local $nbCols = 86, $aRet[1][$nbCols], $sFilter, $iCount = 0
    Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
    If $sPrinterName <> "" Then $sFilter = StringReplace(" Where DeviceID like '" & $sPrinterName & "'", "*", "%")
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer" & $sFilter, "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
    For $oPrinter in $oPrinters
        $iCount += 1
		If $iCount > UBound($aRet) Then ReDim $aRet[UBound($aRet) * 2][$nbCols]
        $aRet[$iCount - 1][0]  = $oPrinter.Attributes
        $aRet[$iCount - 1][1]  = $oPrinter.Availability
        $aRet[$iCount - 1][2]  = __StringUnSplit ($oPrinter.AvailableJobSheets )
        $aRet[$iCount - 1][3]  = $oPrinter.AveragePagesPerMinute
        $aRet[$iCount - 1][4]  = __StringUnSplit ($oPrinter.Capabilities)
        $aRet[$iCount - 1][5]  = __StringUnSplit ($oPrinter.CapabilityDescriptions)
        $aRet[$iCount - 1][6]  = $oPrinter.Caption
        $aRet[$iCount - 1][7]  = __StringUnSplit ($oPrinter.CharSetsSupported)
        $aRet[$iCount - 1][8]  = $oPrinter.Comment
        $aRet[$iCount - 1][9]  = $oPrinter.ConfigManagerErrorCode
        $aRet[$iCount - 1][10] = $oPrinter.ConfigManagerUserConfig
        $aRet[$iCount - 1][11] = $oPrinter.CreationClassName
        $aRet[$iCount - 1][12] = __StringUnSplit ($oPrinter.CurrentCapabilities)
        $aRet[$iCount - 1][13] = $oPrinter.CurrentCharSet
        $aRet[$iCount - 1][14] = $oPrinter.CurrentLanguage
        $aRet[$iCount - 1][15] = $oPrinter.CurrentMimeType
        $aRet[$iCount - 1][16] = $oPrinter.CurrentNaturalLanguage
        $aRet[$iCount - 1][17] = $oPrinter.CurrentPaperType
        $aRet[$iCount - 1][18] = $oPrinter.Default
        $aRet[$iCount - 1][19] = __StringUnSplit ($oPrinter.DefaultCapabilities)
        $aRet[$iCount - 1][20] = $oPrinter.DefaultCopies
        $aRet[$iCount - 1][21] = $oPrinter.DefaultLanguage
        $aRet[$iCount - 1][22] = $oPrinter.DefaultMimeType
        $aRet[$iCount - 1][23] = $oPrinter.DefaultNumberUp
        $aRet[$iCount - 1][24] = $oPrinter.DefaultPaperType
        $aRet[$iCount - 1][25] = $oPrinter.DefaultPriority
        $aRet[$iCount - 1][26] = $oPrinter.Description
        $aRet[$iCount - 1][27] = $oPrinter.DetectedErrorState
        $aRet[$iCount - 1][28] = $oPrinter.DeviceID
        $aRet[$iCount - 1][29] = $oPrinter.Direct
        $aRet[$iCount - 1][30] = $oPrinter.DoCompleteFirst
        $aRet[$iCount - 1][31] = $oPrinter.DriverName
        $aRet[$iCount - 1][32] = $oPrinter.EnableBIDI
        $aRet[$iCount - 1][33] = $oPrinter.EnableDevQueryPrint
        $aRet[$iCount - 1][34] = $oPrinter.ErrorCleared
        $aRet[$iCount - 1][35] = $oPrinter.ErrorDescription
        $aRet[$iCount - 1][36] = __StringUnSplit ($oPrinter.ErrorInformation)
        $aRet[$iCount - 1][37] = $oPrinter.ExtendedDetectedErrorState
        $aRet[$iCount - 1][38] = $oPrinter.ExtendedPrinterStatus
        $aRet[$iCount - 1][39] = $oPrinter.Hidden
        $aRet[$iCount - 1][40] = $oPrinter.HorizontalResolution
        $aRet[$iCount - 1][41] = $oPrinter.InstallDate
        $aRet[$iCount - 1][42] = $oPrinter.JobCountSinceLastReset
        $aRet[$iCount - 1][43] = $oPrinter.KeepPrintedJobs
        $aRet[$iCount - 1][44] = __StringUnSplit ($oPrinter.LanguagesSupported)
        $aRet[$iCount - 1][45] = $oPrinter.LastErrorCode
        $aRet[$iCount - 1][46] = $oPrinter.Local
        $aRet[$iCount - 1][47] = $oPrinter.Location
        $aRet[$iCount - 1][48] = $oPrinter.MarkingTechnology
        $aRet[$iCount - 1][49] = $oPrinter.MaxCopies
        $aRet[$iCount - 1][50] = $oPrinter.MaxNumberUp
        $aRet[$iCount - 1][51] = $oPrinter.MaxSizeSupported
        $aRet[$iCount - 1][52] = __StringUnSplit ($oPrinter.MimeTypesSupported)
        $aRet[$iCount - 1][53] = $oPrinter.Name
        $aRet[$iCount - 1][54] = __StringUnSplit ($oPrinter.NaturalLanguagesSupported)
        $aRet[$iCount - 1][55] = $oPrinter.Network
        $aRet[$iCount - 1][56] = __StringUnSplit ($oPrinter.PaperSizesSupported)
        $aRet[$iCount - 1][57] = __StringUnSplit ($oPrinter.PaperTypesAvailable)
        $aRet[$iCount - 1][58] = $oPrinter.Parameters
        $aRet[$iCount - 1][59] = $oPrinter.PNPDeviceID
        $aRet[$iCount - 1][60] = $oPrinter.PortName
        $aRet[$iCount - 1][61] = __StringUnSplit ($oPrinter.PowerManagementCapabilities)
        $aRet[$iCount - 1][62] = $oPrinter.PowerManagementSupported
        $aRet[$iCount - 1][63] = __StringUnSplit ($oPrinter.PrinterPaperNames)
        $aRet[$iCount - 1][64] = $oPrinter.PrinterState
        $aRet[$iCount - 1][65] = $oPrinter.PrinterStatus
        $aRet[$iCount - 1][66] = $oPrinter.PrintJobDataType
        $aRet[$iCount - 1][67] = $oPrinter.PrintProcessor
        $aRet[$iCount - 1][68] = $oPrinter.Priority
        $aRet[$iCount - 1][69] = $oPrinter.Published
        $aRet[$iCount - 1][70] = $oPrinter.Queued
        $aRet[$iCount - 1][71] = $oPrinter.RawOnly
        $aRet[$iCount - 1][72] = $oPrinter.SeparatorFile
        $aRet[$iCount - 1][73] = $oPrinter.ServerName
        $aRet[$iCount - 1][74] = $oPrinter.Shared
        $aRet[$iCount - 1][75] = $oPrinter.ShareName
        $aRet[$iCount - 1][76] = $oPrinter.SpoolEnabled
        $aRet[$iCount - 1][77] = $oPrinter.StartTime
        $aRet[$iCount - 1][78] = $oPrinter.Status
        $aRet[$iCount - 1][79] = $oPrinter.StatusInfo
        $aRet[$iCount - 1][80] = $oPrinter.SystemCreationClassName
        $aRet[$iCount - 1][81] = $oPrinter.SystemName
        $aRet[$iCount - 1][82] = $oPrinter.TimeOfLastReset
        $aRet[$iCount - 1][83] = $oPrinter.UntilTime
        $aRet[$iCount - 1][84] = $oPrinter.VerticalResolution
        $aRet[$iCount - 1][85] = $oPrinter.WorkOffline
    Next
	Redim $aRet[$iCount][$nbCols]
    Return $aRet
EndFunc ; ==> _PrintMgr_EnumPrinterProperties

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_EnumTCPIPPrinterPort
; Description ...: Enumerates all defined TCP printer ports.
; Syntax.........: _PrintMgr_EnumTCPIPPrinterPort()
; Parameters ....: None
; Return values .: Success - Returns a 2D array containing all informations, in this form :
;                    $aRet[0][0] : 1st port name
;                    $aRet[0][1] : 1st host address
;                    $aRet[0][2] : 1st port number
;                    $aRet[1][0] : 2nd port name
;                    ...
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_EnumTCPIPPrinterPort()
	Local $aRet[1][3], $i = 0
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinterPorts =  $oWMIService.ExecQuery ("Select * from Win32_TCPIPPrinterPort")
    If NOT IsObj($oPrinterPorts) Then Return SetError(1, 0, 0)
    For $oPort in $oPrinterPorts
        Redim $aRet[$i + 1][3]
		$aRet[$i][0] = $oPort.Name
		$aRet[$i][1] = $oPort.HostAddress
		$aRet[$i][2] = $oPort.PortNumber
		$i += 1
    Next
	If $i = 0 Then Return SetError(2, 0, 0)
    Return $aRet
EndFunc ; ==> _PrintMgr_EnumTCPIPPrinterPort

; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_Pause
; Description ...: Pauses the print queue. No jobs can print until the queue is resumed.
; Syntax.........:  _Printmgr_Pause($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_Pause($sPrinterName)
	Local $iRet = 1
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iRet = $oPrinter.Pause()
	Next
	Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _Printmgr_Pause

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_PortExists
; Description ...: Checks if the specified printer port name exists.
; Syntax ........: _Printmgr_PortExists($sPortName)
; Parameters ....: $sPortName           - Port name.
; Return values .: Success - Returns 1
;                  Failure - Returns 0
; ===============================================================================================================================
Func _Printmgr_PortExists($sPortName)
	Local $aPorts = _Printmgr_EnumPorts()
	If @error Then Return SetError(@error, 0, 0)
	For $i = 0 To UBound($aPorts) - 1
		If $aPorts[$i][0] = $sPortName Then Return 1
	Next
	Return 0
EndFunc

; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_PrinterExists
; Description ...: Checks if the specified printer exists
; Syntax.........:  _Printmgr_PrinterExists($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_PrinterExists($sPrinterName)
	Local $iRet = 0
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iRet = 1
	Next
	Return $iRet
EndFunc ; ==> _Printmgr_PrinterExists

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_PrinterSetComment
; Description ...: Sets the comment for a print queue.
; Syntax ........: _Printmgr_PrinterSetComment($sPrinterName, $sDriverName)
; Parameters ....: $sPrinterName        - Name of the printer.
;                  $sComment            - Comment
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; ===============================================================================================================================
Func _Printmgr_PrinterSetComment($sPrinterName, $sComment)
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(2, 0, 0)
	$oWMIService.Security_.Privileges.AddAsString ("SeLoadDriverPrivilege", True)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(3, 0, 0)
	For $oPrinter in $oPrinters
		$oPrinter.Comment = $sComment
		Execute("$oPrinter.Put_")
		ExitLoop
	Next

	Local $oPrinter = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "' And Comment like '" & $sComment & "'", "WQL")
	Return $oPrinter.Count
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_PrinterSetDriver
; Description ...: Sets the driver of the specified printer to the specified driver name.
; Syntax ........: _Printmgr_PrinterSetDriver($sPrinterName, $sDriverName)
; Parameters ....: $sPrinterName        - Name of the printer.
;                  $sDriverName         - Name of the driver.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; ===============================================================================================================================
Func _Printmgr_PrinterSetDriver($sPrinterName, $sDriverName)
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(2, 0, 0)
	$oWMIService.Security_.Privileges.AddAsString ("SeLoadDriverPrivilege", True)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(3, 0, 0)
	For $oPrinter in $oPrinters
		$oPrinter.DriverName = $sDriverName
		Execute("$oPrinter.Put_")
		ExitLoop
	Next

	Local $oPrinter = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "' And DriverName like '" & $sDriverName & "'", "WQL")
	Return $oPrinter.Count
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_PrinterSetPort
; Description ...: Set the port of the specified printer to the specified port name.
; Syntax ........: _Printmgr_PrinterSetPort($sPrinterName, $sPortName)
; Parameters ....: $sPrinterName        - Name of the printer.
;                  $sPortName           - Name of the printer port.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; ===============================================================================================================================
Func _Printmgr_PrinterSetPort($sPrinterName, $sPortName)
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(2, 0, 0)
	$oWMIService.Security_.Privileges.AddAsString ("SeLoadDriverPrivilege", True)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(3, 0, 0)
	For $oPrinter in $oPrinters
		$oPrinter.PortName = $sPortName
		Execute("$oPrinter.Put_")
		ExitLoop
	Next

	Local $oPrinter = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "' And PortName like '" & $sPortName & "'", "WQL")
	Return $oPrinter.Count
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Printmgr_PrinterShare
; Description ...: Set the printer as shared or not shared.
; Syntax ........: _Printmgr_PrinterShare($sPrinterName, $iShared, $sShareName)
; Parameters ....: $sPrinterName        - Name of the printer.
;                  $iShared             - State of the share :
;                                          1 - Shared
;                                          0 - Not shared
;                  $sShareName          - Share name of the printer. Leave empty if $iShared = 0
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; ===============================================================================================================================
Func _Printmgr_PrinterShare($sPrinterName, $iShared, $sShareName)
	$iShared = $iShared ? True : False
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(2, 0, 0)
	$oWMIService.Security_.Privileges.AddAsString ("SeLoadDriverPrivilege", True)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(3, 0, 0)
	For $oPrinter in $oPrinters
		$oPrinter.Shared = $iShared
		If $iShared Then $oPrinter.ShareName = $sShareName
		Execute("$oPrinter.Put_")
		ExitLoop
	Next

	Local $sQuery = "Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "' And Shared = " & $iShared
	If $iShared Then $sQuery &= " and ShareName like '" & $sShareName & "'"
	Local $oPrinter = $oWMIService.ExecQuery ($sQuery, "WQL")
	Return $oPrinter.Count
EndFunc


; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_PrintTestPage
; Description ...: Prints a test page using the specifed printer
; Syntax.........:  _Printmgr_PrintTestPage($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_PrintTestPage($sPrinterName)
	Local $iRet = 1
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iRet = $oPrinter.PrintTestPage()
	Next
	Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _Printmgr_PrintTestPage

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RemoveLocalPort
; Description ...: Removes a local port (created with _AddLocalPrinterPort)
; Syntax.........:  _PrintMgr_RemoveLocalPort($sPortName)
; Parameters ....: $sPortName - Port name.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RemoveLocalPort($sPortName)
	If Not IsAdmin() Then Return SetError(1, 0, 0)
	If StringRegExp($sPortName, ":$") Then Return SetError(2, 0, 0)
	Local $oShell = ObjCreate("shell.application")
	If NOT IsObj($oShell) Then Return SetError(3, 0, 0)
	$oShell.ServiceStop("spooler",false)
	Local $iRet = RegDelete("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ports", $sPortName)
	$oShell.ServiceStart("spooler",false)
	Return $iRet
EndFunc ; ==> _PrintMgr_RemoveLocalPort

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RemoveLPRPort
; Description ...: Removes a local port (created with _AddLocalPrinterPort)
; Syntax.........:  _PrintMgr_RemoveLocalPort($sPortName)
; Parameters ....: $sPortName - Port name.
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RemoveLPRPort($sPortName)
	If Not IsAdmin() Then Return SetError(1, 0, 0)
	Local $sRegKey = "HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors\LPR Port\Ports"
	Local $oShell = ObjCreate("shell.application")
	If NOT IsObj($oShell) Then Return SetError(2, 0, 0)
	$oShell.ServiceStop("spooler",false)
	Local $iRet = RegDelete($sRegKey & "\" & $sPortName)
	$oShell.ServiceStart("spooler",false)
	Return $iRet
EndFunc ; ==> _PrintMgr_RemoveLPRPort

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RemovePrinter
; Description ...: Removes a printer.
; Syntax.........:  _PrintMgr_RemovePrinter($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer to remove (use \\server\printerShare for shared printers)
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RemovePrinter($sPrinterName)
	$sPrinterName = StringReplace($sPrinterName, "\", "\\")
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters =  $oWMIService.ExecQuery ("Select * from Win32_Printer where DeviceID = '" & $sPrinterName & "'")
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
    For $oPrinter in $oPrinters
        $oPrinter.Delete_()
    Next
	Return ( _Printmgr_PrinterExists($sPrinterName) ? 0 : 1)
EndFunc ; ==> _PrintMgr_RemovePrinter

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RemovePrinterDriver
; Description ...: Removes a printer driver.
; Syntax.........:  _PrintMgr_RemovePrinterDriver($sDriverName)
; Parameters ....: $sDriverName - Name of the printer driver
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RemovePrinterDriver($sDriverName)
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrintersDrv =  $oWMIService.ExecQuery ("Select * from Win32_PrinterDriver Where Name like '" & $sDriverName & ",%'")
    If NOT IsObj($oPrintersDrv) Then Return SetError(1, 0, 0)
    For $oDrv in $oPrintersDrv
        $oDrv.Delete_()
    Next
    Return 1
EndFunc ; ==> _PrintMgr_RemovePrinterDriver

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RemoveTCPIPPrinterPort
; Description ...: Removes a TCP printer port.
; Syntax.........: _PrintMgr_RemoveTCPIPPrinterPort($sPortName)
; Parameters ....: $sPortName - Name of the port to remove
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RemoveTCPIPPrinterPort($sPortName)
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinterPorts =  $oWMIService.ExecQuery ("Select * from Win32_TCPIPPrinterPort where Name = '" & $sPortName & "'")
    If NOT IsObj($oPrinterPorts) Then Return SetError(1, 0, 0)
    For $oPort in $oPrinterPorts
        $oPort.Delete_()
    Next
    Return 1
EndFunc ; ==> _PrintMgr_RemoveTCPIPPrinterPort

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_RenamePrinter
; Description ...: Remames a printer.
; Syntax.........:  _PrintMgr_RenamePrinter($sPrinterName, $sPrinterNewName)
; Parameters ....: $sPrinterName - Name of the printer to rename
;                  $sPrinterNewName - New printer name
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_RenamePrinter($sPrinterName, $sPrinterNewName)
	$sPrinterName = StringReplace($sPrinterName, "\", "\\")
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters =  $oWMIService.ExecQuery ("Select * from Win32_Printer where DeviceID = '" & $sPrinterName & "'")
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
    For $oPrinter in $oPrinters
        $iRet = $oPrinter.RenamePrinter($sPrinterNewName)
    Next
    Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _PrintMgr_RenamePrinter

; #FUNCTION# ======================================================================================
; Name...........: _Printmgr_Resume
; Description ...: Resumes a paused print queue.
; Syntax.........:  _Printmgr_Resume($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _Printmgr_Resume($sPrinterName)
	Local $iRet = 1
	Local Const $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer Where DeviceID like '" & $sPrinterName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
	For $oPrinter in $oPrinters
		$iRet = $oPrinter.Resume()
	Next
	Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _Printmgr_Resume

; #FUNCTION# ======================================================================================
; Name...........: _PrintMgr_SetDefaultPrinter
; Description ...: Sets the default system printer
; Syntax.........: _PrintMgr_SetDefaultPrinter($sPrinterName)
; Parameters ....: $sPrinterName - Name of the printer
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and set @error to non zero value
; =================================================================================================
Func _PrintMgr_SetDefaultPrinter($sPrinterName)
	Local $iRet = 1
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If NOT IsObj($oWMIService) Then Return SetError(1, 0, 0)
    Local $oPrinters = $oWMIService.ExecQuery ("Select * from Win32_Printer where DeviceID = '" & $sPrinterName & "'")
    If NOT IsObj($oPrinters) Then Return SetError(1, 0, 0)
    For $oPrinter in $oPrinters
        $iRet = $oPrinter.SetDefaultPrinter()
    Next
    Return ($iRet = 0 ? 1 : SetError($iRet, 0, 0))
EndFunc ; ==> _PrintMgr_SetDefaultPrinter

; #INTERNAL_USE_ONLY# ===========================================================================================================
Func __ErrFunc($oError)
    Local $txt = "Error number : " & $oError.number & @CRLF & _
            "WinDescription:" & @TAB & $oError.windescription & @CRLF & _
            "Description : " & @TAB & $oError.description & @CRLF & _
            "Source : " & @TAB & $oError.source
    ConsoleWrite(@CRLF & "Object error :" & @CRLF & $txt & @CRLF)
EndFunc ; ==> _ErrFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
Func __StringUnSplit($aVal, $sSep = ";")
    If NOT IsArray($aVal) Then Return SetError(1, 0, 0)
    Local $sReturn = ""
    For $i = 0 To UBound($aVal) - 1
        If $i = 0 Then
            $sReturn = $aVal[$i]
        Else
            $sReturn &= $sSep & $aVal[$i]
        EndIf
    Next
    Return $sReturn
EndFunc ; ==> __StringUnSplit
