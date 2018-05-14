#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir% 

ControlFocus , , VirtualBox.exe

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

SetTimer, LogoutDisconnectCheck, 5000 ;check if client has been logged out or disconnected once every 5 seconds

ControlFocus , , VirtualBox.exe

OrientClient() ;orient to client coordinate
Spell()

Spell() ;click on hi alch icon in spellbook
	{
	Global
	Random, varyby11, -11, 11
	Random, varyby5, -5, 5
	MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;click on hi alch spell icon
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to100milis, 5, 100
				Sleep, wait5to100milis
			Click, up
					
		Loop, 150 ;wait for inventory to appear after clicking spell icon
			{
			PixelSearch, InvX, InvY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 1, Fast
				if ErrorLevel = 0
					Alch()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec in total for inventory to appear
					}
		}
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because cant start alching
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Sleep, 5000
			AbortLogout()
			ExitApp
	}

Alch() ;click on item to be alched
{
;check to make sure item is still present
else ;if item not present, stop bot and optionally logout
