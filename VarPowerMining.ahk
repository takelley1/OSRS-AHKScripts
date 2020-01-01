#NoEnv  ;Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv  ;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ;Enable warnings to assist with detecting common errors.
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.

;begin in mining guild in dwarven mine at iron patch closest to bank chest
;client must be oriented north (click compass) and camera must be tilted all the way upwards (hold "Up" arrow key)
;client must also be fully zoomed out and brightness set at default (second tick mark from the left)
;logot menu tab must be situated so "click here to logout" button is visible, NOT the world-switcher list

;about 2 min to fill inventory
;right click menu options have a vertical height of 14 pixels

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent
InvDeposited := 0
OreDeposited := 0

Random, TimerVariationRoll, 10000, 20000
SetTimer, AbortLogout, 3600000
Mining()

Mining()
{
Global
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png ;orient client by searching whole screen for prayer hud icon
	if ErrorLevel = 0
		{
		MouseMove, OrientX, OrientY ;move mouse to top left pixel of prayer hud menu icon to create new origin point for coordinate system
		MouseMove, -696, -171, 0, R ;0, 0 ;coordinates from prayer icon to origin point
			MouseGetPos, ox, oy ;use current position of mouse as origin point for coordinate system
		}
	else
		{
		MsgBox, Can’t find client!
			ExitApp
		} 	
			
CheckFirstRock:
	FullInvCheck()
	MinimapCheck() ;check if character is in the correct position
	
	PixelSearch, FirstFullX, FirstFullY, ox+274, oy+153, ox+274, oy+153, 0x313137, 15, Fast ;check if First rock is "full" (contains mine-able ore) by looking for absence of the "depleted" color
		if ErrorLevel ;if rock is full, mine ore
			{
			Random, varyby6, -6, 6
			Random, varyby7, -7, 7
			MouseMove, ox+varyby6+257, oy+varyby7+146, 0 ;click on rock
				Random, wait150to350milis, 150, 350
				Sleep, wait150to350milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
						Random, DoubleClickRoll, 1, 50 ;small chance to double-click on rock
							if DoubleClickRoll = 1
								{
								Random, wait90to250milis, 90, 250
								Sleep, wait90to250milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								}
			ResumeMiningRoll := RandomSleep()
				if ResumeMiningRoll = 1
					Goto, CheckFirstRock
				if ResumeMiningRoll = 2
					Goto, CheckSecondRock
			Gui, Destroy
				Loop, 150 ;wait until rock has been mined (either by you or someone else)
					{
					PixelSearch, FirstEmptyX, FirstEmptyY, ox+274, oy+153, ox+274, oy+153, 0x313137, 15, Fast
						if ErrorLevel = 0 ;if rock has been mined, check if inv is full
							{
							Gui, Destroy
							FullInvCheck()
							Goto, CheckSecondRock ;if inv is not full, check the other rock for ore
							}
						else ;if rock has not been mined, wait and check again
							{
							Sleep, 5
								LogoutCheck()
								DisconnectCheck()
									Gui, Add, Text, ,Waiting until First Rock is depleted / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
									Gui, Show, Y15, Msgbox
							}
					}
					Gui, Destroy
					Goto, CheckSecondRock ;if waiting for rock to be mined times out, check other rock
			}
		else ;if rock is not full, check other rock
			Goto, CheckSecondRock
		
CheckSecondRock:
	FullInvCheck()
	MinimapCheck()
	
	PixelSearch, SecondFullX, SecondFullY, ox+290, oy+170, ox+294, oy+174, 0x3b3b40, 15, Fast ;check if Second rock is full
		if ErrorLevel ;if rock is full, mine ore
			{
			Random, varyby6, -6, 6
			Random, varyby7, -7, 7
			MouseMove, ox+varyby6+282, oy+varyby7+171, 0
				Random, wait150to350milis, 150, 350
				Sleep, wait150to350milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
						Random, DoubleClickRoll, 1, 50 ;small chance to double-click on rock
							if DoubleClickRoll = 1
								{
								Random, wait90to250milis, 90, 250
								Sleep, wait90to250milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								}
			ResumeMiningRoll := RandomSleep()
				if ResumeMiningRoll = 1
					Goto, CheckFirstRock
				if ResumeMiningRoll = 2
					Goto, CheckSecondRock
			Gui, Destroy
				Loop, 150 ;wait until rock has been mined or is empty
					{
					PixelSearch, SecondEmptyX, SecondEmptyY, ox+290, oy+170, ox+294, oy+174, 0x3b3b40, 15, Fast
						if ErrorLevel = 0 ;if rock has been mined, check if inv is full
							{
							FullInvCheck()
							Goto, CheckFirstRock
							}
						else ;if rock has not been mined, wait and check again
							{
							Sleep, 5
								LogoutCheck()
								DisconnectCheck()
									Gui, Add, Text, ,Waiting until Second Rock is depleted / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
									Gui, Show, Y15, Msgbox
							}
					}
					Gui, Destroy
					Goto, CheckFirstRock
			}
		else ;if Second rock is empty, wait, then check First rock again
			{
			Random, wait200to500milis, 200, 500
			Sleep, wait200to500milis
				Goto, CheckFirstRock
			}   
	Goto, CheckFirstRock
}
	
^q::ExitApp
^p::Pause
