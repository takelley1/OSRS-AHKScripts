#NoEnv  ;Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv  ;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ;Enable warnings to assist with detecting common errors.
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, 7ms ;run slightly faster than default 

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

Start:

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

		/*

			PixelSearch, SX, SY, ox+292, oy+172, ox+292, oy+172, 0x3b3b40, 15, Fast ;check if First rock is "full" (contains mine-able ore) by looking for absence of the "depleted" color
		if ErrorLevel = 0
			{
			MsgBox, Found Ore!
			ExitApp ;if rock is full, mine ore
			}
		else
			{
			MsgBox, Can't Find Ore
			ExitApp
			}

		*/

CheckFirstRock:
	Gosub, FullInvCheck ;check if inventory is full
	Gosub, AtMiningSpotCheck ;check if character is in the correct position

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
			Gosub, RandomSleep
			Gui, Destroy
				Loop, 150 ;wait until rock has been mined (either by you or someone else)
					{
					PixelSearch, FirstEmptyX, FirstEmptyY, ox+274, oy+153, ox+274, oy+153, 0x313137, 15, Fast
						if ErrorLevel = 0 ;if rock has been mined, check if inv is full
							{
							Gui, Destroy
							Gosub, FullInvCheck
							Goto, CheckSecondRock ;if inv is not full, check the other rock for ore
							}
						else ;if rock has not been mined, wait and check again
							{
							Sleep, 5
								Gosub, LogoutCheck
								Gosub, DisconnectCheck
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
	Gosub, FullInvCheck
	Gosub, AtMiningSpotCheck

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
			Gosub, RandomSleep
			Gui, Destroy
				Loop, 150 ;wait until rock has been mined or is empty
					{
					PixelSearch, SecondEmptyX, SecondEmptyY, ox+290, oy+170, ox+294, oy+174, 0x3b3b40, 15, Fast
						if ErrorLevel = 0 ;if rock has been mined, check if inv is full
							{
							Gosub, FullInvCheck
							Goto, CheckFirstRock
							}
						else ;if rock has not been mined, wait and check again
							{
							Sleep, 5
								Gosub, LogoutCheck
								Gosub, DisconnectCheck
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




;beginning of subroutines
EmptyInv: ;deposit ore into bank
	Gui, Add, Text, ,EmptyInv called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, DepositBoxClickRoll, 1, 2 ;randomly click on deposit box within two specified random ranges due to its slanted shape
			if DepositBoxClickRoll = 1
				{
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				Random, wait150to500milis, 150, 500
				Sleep, wait150to500milis
				MouseMove, ox+varyby9+32, oy+varyby8+148, 0 ;deposit box location 1
				}
			else
				{
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				Random, wait150to500milis, 150, 500
				Sleep, wait150to500milis
				MouseMove, ox+varyby9+57, oy+varyby8+166, 0 ;deposit box location 2
				}
				Random, wait150to500milis, 150, 500
				Sleep, wait150to500milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
						Random, DoubleClickRoll, 1, 10 ;chance to double-click on deposit box
							if DoubleClickRoll = 1
								{
								Random, wait50to100milis, 50, 100
								Sleep, wait50to100milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								}
	Gui, Destroy
	Gui, Add, Text, ,Waiting to reach deposit box / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, wait1to3sec, 1000, 3000 ;wait for character to reach deposit box
		Sleep, wait1to3sec
		Gui, Destroy
		Gui, Add, Text, ,Looking for deposit box / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
			Loop, 100 ;wait for deposit box screen to appear
			{
			PixelSearch, BoxWindowX, BoxWindowY, ox+140, oy+50, ox+140, oy+50, 0x1f98ff, 3, Fast
				if ErrorLevel = 0
					{
					Gui, Destroy
					Gui, Add, Text, ,Found deposit box / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
					Gui, Show, Y15, Msgbox
						Goto, ContinueBoxWindow
					}
				else
					{
					Random wait100to200milis, 100, 200
					Sleep, wait100to200milis
					}
			}
			Gui, Destroy
			Gui, Add, Text, ,AbortLogout called because cant reach deposit box / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
			Gui, Show, Y15, Msgbox
				Goto, AbortLogout ;if cant reach deposit box, logout immediately
	ContinueBoxWindow: ;deposit inventory
		Gui, Destroy
		Gui, Add, Text, ,Depositing inventory / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
			Random, wait200to400milis, 200, 400
			Sleep, wait200to400milis
			PixelSearch, InvSlot2OreX, InvSlot2OreY, ox+173, oy+96, ox+173, oy+96, 0x010000, 5, Fast ;make sure ore is in inventory slot 2 before attempting to deposit it
				if ErrorLevel = 0
					{
					Random, varyby10, -10, 10
					Random, varyby9, -9, 9
					MouseMove, ox+varyby10+177, oy+varyby9+93, 0 ;second inventory spot
						Random, wait300to900milis, 200, 900
						Sleep, wait300to900milis
							Click, down, right
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up, right
					Random, wait300to900milis, 200, 900
					Sleep, wait300to900milis
						Random, varyby25, -25, 25
						Random, varyby5, -5, 5
						MouseMove, varyby25+0, varyby5+73, 0, R ;second inventory spot Deposit-All right-click option
							Random, wait300to900milis, 200, 900
							Sleep, wait300to900milis
								Click, down
									Random, wait5to150milis, 5, 150
									Sleep, wait5to150milis
								Click, up
					}
				else ;if inventory slot 2 is empty, search entire window for ore to deposit
					{
					PixelSearch, OreX, OreY, ox+121, oy+78, ox+395, oy+235, 0x172632, 3, Fast
						if ErrorLevel = 0
							Random, varyby5, -5, 5
							Random, varyby4, -4, 4
							MouseMove, OreX+varyby5+14, OreY+varyby4+4, 0 ;location of first iron ore
								Random, wait300to900milis, 200, 900
								Sleep, wait300to900milis
									Click, down, right
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up, right
							Random, wait300to900milis, 200, 900
							Sleep, wait300to900milis
								Random, varyby25, -25, 25
								Random, varyby5, -5, 5
								MouseMove, varyby25+0, varyby5+73, 0, R ;Deposit-All right-click option
									Random, wait300to900milis, 200, 900
									Sleep, wait300to900milis
										Click, down
											Random, wait5to150milis, 5, 150
											Sleep, wait5to150milis
										Click, up
											Random, wait500to900milis, 200, 900
											Sleep, wait500to900milis
										Goto, ContinueInvSlot2Empty
					}
		Loop, 10
			{
			Loop, 1000 ;check for empty inventory spot in deposit box
				{
				PixelSearch, InvSlot2EmptyX,InvSlot2EmptyY, ox+620, oy+220, ox+620, oy+230, 0x354049
					if ErrorLevel = 0
						{
						Gui, Destroy
						Gui, Add, Text, ,Inventory empty / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
						Gui, Show, Y15, Msgbox
							Goto, ContinueInvSlot2Empty
						}
					else
						{
						Random, wait7to10milis, 7, 10
						Sleep, wait7to10milis
						}
				}
				;if inventory hasnt been deposited after 7-10 seconds, try depositing again
				Random, wait200to900milis, 200, 900
				Sleep, wait200to900milis
					Random, varyby7, -7, 7
					Random, varyby6, -6, 6
					MouseMove, ox+varyby7+177, oy+varyby6+95, 0
						Click, down, right
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up, right
				Random, wait200to900milis, 200, 900
				Sleep, wait200to900milis
					Random, varyby5, -5, 5
					Random, varyby7, -7, 7
					MouseMove, varyby7+0, varyby5+40, 0, R
						Random, wait200to900milis, 200, 900
						Sleep, wait200to900milis
							Click, down
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up
			}
		ContinueInvSlot2Empty:
		CheckforGems:
		PixelSearch, SapphireX, SapphireY, ox+121, oy+78, ox+395, oy+235, 0x840a07, 3, Fast ;check for sapphires
			if ErrorLevel = 0
				{
				Random, wait200to900milis, 200, 900
				Sleep, wait200to900milis
					Random, varyby5, -5, 5
					Random, varyby7, -7, 7
					MouseMove, SapphireX+varyby7+7, SapphireY+varyby5+10, 0
						Random, wait200to900milis, 200, 900
						Sleep, wait200to900milis
							Click, down
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up
						Random, wait700to900milis, 700, 900
						Sleep, wait700to900milis
							Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
								if DoubleClickRoll = 1
									{
									Random, wait90to250milis, 90, 250
									Sleep, wait90to250milis
										Click, down
											Random, wait5to150milis, 5, 150
											Sleep, wait5to150milis
										Click, up
									}
				Goto, CheckforGems
				}
			else
				{
				PixelSearch, EmeraldX,EmeraldY, ox+121, oy+78, ox+395, oy+235, 0x0a7b06, 3, Fast ;check for emeralds
					if ErrorLevel = 0
						{
						Random, wait200to900milis, 200, 900
						Sleep, wait200to900milis
							Random, varyby5, -5, 5
							Random, varyby7, -7, 7
							MouseMove, EmeraldX+varyby7+7, EmeraldY+varyby5+10, 0
								Random, wait200to900milis, 200, 900
								Sleep, wait200to900milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								Random, wait700to900milis, 700, 900
								Sleep, wait700to900milis
									Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
										if DoubleClickRoll = 1
											{
											Random, wait90to250milis, 90, 250
											Sleep, wait90to250milis
												Click, down
													Random, wait5to150milis, 5, 150
													Sleep, wait5to150milis
												Click, up
											}
						Goto, CheckforGems
						}
					else
						{
						PixelSearch, RubyX,RubyY, ox+121, oy+78, ox+395, oy+235, 0x050c68, 3, Fast ;check for rubies
							if ErrorLevel = 0
								{
								Random, wait200to900milis, 200, 900
								Sleep, wait200to900milis
									Random, varyby5, -5, 5
									Random, varyby7, -7, 7
									MouseMove, RubyX+varyby7+7, RubyY+varyby5+10, 0
										Random, wait200to900milis, 200, 900
										Sleep, wait200to900milis
											Click, down
												Random, wait5to150milis, 5, 150
												Sleep, wait5to150milis
											Click, up
										Random, wait700to900milis, 700, 900
										Sleep, wait700to900milis
											Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
												if DoubleClickRoll = 1
													{
													Random, wait90to250milis, 90, 250
													Sleep, wait90to250milis
														Click, down
															Random, wait5to150milis, 5, 150
															Sleep, wait5to150milis
														Click, up
													}
								Goto, CheckforGems
								}
							else
								{
								PixelSearch, DiamondX, DiamondY, ox+121, oy+78, ox+395, oy+235, 0xafafb1, 3, Fast ;check for diamonds
									if ErrorLevel = 0
										{
										Random, wait200to900milis, 200, 900
										Sleep, wait200to900milis
											Random, varyby5, -5, 5
											Random, varyby7, -7, 7
											MouseMove, DiamondX+varyby7+7, DiamondY+varyby5+10, 0
												Random, wait200to900milis, 200, 900
												Sleep, wait200to900milis
													Click, down
														Random, wait5to150milis, 5, 150
														Sleep, wait5to150milis
													Click, up
												Random, wait700to900milis, 700, 900
												Sleep, wait700to900milis
													Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
														if DoubleClickRoll = 1
															{
															Random, wait90to250milis, 90, 250
															Sleep, wait90to250milis
																Click, down
																	Random, wait5to150milis, 5, 150
																	Sleep, wait5to150milis
																Click, up
															}
										Goto, CheckforGems
										}
								}

						}
				}
		InvDeposited += 1
		OreDeposited += 26.99
		Gui, Destroy ;return to mining spot
		Gui, Add, Text, ,Closing window / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
			Random, wait200to900milis, 200, 900
			Sleep, wait200to900milis
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				MouseMove, ox+varyby9+418, oy+varyby8+25, 0 ;close button of deposit box window
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						Click, down
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
		Gui, Destroy
		Gui, Add, Text, ,Returning to mining spot / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
				Random, varyby12, -12, 12
				Random, varyby11, -11, 11
				MouseMove, ox+varyby12+451, oy+varyby11+175, 0 ;mining spot from deposit box
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						PixelSearch, InvFullX, InvFullY, ox+705, oy+445, ox+705, oy+445, 0x3a424b, 2, Fast ;make sure inventory has been completely emptied before returning to mining spot
						if ErrorLevel
							{
							Gui, Destroy
							Gui, Add, Text, ,AbortLogout called because inventory not empty or gem in 2nd inventory spot / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
							Gui, Show, Y15, Msgbox
								Goto, AbortLogout
							}
						Click, down
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up
							Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
								if DoubleClickRoll = 1
									{
										Random, wait90to250milis, 90, 250
										Sleep, wait90to250milis
											Click, down
												Random, wait5to150milis, 5, 150
												Sleep, wait5to150milis
											Click, up
									}
				Random, wait3to4sec, 3500, 4000 ;wait before checking if character has returned to mining spot
				Sleep, wait3to4sec
				Gosub, AtMiningSpotCheck
		ReturnedtoMiningSpot:
			Gui, Destroy
				Loop, 100 ;wait until rock has been mined or is empty
					{
					PixelSearch, SecondEmptyX, SecondEmptyY, ox+290, oy+170, ox+294, oy+174, 0x3b3b40, 15, Fast
						if ErrorLevel = 0 ;once rock has been mined, roll for behaviors
							{
								Gui, Destroy
								Random, wait50to150milis, 50, 150
								Sleep, wait50to150milis

								Random, SelectChatRoll, 1, 60
									if SelectChatRoll = 1 ;chance per inventory to enter predetermined text into chat (chance should be lower than BriefLogout chances to prevent duplicate messages appearing to the same people)
										Gosub, SelectChat

								Random, CheckStatsRoll, 1, 15
									if CheckStatsRoll = 1 ;chance per inventory to check skill xp
										Gosub, CheckStats

								Random, BriefLogoutRoll, 1, 65
									if BriefLogoutRoll = 1 ;chance per inventory to logout briefly to simulate a quick break
										Goto, BriefLogout

								;Random, AbortLogoutRoll, 1, 70
									;if AbortLogoutRoll = 1 ;chance per inventory to logout and stop macro completely
										;{
										;Gui, Destroy
										;Gui, Add, Text, ,AbortLogout randomly called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
										;Gui, Show, Y15, Msgbox
										;	Goto, AbortLogout
										;}
							Gosub, FullInvCheck
							Goto, CheckFirstRock
							}
						else ;if rock has not been mined, wait and check again
							{
							Sleep, 5
								Gosub, LogoutCheck
								Gosub, DisconnectCheck
									Gui, Add, Text, ,Waiting until Second Rock is depleted / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
									Gui, Show, Y15, Msgbox
							}
					}
					Gui, Destroy
					Goto, CheckFirstRock


LogoutCheck: ;if client has been unexpectedly booted to main login screen, attempt to log back in
	PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff, 0, Fast
		if ErrorLevel = 0 ;if client logged out, log back in and go back to starting position
		{
			Random, wait5to10sec, 5000, 10000
			Sleep, wait5to10sec
				Random, varyby15, -15, 15
				Random, varyby14, -14, 14
				MouseMove, ox+varyby15+30, oy+varyby14+30 ;click on window to make sure it is in focus before attempting to login
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						Click, down
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up
							Random, DoubleClickRoll, 1, 5 ;chance to double-click
								if DoubleClickRoll = 1
									{
										Random, wait90to250milis, 90, 250
										Sleep, wait90to250milis
											Click, down
												Random, wait5to150milis, 5, 150
												Sleep, wait5to150milis
											Click, up
									}
						Send {Enter} ;same as clicking "existing user" button
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Raw}takelley1+1@yahoo.com
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Tab}
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Raw}vH73767yN2PU64TL
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Enter}
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
	PostLogin:
		Loop, 5
			{
			PixelSearch, PostLoginButtonX, PostLoginButtonY, ox+763, oy+500, ox+763, oy+500, 0x000000, 3 ;check if post-login screen has been reached, if not, try hitting login button again
				if ErrorLevel = 0 ;if post-login screen reached, click on big red button
					{
					Random, varyby15, -15, 15
					Random, varyby14, -14, 14
					MouseMove, ox+varyby15+400, oy+varyby14+337, 0
						Random, wait1to3sec, 1000, 3000
						Sleep, wait1to3sec
							Click, down
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up
								Random, DoubleClickRoll, 1, 5 ;chance to double-click on button
									if DoubleClickRoll = 5
										{
											Random, wait90to250milis, 90, 250
											Sleep, wait90to250milis
												Click, down
													Random, wait5to150milis, 5, 150
													Sleep, wait5to150milis
												Click, up
										}
					Random, wait2to5sec, 2000, 5000
					Sleep, wait2to5sec+2000
						PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating World selection
							if ErrorLevel ;if so, re-orient client and begin macro
								Goto, Start
							else
								Goto, PostLogin ;if not, return to post-login section of subroutine
					}
				else ;if post-login screen not reached, try logging in again since login may have timed out due to poor network connectivity
					{
					Random, wait2to5sec, 2000, 5000
					Sleep, wait2to5sec
						Send {Enter} ;try hitting login button again if can't connect to server yet
					Random, wait2to5sec, 2000, 5000
					Sleep, wait2to5sec+5000
					}
			} ;if login loop fails repeatedly, stop macro
			MsgBox, Can't get past post-login, or error with LogoutCheck loop!
				ExitApp
		}
		else ;if client has not been logged out, abort subroutine and return to location it was called from
