#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;ControlFocus , , VirtualBox.exe

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

SetTimer, LogoutDisconnectCheck, 5000 ;check if client has been logged out or disconnected once every 5 seconds

;ControlFocus , , VirtualBox.exe

OrientClient() ;orient to client coordinates
Start()

Start() ;click on spellbook icon
	{
	Global
	Random, varyby14, -14, 14
	Random, varyby12, -12, 12
	MouseMove, ox+varyby14+742, oy+varyby12+187, 0 ;click on spellbook icon
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
	Random, wait200to800milis, 200, 800
	Sleep, wait200to800milis
	Spellbook()
	}
	
Spellbook() ;look for spellbook, then click on hi alch icon in spellbook
	{
	Global

	Loop, 100 ;look for spellbook
		{
		PixelSearch, SpellX, SpellY, ox+719, oy+330, ox+723, oy+334, 0x0cf6fa, 20, Fast
			if ErrorLevel = 0
				Goto, ContinueSpell
			else
				{
				Random, wait50to100milis, 50, 100
				Sleep, wait50to100milis ;wait 5-10sec in total for inventory to appear
				}
		}
		Gui, Destroy
		;SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant find spellbook or out of runes
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Sleep, 5000
			AbortLogout()
			ExitApp
		
	ContinueSpell:
	Random, varyby10, -10, 10
	Random, varyby11, -11, 11
	MouseMove, ox+varyby10+716, oy+varyby11+328, 0 ;click on hi alch spell icon
		Random, wait200to2500milis, 200, 2500
		Sleep, wait200to2500milis
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
	Inventory()
	}

Inventory() ;wait for inventory to appear, then click on item to be alched
	{
	Global
	Loop, 100 ;wait for inventory to appear after clicking spell icon
		{
		PixelSearch, InvX, InvY, ox+718, oy+325, ox+718, oy+325, 0x729eae, 25, Fast
			if ErrorLevel = 0
				Goto, ContinueInv
			else
				{
				Random, wait50to100milis, 5, 10
				Sleep, wait50to100milis ;wait 5-10sec in total for inventory to appear
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
	Random, varyby14, -14, 14
	Random, varyby11, -11, 11
	MouseMove, ox+varyby14+705, oy+varyby11+337, 0 ;click on item
		Random, wait200to2500milis, 200, 2500
		Sleep, wait200to2500milis
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
	Random, wait2to4sec, 2000, 4000 ;wait for alching to complete before checking for spellbook again
	Sleep, wait2to4sec
	Spellbook()
	}
	
LogoutDisconnectCheck:
LogoutCheck()
		if LogoutCheck() = 1 ;if function returns positive, look for bank to restart macro
			Start()
DisconnectCheck()
		if DisconnectCheck() = 1
			Start()
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
