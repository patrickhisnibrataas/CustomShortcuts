;AHK v1

;I want to use Windows in English while at the same time only
;use Norwegian and Japanese keyboard. As the Japanese keyboard 
;overlaps with the English I do not need both.
;There seems to be no way to have the toggle shortcut only 
;select between keyboard of your choosing in Windows, unfortunately

global state := "0"

Capslock::
;MsgBox "Ctrl+0 captured. state is %state%"
if (state == "0")
{
    ;MsgBox "Japanese"
    SetDefaultKeyboard(0x0411)
    state := "1"
    return
}
else if (state == "1")
{
    ;MsgBox "Norwegian"
    SetDefaultKeyboard(0x0414)
    state := "0"
    return
}
else
{
    MsgBox "State unknown"
}

;https://www.autohotkey.com/boards/viewtopic.php?t=18519
SetDefaultKeyboard(LocaleID){
	Global
	SPI_SETDEFAULTINPUTLANG := 0x005A
	SPIF_SENDWININICHANGE := 2
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(Lan%LocaleID%, 4, 0)
	NumPut(LocaleID, Lan%LocaleID%)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &Lan%LocaleID%, "UInt", SPIF_SENDWININICHANGE)
	WinGet, windows, List
	Loop %windows% {
		PostMessage 0x50, 0, %Lan%, , % "ahk_id " windows%A_Index%
	}
}
return
