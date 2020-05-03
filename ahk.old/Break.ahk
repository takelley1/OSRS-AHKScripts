#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ;Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetTimer, WorkTime, 1000 ;the amount of time before the timer "rings"

WorkTime:
SetTimer, BreakTimeUpdate, 1000 ;update the break timer every second
BreakTime := 20 ;begin the break timer at X seconds


BreakTimeUpdate: ;when the update time expires, reduce the amount of seconds on the break timer by 1
  BreakTime -= 1
		Gui, Add, Text,, Break! %BreakTime%
		Gui, Show, W: 1000, H: 500, Center
		Gui, Font, s100, Verdana
		Gui, Color, 000080
			if BreakTime < 1 ;restart once break timer expires
				{
				SetTimer, BreakTimeUpdate, Off
				Gui, Destroy
				Reload
				}
			else
				Return



;hotkeys
z::
	{
	Gui, Destroy
	ListLines
	Pause
	}
	
x::
	{
	Gui, Destroy
	ListVars
	Pause
	}

shift:: ;manual kill switch — ADD listlines LOGGING
	{
	Gui, Destroy
	ExitApp
	}



