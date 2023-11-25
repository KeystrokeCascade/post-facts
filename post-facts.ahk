#NoEnv
SendMode Input
RunAs, Administrator

Gui, Add, Text,, What facts would you like posted?`nTo cancel, press [ESCAPE] or close this window
Gui, Add, ListBox, vMyListBox gMyListBox w230 r10
Gui, Add, Button, Default, OK
Loop, Facts\*.*
{
	files := A_LoopFileName
	files := StrReplace(files, ".txt")
	StringLower, files, files, T
	GuiControl,, MyListBox, %files%
}
Gui, Show
return

MyListBox:
if A_GuiEvent <> DoubleClick
	return
ButtonOK:
GuiControlGet, MyListBox
Gui Destroy

fact_title := MyListBox
selected_fact = %MyListBox%.txt
StringLower, selected_fact, selected_fact

try
{
	FileRead, null, Facts\%selected_fact%
} catch {
	MsgBox, This is not a valid file
	return
}

Facts := []
Loop, Read, Facts\%selected_fact%
{
	Facts.Push(A_LoopReadLine)
}

Gui, Add, Text,, Do you want automatic or manual posting?
Gui, Add, Button, x10 y30 w100 h30 gManual, Manual
Gui, Add, Button, x+0 w100 h30 gAutomatic, Automatic
Gui, Show
return

Manual:
Gui, Destroy
MsgBox, Facts loaded!`nPress [TAB] to begin posting
	
KeyWait, Tab, D
BlockInput, On
send, {BackSpace}
send ``Thank you for subscribing to "Key's fun facts about %fact_title%"``{enter}
for index, element in Facts {
	BlockInput, Off
	KeyWait, Tab, D
	BlockInput, On
	send, {BackSpace}
	send, % "``````" index ". " element "``````{enter}"
	sleep, 500
}
BlockInput, Off
KeyWait, Tab, D
send, {BackSpace}
send ``This has been "Key's fun facts about %fact_title%"``
ExitApp
return

Automatic:
Gui, Destroy
InputBox, Secs,, Please input the time in between posts in seconds (minimum 1 second),, 250, 150
if ErrorLevel
    ExitApp

Secs := Secs*1
if (Secs is number) {
	if (Secs >= 1) {
		Millisecs := Secs*1000
	} else {
		Millisecs := 1000
	}
} else {
	MsgBox, Invalid time`nClosing program
	ExitApp
}

MsgBox, Facts loaded!`nPress [Tab] to begin posting

KeyWait, Tab, D
BlockInput, On
send, {BackSpace}
send ``Thank you for subscribing to "Key's fun facts about %fact_title%"``{enter}
for index, element in Facts {
	BlockInput, On
	send, % "``````" index ". " element "``````{enter}"
	BlockInput, Off
	sleep, %Millisecs%
}
send ``This has been "Key's fun facts about %fact_title%"``
ExitApp
return

GuiClose:
GuiEscape:
ExitApp
Esc::ExitApp
