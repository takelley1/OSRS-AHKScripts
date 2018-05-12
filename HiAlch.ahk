#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ControlFocus , , VirtualBox.exe

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

SetTimer, LogoutDisconnectCheck, 5000 ;check if client has been logged out or disconnected once every 5 seconds

ControlFocus , , VirtualBox.exe

OrientClient() ;orient to client coordinates

OpenBank()
	{
	Global
	Random, varyby11, -11, 11
	Random, varyby5, -5, 5
	MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to100milis, 5, 100
				Sleep, wait5to100milis
			Click, up
				Random, DoubleClickRoll, 1, 20 ;chance to double-click
					if DoubleClickRoll = 1
						{
							Random, wait90to250milis, 90, 250
							Sleep, wait90to250milis
								Click, down
									Random, wait5to100milis, 5, 100
									Sleep, wait5to100milis
								Click, up
						}					
	Loop, 3
		{
		Loop, 150 ;wait for bank screen to appear
			{
			PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 1, Fast
				if ErrorLevel = 0
					Deposit()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec in total for bank screen to appear
					}
			} ;if loop fails, try clicking on bank again -- try 3 times before aborting macro
			Random, varyby11, -11, 11
			Random, varyby5, -5, 5
			MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position (again)
				Random, wait200to500milis, 200, 500
				Sleep, wait200to500milis+500
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
						Random, DoubleClickRoll, 1, 20 ;chance to double-click on bank
							if DoubleClickRoll = 1
								{
									Random, wait90to250milis, 90, 250
									Sleep, wait90to250milis
										Click, down
											Random, wait5to100milis, 5, 100
											Sleep, wait5to100milis
										Click, up
								}
		}
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because cant open bank
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Sleep, 5000
			AbortLogout()
			ExitApp
	}