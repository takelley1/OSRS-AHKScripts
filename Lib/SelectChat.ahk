SelectChat()
	{
	Global
	Random, SelectChatRoll, 1, 60
		if SelectChatRoll != 1 ;chance per inventory to enter predetermined text into chat (chance should be lower than BriefLogout chances to prevent duplicate messages appearing to the same people)
			Return
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
	}