Return

DisconnectCheck: ;check if client has been unexpectedly disconnected and booted to post-login screen, if so, attempt to log back in
	PixelSearch, PostLoginButtonX, PostLoginButtonY, ox+763, oy+500, ox+763, oy+500, 0x000000, 2, Fast ;look for post-login screen
		if ErrorLevel = 0 ;if found, click on big red button
			{
			Random, varyby15, -15, 15
			Random, varyby14, -14, 14
			MouseMove, ox+varyby15+400, oy+varyby14+337, 0
				Random, wait1to3sec, 1000, 3000
				Sleep, wait1to3sec
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
						Random, DoubleClickRoll, 1, 10 ;chance to double-click on button
							if DoubleClickRoll = 10
								{
								Random, wait150to350milis, 150, 350
								Sleep, wait150to350milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								}
			Random, wait2to5sec, 2000, 5000
			Sleep, wait2to5sec
				PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating World selection
					if ErrorLevel
						Goto, Start ;if so, re-orient client and begin macro
					else
						Goto, DisconnectCheck ;if not, restart subroutine
			}
			else ;if not found, abort subroutine and return to location it was called from
Return

BriefLogout: ;logout for a short period of time
	Gui, Destroy
	Gui, Add, Text, ,BriefLogout called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, varyby11, -11, 11
		Random, varyby12, -12, 12
		MouseMove, ox+varyby11+644, oy+varyby12+484, 0 ;logout tab on hud
			Random, wait400to1200milis, 400, 1200
			Sleep, wait400to1200milis
				Click, down
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up
			Random, wait800to1200milis, 800, 1200
			Sleep, wait800to1200milis+500
				Random, varyby60, -60, 60
				Random, varyby9, -9, 9
				MouseMove, ox+varyby60+642, oy+varyby9+433, 0 ;"click here to logout" button within logout tab
					Random, wait400to1200milis, 400, 1200
					Sleep, wait400to1200milis
						Click, down
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up
	Random, BriefLogoutDuration, 300000, 1200000 ;logout for 5-20min
		Gui, Destroy
	BriefLogoutDuration /= 60000
		Gui, Add, Text, ,BriefLogout called for %BriefLogoutDuration% minutes / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	BriefLogoutDuration *= 60000
		Gui, Show, Y15, Msgbox
			Sleep, BriefLogoutDuration
