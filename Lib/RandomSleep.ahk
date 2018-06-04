RandomSleep()
{
Global
	Random, RandomSleepRoll, 1, 3
		if RandomSleepRoll = 1
			{
			Random, RandomSleepOne, 3000, 30000
				SleepSeconds := 0
				SleepSeconds := RandomSleepOne ;convert sleep duration value into seconds to be displayed on gui
				SleepSeconds /= 1000
					Gui, Destroy
					Gui, Add, Text, ,RandomSleep called for %SleepSeconds% seconds
					Gui, Show, Y15, Msgbox
			Sleep, RandomSleepOne
				Gui, Destroy
			LogoutCheck()
			DisconnectCheck()
			}
		if RandomSleepRoll = 2
			{
			Random, RandomSleepTwo, 3000, 30000
				SleepSeconds := 0
				SleepSeconds := RandomSleepTwo ;convert sleep duration value into seconds to be displayed on gui
				SleepSeconds /= 1000
					Gui, Destroy
					Gui, Add, Text, ,RandomSleep called for %SleepSeconds% seconds
					Gui, Show, Y15, Msgbox
			Sleep, RandomSleepTwo
				Gui, Destroy
			LogoutCheck()
			DisconnectCheck()
			}
		if RandomSleepRoll = 3
			{
			Random, RandomSleepThree, 3000, 30000
				SleepSeconds := 0
				SleepSeconds := RandomSleepThree ;convert sleep duration value into seconds to be displayed on gui
				SleepSeconds /= 1000
					Gui, Destroy
					Gui, Add, Text, ,RandomSleep called for %SleepSeconds% seconds
					Gui, Show, Y15, Msgbox
			Sleep, RandomSleepThree
				Gui, Destroy
			LogoutCheck()
			DisconnectCheck()
			}
		else
			Return
	Random, RandomSleepRollExtra, 1, 10
		if RandomSleepRollExtra = 1
			{
			Random, RandomSleepOneExtra, 5000, 10000
				SleepSeconds := 0
				SleepSeconds := RandomSleepOneExtra ;convert sleep duration value into seconds to be displayed on gui
				SleepSeconds /= 1000
					Gui, Destroy
					Gui, Add, Text, ,RandomSleep Extra called for %SleepSeconds% seconds
					Gui, Show, Y15, Msgbox
			Sleep, RandomSleepOneExtra
				Gui, Destroy
			LogoutCheck()
			DisconnectCheck()
			Return
			}
		else
			Return
}
