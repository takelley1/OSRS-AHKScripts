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

OrientClient() ;orient to client coordinates
Spellbook()

Spellbook() ;look for spellbook, then click on hi alch icon in spellbook
	{
	Global
	Loop, 150 ;look for spellbook
		{
		PixelSearch, InvX, InvY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 1, Fast
			if ErrorLevel = 0
				Goto, ContinueSpell
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis ;wait 5-10sec in total for inventory to appear
				}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant find spellbook
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Sleep, 5000
			AbortLogout()
			ExitApp
		
	ContinueSpell:
	Random, varyby4, -4, 4
	Random, varyby5, -5, 5
	MouseMove, ox+varyby4+260, oy+varyby5+188, 0 ;click on hi alch spell icon
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
	Inventory()
	}

Inventory() ;wait for inventory to appear, then click on item to be alched
	{
	Global
	Loop, 150 ;wait for inventory to appear after clicking spell icon
		{
		PixelSearch, InvX, InvY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 1, Fast
			if ErrorLevel = 0
				Goto, ContinueInv
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis ;wait 5-10sec in total for inventory to appear
				}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant find inventory
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Sleep, 5000
			AbortLogout()
			ExitApp
			
	ContinueInv:
	Random, varyby4, -4, 4
	Random, varyby5, -5, 5
	MouseMove, ox+varyby4+260, oy+varyby5+188, 0 ;click on item
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
	Random, wait2p5to5sec, 2500, 5000 ;wait for alching to complete before checking for spellbook again
	Sleep, wait2p5to5sec
	Spellbook()
	}
