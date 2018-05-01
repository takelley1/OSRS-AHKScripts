RandomSleep() 
	{
	Global
		Random, SleepDurationOne, 5000, 200000 
		SleepDurationOne := SleepSeconds := 0 ;convert sleep duration value into seconds to be displayed on gui
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