Goto, LogoutCheck ;use LogoutCheck subroutine to log back in

AbortLogout:
Loop, 3
	{
	PixelSearch, LogOutButtonX, LogOutButtonY, ox+640, oy+473, ox+644, oy+473, 0x53af52, 5 ;check if logout button is available on hud to be clicked (player is not banking)
		if ErrorLevel = 0
			{
			Random, varyby11, -11, 11
			Random, varyby12, -12, 12
			MouseMove, ox+varyby11+644, oy+varyby12+484, 0 ;logout tab on hud
				Random, wait400to1200milis, 400, 1200
				Sleep, wait400to1200milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
				Random, wait800to1200milis, 800, 1200
				Sleep, wait800to1200milis+500
					Random, varyby60, -60, 60
					Random, varyby9, -9, 9
					MouseMove, ox+varyby60+642, oy+varyby9+433, 0 ;"click here to logout" button within logout tab
						Random, wait400to1200milis, 400, 1200
						Sleep, wait400to1200milis
							Click, down
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up
						Pause
			}
		else ;if logout button is not present on hud, check to see if player is currently banking, and close the window if so
			PixelSearch, BoxWindowX, BoxWindowY, ox+140, oy+50, ox+140, oy+50, 0x1f98ff, 3, Fast
				if ErrorLevel = 0
					{
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						Random, varyby9, -9, 9
						Random, varyby8, -8, 8
						MouseMove, ox+varyby9+418, oy+varyby8+55, 0 ;close button of deposit box window
							Random, wait200to900milis, 200, 900
							Sleep, wait200to900milis
								Click, down
									Random, wait5to150milis, 5, 150
									Sleep, wait5to150milis
								Click, up
							Random, wait500to900milis, 500, 900
							Sleep, wait500to900milis
					}
				else
					{
					MsgBox, Cant find logout tab!
					ExitApp
					}
	} ;re-check to see if logout tab is now available on hud, do this 3 times

