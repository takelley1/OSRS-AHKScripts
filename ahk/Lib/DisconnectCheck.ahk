DisconnectCheck() ;check if client has been unexpectedly disconnected and booted to post-login screen, if so, attempt to log back in
	{
	Global
	PixelSearch, PostLoginButtonX, PostLoginButtonY, ox+763, oy+500, ox+763, oy+500, 0x000000, 2, Fast ;look for post-login screen
		if ErrorLevel = 0 ;if found, click on big red button
			{
			Gui, Destroy
			Gui, Add, Text, ,Client disconnected, attempting to log back in...
			Gui, Show, Y15, Msgbox
			Random, wait2to5sec, 2000, 5000
			Sleep, wait2to5sec
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
				;PixelSearch, LogoutX, LogoutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating World selection
			}
			else ;if not found, abort subroutine and return to location it was called from
	Return 
	}
      
