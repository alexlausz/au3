#include <PrintMgr.au3>
#include <Constants.au3>
#Include <Array.au3>

$aPrinterConfig = _PrintMgr_EnumPrinterConfiguration()
_ArrayDisplay($aPrinterConfig)

;~ $aPrinterList = _PrintMgr_EnumPrinter()
;~ ;_ArrayDisplay($aPrinterList)

;~ Local Const $Printer215 = "\\10.80.7.247\Canon_C5255_2.15"
;~ Local Const $Printer216 = "\\10.80.7.247\Canon_C5255_2.16"
;~ Local Const $Printer252 = "\\10.80.7.247\Canon_C5255_2.252"

;~ _ArraySearch($aPrinterList, $Printer215)
;~ If @error Then
;~     MsgBox(16, "已安装的打印机", "未找到编号为No.1的网络打印机")
;~  Else
;~ 	;MsgBox(8256,"设置打印机", "设置默认按钮可见")
;~ 	;_PrintMgr_SetDefaultPrinter($Printer215)
;~ 	_PrintMgr_RemovePrinter($Printer215)
;~  EndIf