RandomSleep: ;small chance after mining each rock to "sleep" temporarily to throw off predictability
	Gui, Destroy
	Random, RandomSleepRoll, 1, 90
		if RandomSleepRoll = 1
			{
			Random, SleepDurationOne, 5000, 120000
				SleepDurationOne /= 1000 ;divide by 1000 to convert sleep duration value into seconds to be displayed on gui
			Gui, Add, Text, ,RandomSleep called for %SleepDurationOne% seconds / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
				SleepDurationOne *= 1000 ;convert sleep duration value back into miliseconds
			Gui, Show, Y15, Msgbox
				Sleep, SleepDurationOne
			Gui, Destroy
				Gosub, LogoutCheck
				Gosub, DisconnectCheck
				Random, CheckRockRoll, 1, 2 ;randomly determine which rock character will begin mining first after RandomSleep
					if CheckRockRoll = 1
						Goto, CheckFirstRock
					else
						Goto, CheckSecondRock
			}
		else
			{
			Gui, Destroy
			Return
			}
	Gui, Destroy
Return

CheckStats: ;check skill level
	Gui, Destroy
	Gui, Add, Text, ,CheckStats called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, wait800to1200milis, 800, 1200
		Sleep, wait800to1200milis
			Random, varyby13, -13, 13
			Random, varyby14, -14, 14
			MouseMove, ox+varyby13+576, oy+varyby8+185, 0 ;stats icon
				Random, wait200to900milis, 200, 900
				Sleep, wait200to900milis+300
				Gosub, LogoutCheck
				Gosub, DisconnectCheck
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
		Random, wait800to1200milis, 800, 1200
		Random, wait200to500milis, 200, 500
		Sleep, wait800to1200milis+wait200to500milis
			Random, varyby22, -22, 22
			Random, varyby11, -11, 11
			MouseMove, ox+varyby22+705, oy+varyby11+222, 0 ;mining stat box
				Random, wait3to5sec, 3000, 5000
				Sleep, wait3to5sec+1500
					Random, varyby13, -13, 13
					Random, varyby14, -14, 14
					MouseMove, ox+varyby13+642, oy+varyby14+186, 0 ;inventory bag icon
						Random, wait200to900milis, 200, 900
						Sleep, wait200to900milis+900
						Gosub, LogoutCheck
						Gosub, DisconnectCheck
							Click, down
								Random, wait5to150milis, 5, 150
								Sleep, wait5to150milis
							Click, up
								Random, wait500to900milis, 500, 900
								Sleep, wait500to900milis
	Gui, Destroy
