RandomSleep() 
	{
	Global
		Random, SleepDurationOne, 1000, 110000 
		SleepSeconds := 0
		 SleepSeconds := SleepDurationOne ;convert sleep duration value into seconds to be displayed on gui
			SleepSeconds /= 1000
				Gui, Destroy
				Gui, Add, Text, ,RandomSleep called for %SleepSeconds% seconds
				Gui, Show, Y15, Msgbox
		Sleep, SleepDurationOne
				Gui, Destroy
		
			LogoutCheck() ;check if client has been disconnected while sleeping
			DisconnectCheck()
					
	Gui, Destroy
	Return
	}