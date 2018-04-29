RandomSleep() 
	{
	Global
	
	Gui, Destroy
	Random, RandomSleepRoll, 1, 20 ;chance to "sleep" temporarily to throw off predictability
		if RandomSleepRoll != 1
			Return
			
			Random, SleepDurationOne, 5000, 120000
			SleepDurationOne := SleepSeconds := 0 ;convert sleep duration value into seconds to be displayed on gui
				SleepSeconds /= 1000
					Gui, Add, Text, ,RandomSleep called for %SleepSeconds% seconds
					Gui, Show, Y15, Msgbox
			Sleep, SleepDurationOne
					Gui, Destroy
			
				LogoutCheck() ;check if client has been disconnected while sleeping
				DisconnectCheck()
					
	Gui, Destroy
	Return
	}