Return

AtMiningSpotCheck:
	Gui, Destroy
	MiniMapCheck := 0
	Loop, 5000
	{
	PixelSearch, MiningSpot1X, MiningSpot1Y, ox+670, oy+132, ox+674, oy+136, 0x0000e4, 45, Fast ;check minimap to make sure character hasn't moved accidentally
		if ErrorLevel
			Sleep, 50
		else
			MiniMapCheck += 1
	PixelSearch, MiningSpot2X, MiningSpot2Y, ox+638, oy+151, ox+642, oy+155, 0x0000e4, 45, Fast ;check minimap to make sure character hasn't moved accidentally
		if ErrorLevel
			Sleep, 50
		else
			{
			MiniMapCheck += 1
			Break
			}
		Gosub, LogoutCheck ;check if character has been logged out accidentally
		Gosub, DisconnectCheck ;check if client has been disconnected accidentally
	}
	if MiniMapCheck = 2
		Return
	else
		{
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because character not at mining spot / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
			Random, wait800to1200milis, 800, 1200
			Sleep, wait800to1200milis
				Goto, AbortLogout
		}

FullInvCheck:
	PixelSearch, InvFullX, InvFullY, ox+705, oy+445, ox+705, oy+445, 0x3a424b, 5, Fast ;deposit inventory if an item is in the last inventory spot
		if ErrorLevel
			Goto, EmptyInv
		else
			Return

