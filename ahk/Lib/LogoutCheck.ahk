LogoutCheck() ;if client has been unexpectedly booted to main login screen, attempt to log back in
	{
	Global
	PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff, 0, Fast
		if ErrorLevel = 0 ;if client logged out, log back in and go back to starting position
			{ 
			Gui, Destroy
			Gui, Add, Text, ,Client logged out, attempting to log back in...
			Gui, Show, Y15, Msgbox
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
							Random, DoubleClickRoll, 1, 15 ;chance to double-click
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
						Send {Raw}username
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Tab}
							Random, wait1to3sec, 1000, 3000
							Sleep, wait1to3sec
						Send {Raw}password
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
										Random, DoubleClickRoll, 1, 35 ;chance to double-click on button
											if DoubleClickRoll = 5
												{
													Random, wait90to250milis, 90, 250
													Sleep, wait90to250milis
														Click, down
															Random, wait5to150milis, 5, 150
															Sleep, wait5to150milis
														Click, up
												}
							Gui, Destroy				
							Random, wait2to5sec, 2000, 5000
							Sleep, wait2to5sec+2000
								PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating login screen World selection
									if ErrorLevel ;if logged back in, re-orient client and begin macro
										{
										OrientClient()
										Return 1
										}
									else
										Goto, PostLogin ;if not logged back in, return to post-login section of function
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
		else ;if client has not been logged out, stop function
			Return
	}
