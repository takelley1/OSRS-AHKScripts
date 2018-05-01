AbortLogout()
	{
	Global
	Loop, 4 ;re-check to see if logout tab is now available on hud, do this 4 times
		{
		PixelSearch, LogOutButtonX, LogOutButtonY, ox+640, oy+473, ox+644, oy+473, 0x53af52, 10 ;check if logout button is available on hud to be clicked (player is not banking)
			if ErrorLevel = 0 ;if logout button is available, click it and logout
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
							Return
							
				}
			else ;if logout button is not present on hud, check to see if player is currently banking
				PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 3, Fast
					if ErrorLevel = 0 ;if player is currently banking, close bank window
						{
						Random, wait300to1500milis, 300, 1500
						Sleep, wait300to1500milis
							Random, varyby9, -9, 9
							Random, varyby8, -8, 8
							MouseMove, varyby9+486, varyby8+23, 0 ;X in top right corner of bank window
							Random, wait300to1500milis, 300, 1500
							Sleep, wait300to1500milis
									Click, down
										Random, wait5to100milis, 5, 100
										Sleep, wait5to100milis
									Click, up
						}
					else ;if player is not currently banking, quit function
						{
						MsgBox, Cant find logout tab!
						ExitApp
						}
		} 
	}