SelectChat:
	Random, wait500to900milis, 500, 900
	Sleep, wait500to900milis
		Random, varyby10, -10, 10
		Random, varyby9, -9, 9
		MouseMove, ox+varyby10+258, oy+varyby9+144, 0 ;click on rock
			Random, wait200to500milis, 200, 500
			Sleep, wait200to500milis
				Click, down
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up
					Random, DoubleClickRoll, 1, 32 ;small chance to double-click on rock
						if DoubleClickRoll = 1
							{
							Random, wait180to500milis, 180, 500
							Sleep, wait180to500milis
								Click, down
									Random, wait5to150milis, 5, 150
									Sleep, wait5to150milis
								Click, up
							Random, wait300to600milis, 300, 600
							Sleep, wait300to600milis
							Gui, Destroy
							}
	Random, SelectChat, 1, 15 ;if macro decides to chat, determine which message it will type, with equal chances for each message
		if SelectChat = 1
			{
			Send {Raw}wonder how many bots here
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			Return
			}
		if SelectChat = 2
			{
			Send {Raw}so board
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 3
			{
			Send {Raw}why is mining so slow to lvl
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 4
			{
			Send {Raw}12.99999m xp to 99!
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 5
			{
			Send {Raw}any other hoomanss?
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 6
			{
			Send {Raw}alguien habla espanol?
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 7
			{
			Send {Raw}meow!
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 8
			{
			Send {Raw}this place must be bot heaven
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 9
			{
			Send {Raw}botopolis
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 10
			{
			Send {Raw}mmmmmmeow
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 11
			{
			Send {Raw}mining is sooo fun
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 12
			{
			Send {Raw}mining = fun
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 13
			{
			Send {Raw}only 13m xp left till 99!
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 14
			{
			Send {Raw}diggy diggy hole
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 15
			{
			Send {Raw}oink
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		else
			Sleep, 1
	Gui, Destroy
	Gui, Add, Text, ,SelectChat (%SelectChat%) rolled / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, wait300to600milis, 300, 600
		Sleep, wait300to600milis
	Gui, Destroy
Return

/*
_EmptyInv: ;drop all held items
	Gosub, LogoutCheck
	Gosub, DisconnectCheck
		Gui, Destroy
		Gui, Add, Text, ,EmptyInv called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
			Gui, Show, Y15, Msgbox

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+619, oy+varyby6+232, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, varyby7+0, varyby5+40, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+655, oy+varyby6+228, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
		Random, varyby7, -7, 7
		Random, varyby6, -6, 6
			MouseMove, ox+varyby7+703, oy+varyby6+228, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+706, oy+varyby6+264, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+660, oy+varyby6+264, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+615, oy+varyby6+264, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+585, oy+varyby6+261, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+586, oy+varyby6+298, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+620, oy+varyby6+304, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+663, oy+varyby6+296, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+702, oy+varyby6+301, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+696, oy+varyby6+336, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+667, oy+varyby6+336, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+618, oy+varyby6+337, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+585, oy+varyby6+334, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+587, oy+varyby6+370, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+618, oy+varyby6+374, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+658, oy+varyby6+373, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+709, oy+varyby6+373, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+710, oy+varyby6+409, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+656, oy+varyby6+409, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+617, oy+varyby6+413, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby7, -7, 7
			Random, varyby6, -6, 6
			MouseMove, ox+varyby7+586, oy+varyby6+406, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby5, -5, 5
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 40+varyby5, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby4, -4, 4
			Random, varyby7, -7, 7
			MouseMove, ox+varyby7+581, oy+varyby4+445, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby2, -2, 2
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 16+varyby2, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby4, -4, 4
			Random, varyby7, -7, 7
			MouseMove, ox+varyby7+622, oy+varyby4+445, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby2, -2, 2
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 16+varyby2, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby4, -4, 4
			Random, varyby7, -7, 7
			MouseMove, ox+varyby7+669, oy+varyby4+445, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby2, -2, 2
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 16+varyby2, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

	Loop, 10
		{
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby4, -4, 4
			Random, varyby7, -7, 7
			MouseMove, ox+varyby7+700, oy+varyby4+445, 0
				Click, down, right
					Random, wait5to150milis, 5, 150
					Sleep, wait5to150milis
				Click, up, right
		Random, wait200to800milis, 200, 800
		Sleep, wait200to800milis
			Random, varyby2, -2, 2
			Random, varyby7, -7, 7
			MouseMove, 0+varyby7, 16+varyby2, 0, R
				Random, wait200to800milis, 200, 800
				Sleep, wait200to800milis
					Click, down
						Random, wait5to150milis, 5, 150
						Sleep, wait5to150milis
					Click, up
					Gosub, LogoutCheck

		Random, wait1000to1500milis, 1000, 1500
		Sleep, wait1000to1500milis

			PixelSearch, InvFullX, InvFullY, ox+705, oy+445, ox+705, oy+445, 0x3a424b, 3, Fast ;double-check that last inventory item has been dropped to prevent extraneous EmptyInv calls
			if ErrorLevel
				{
				Continue
				}
			else
				{
				Gosub, LogoutCheck
				Gosub, DisconnectCheck
				Break
				}
		}
		Gui, Destroy

		if ErrorLevel ;if not at mining spot, check if stuck at NW corner
									{
									PixelSearch, StuckNWX, StuckNWY, ox+640, oy+159, ox+640, oy+159, 0x0000ef, 15, Fast
										if ErrorLevel = 0
											{
											Random, varyby9, -9, 9
											Random, varyby9, -8, 8
											MouseMove, ox+varyby9+285, oy+varyby8+204, 0 ;mining spot from StuckNW position
												Random, wait200to900milis, 200, 900
												Sleep, wait200to900milis
													Click, down
														Random, wait5to150milis, 5, 150
														Sleep, wait5to150milis
													Click, up
														Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
															if DoubleClickRoll = 1
																{
																	Random, wait90to250milis, 90, 250
																	Sleep, wait90to250milis
																		Click, down
																			Random, wait5to150milis, 5, 150
																			Sleep, wait5to150milis
																		Click, up
																}
														Random, wait2to4sec, 2000, 4000
														Sleep, wait2to4sec
															Goto, GoingtoMiningSpot
											}
										else ;check if stuck at SW corner
											{
											PixelSearch, StuckSWX, StuckSWY, ox+635, oy+138, ox+635, oy+138, 0x0000f5, 15, Fast
												if ErrorLevel = 0
													{
													Random, varyby8, -8, 8
													Random, varyby7, -7, 7
													MouseMove, ox+varyby8+284, oy+varyby7+146, 0 ;mining spot from StuckSW position
														Random, wait200to900milis, 200, 900
														Sleep, wait200to900milis
															Click, down
																Random, wait5to150milis, 5, 150
																Sleep, wait5to150milis
															Click, up
																Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																	if DoubleClickRoll = 1
																		{
																			Random, wait90to250milis, 90, 250
																			Sleep, wait90to250milis
																				Click, down
																					Random, wait5to150milis, 5, 150
																					Sleep, wait5to150milis
																				Click, up
																		}
																Random, wait2to4sec, 2000, 4000
																Sleep, wait2to4sec
																	Goto, GoingtoMiningSpot
													}
												else ;check if stuck one tile E of mining spot
													{
													PixelSearch, StuckEX, StuckEY, ox+628, oy+38, ox+628, oy+38, 0x0000e9, 15, Fast
														if ErrorLevel = 0
															{
															Random, varyby9, -9, 9
															Random, varyby8, -8, 8
															MouseMove, ox+varyby9+208, oy+varyby8+171, 0 ;mining spot from StuckSW position
																Random, wait200to900milis, 200, 900
																Sleep, wait200to900milis
																	Click, down
																		Random, wait5to150milis, 5, 150
																		Sleep, wait5to150milis
																	Click, up
																		Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																			if DoubleClickRoll = 1
																				{
																					Random, wait90to250milis, 90, 250
																					Sleep, wait90to250milis
																						Click, down
																							Random, wait5to150milis, 5, 150
																							Sleep, wait5to150milis
																						Click, up
																				}
																		Random, wait2to4sec, 2000, 4000
																		Sleep, wait2to4sec
																			Goto, GoingtoMiningSpot
															}
														else ;check if stuck at NE corner
															{
															PixelSearch, StuckNEX, StuckNEY, ox+664, oy+142, ox+664, oy+142, 0x0000f2, 15, Fast
																if ErrorLevel = 0
																	{
																	Random, varyby12, -12, 12
																	Random, varyby11, -11, 11
																	MouseMove, ox+varyby12+203, oy+varyby11+201, 0 ;mining spot from StuckNE position
																		Random, wait200to900milis, 200, 900
																		Sleep, wait200to900milis
																			Click, down
																				Random, wait5to150milis, 5, 150
																				Sleep, wait5to150milis
																			Click, up
																				Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																					if DoubleClickRoll = 1
																						{
																							Random, wait90to250milis, 90, 250
																							Sleep, wait90to250milis
																								Click, down
																									Random, wait5to150milis, 5, 150
																									Sleep, wait5to150milis
																								Click, up
																						}
																				Random, wait2to4sec, 2000, 4000
																				Sleep, wait2to4sec
																					Goto, GoingtoMiningSpot
																	}
																else ;if not at mining spot yet, wait before checking spots again, wait 10-20sec in total before giving up
																	{
																	Random, wait100to200milis, 100, 200
																	Sleep, wait100to200milis
																	}

															}
													}
											}
									}
*/

^q::ExitApp
^p::Pause
