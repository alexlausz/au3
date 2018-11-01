#include <D:\github\au3\HotKey_21b.au3>
#RequireAdmin


Global Const $VK_ESCAPE = 0x1B
Global Const $VK_F12 = 0x7B

; Assign "F12" with Message() and set extended function call
_HotKey_Assign($VK_F12, 'Message', BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; Assign "CTRL-ESC" with Quit()
_HotKey_Assign(BitOR($CK_CONTROL, $VK_ESCAPE), 'Quit')


Local $i = 0
While $i <= 10


Func alex()
   Local $i = 0
   While $i <= 10
	  WinWaitActive("佰赢资产_分机号总表_backup.xlsx - Excel","")
	  MouseClick("left",502,12,1)
	  Sleep(250)
	  Send("{CTRLDOWN}c{CTRLUP}")
	  Sleep(250)
	  WinWaitActive("OK-CC呼叫中心系统 - Google Chrome","")
	  MouseClick("left",716,8,1)
	  Sleep(250)
	  MouseClick("left",1085,226,1)
	  Sleep(250)
	  MouseClick("left",877,264,2)
	  Sleep(250)
	  Send("{CTRLDOWN}v{CTRLUP}")
	  Sleep(250)
	  MouseClick("left",841,491,1)
	  Sleep(250)
	  WinWaitActive("佰赢资产_分机号总表_backup.xlsx - Excel","")
	  MouseClick("left",511,10,1)
	  Sleep(250)
	  Send("{RIGHT}{CTRLDOWN}c{CTRLUP}")
	  Sleep(250)
	  WinWaitActive("OK-CC呼叫中心系统 - Google Chrome","")
	  MouseClick("left",719,10,1)
	  Sleep(250)
	  MouseClick("left",1084,347,1)
	  Sleep(250)
	  MouseClick("left",540,322,1)
	  Sleep(250)
	  Send("{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{CTRLDOWN}v{CTRLUP}")
	  Sleep(250)
	  MouseClick("left",723,920,1)
	  Sleep(250)
	  WinWaitActive("佰赢资产_分机号总表_backup.xlsx - Excel","")
	  MouseClick("left",500,10,1)
	  Sleep(250)
	  Send("{DOWN}{LEFT}")
	  Sleep(250)
	  $i = $i + 1
   WEnd
    ;MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
EndFunc

Func Quit()
    Exit
EndFunc   ;==>Quit