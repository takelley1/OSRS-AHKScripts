EmptyInv() ;deposit ore into bank
	{
	Global
	Gui, Add, Text, ,EmptyInv called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
	Gui, Show, Y15, Msgbox
		Random, DepositBoxClickRoll, 1, 2 ;randomly click on deposit box within two specified random ranges due to its slanted shape
			if DepositBoxClickRoll = 1
				{
				Random, varyby8, -8, 8
				Random, varyby7, -7, 7
				Random, wait150to500milis, 150, 500 
				Sleep, wait150to500milis
				MouseMove, ox+varyby8+32, oy+varyby7+148, 0 ;deposit box location 1
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
				AbortLogout() ;if cant reach deposit box, logout immediately
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
			CheckForGems()
		InvDeposited += 1
		OreDeposited += 26.988
		Round (OreDeposited, 3)
		Gui, Destroy ;return to mining spot
		Gui, Add, Text, ,Closing window / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
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
								AbortLogout()
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
				MinimapCheck()
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
									SelectChat()	
									CheckStats()
									BriefLogout()	
								Random, AbortLogoutRoll, 1, 70
									if AbortLogoutRoll = 1 ;chance per inventory to logout and stop macro completely
										{
										Gui, Destroy
										Gui, Add, Text, ,AbortLogout randomly called / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
										Gui, Show, Y15, Msgbox
											AbortLogout()
										}
							FullInvCheck()
							Mining()
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
					Mining()
	}





























	
	





/* ;USED FOR POWER MINING ONLY
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
*/