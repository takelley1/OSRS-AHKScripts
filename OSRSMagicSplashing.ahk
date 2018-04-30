#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#Persistent

OrientClient()

Loop
	{
		Runes := 0
		PixelSearch, MindRuneX, MindRuneY, ox+628, oy+235, ox+628, oy+235, 0x127bd8, 5, Fast ;make sure character still has mind runes in inventory (2nd spot)
			if ErrorLevel = 0
				Runes ++ ;increase variable by 1
			else
				{
				Random, wait1to20sec, 1000, 20000
				Sleep, wait1to20sec
					AbortLogout()
						MsgBox, Out of Mind Runes!
						ExitApp
				}
		PixelSearch, AirRuneX, AirRuneY, ox+585, oy+233, ox+585, oy+233, 0xdcdce0, 5, Fast ;make sure character still has air runes in inventory (1st spot)
			if ErrorLevel = 0
				Runes ++
			else
				{
				Random, wait1to20sec, 1000, 20000
				Sleep, wait1to20sec
					AbortLogout()
						MsgBox, Out of Air Runes!
						ExitApp
				}

		if Runes = 2 ;if both runes are present, continue macro
			{
			;PixelSearch, GuardX, GuardY, ox+255, oy+192, ox+265, oy+210, 0x213b42, 2, Fast
				;if ErrorLevel = 0 ;if guard has been found, continue macro
					;{
					Gui, Destroy
					Gui, Add, Text, ,Found guard
					Gui, Show, Y15, Msgbox
					Random, varyby100, -100, 100
					Random, varyby80, -80, 80
					MouseMove, ox+varyby100+645, oy+varyby80+378, 0 ;click mouse anywhere in inventory to maintain client activity
						Random, wait300to8000milis, 300, 8000
						Sleep, wait300to8000milis
						Click, down
							Random, wait80to400milis, 80, 400
							Sleep, wait80to400milis
						Click, up
							Random, loopcount, 30000, 210000 ;wait a random amount of time before clicking again (30s-4min10s)
							loopinseconds := 0
							loopcount /= 500 ;total wait time is divided by 500 since loop has a 500 milisecond sleep every iteration
							loopinseconds := loopcount ;convert random loop count into number of seconds macro will wait before performing another action, this is only used for display purposes
							loopinseconds *= 500 ;revert loopcount division
							loopinseconds /= 1000 ;convert miliseconds into seconds
							Gui, Destroy
							Gui, Add, Text, ,Found guard, waiting %loopinseconds% seconds
							Gui, Show, Y15, Msgbox

								Loop, %loopcount% ;loop a random number of times equivalent to 1-4min
									{
									PixelSearch, LevelUpX, LevelUpY, ox+452, oy+387, ox+452, oy+387, 0x800000, 2, Fast ;look for magic level up screen in chat menu and dismiss with spacebar
										if ErrorLevel = 0 ;if level up message has been found, confirm it to close
											{
											;Gui, Destroy
											;Gui, Add, Text, ,Confirming levelup message ...
										;	Gui, Show, Y15, Msgbox
										;	Random, wait800to5000milis, 800, 5000
										;	Sleep, wait800to5000milis
										;	Send {Space down}
										;		Random, wait80to400milis, 80, 400
										;		Sleep, wait80to400milis
										;	Send {Space up}
										;	Random, wait800to3000milis, 1000, 3000
										;	Sleep, wait800to3000milis
										;	Send {Space down} ;hit space twice since two messages may have to be confirmed before player will resume actions
										;		Random, wait80to400milis, 80, 400
										;		Sleep, wait80to400milis
										;	Send {Space up}
											Gui, Destroy
											LogoutCheck()
											}
										else ;if level up message has not been found, wait half a second before checking again
											Sleep, 500
											LogoutCheck()
									}
					;}
				;else ;if guard has not been found, logout
					;{
					;AbortLogout()
					;MsgBox, Cant find Guard!
					;ExitApp
					;}
			}
		else ;if both runes are not present, logout
			{
			Random, wait1to10sec, 1000, 10000
			Sleep, wait1to10sec
				AbortLogout()
					MsgBox, Out of Runes - Error!
					ExitApp
			}
	}

^q::
{
Gui, Destroy
ExitApp
}
^p::
{
Gui, Destroy
ListVars
ListLines
KeyHistory
Pause
}
