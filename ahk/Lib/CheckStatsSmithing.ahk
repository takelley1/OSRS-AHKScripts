CheckStatsSmithing()
	{
	Global
	CheckStats: ;check skill level
		Gui, Destroy
		Gui, Add, Text, ,CheckStats called ...
			Gui, Show, Y15, Msgbox
			Random, wait800to1200milis, 800, 1200
			Sleep, wait800to1200milis
				Random, varyby13, -13, 13
				Random, varyby14, -14, 14
				MouseMove, ox+varyby13+576, oy+varyby14+185, 0 ;stats icon
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis+300
					LogOutCheck()
					DisconnectCheck()
						Click, down
							Random, wait5to100milis, 5, 100
							Sleep, wait5to100milis
						Click, up
			Random, wait800to1200milis, 800, 1200
			Random, wait200to500milis, 200, 500
			Sleep, wait800to1200milis+wait200to500milis
				Random, varyby22, -22, 22
				Random, varyby11, -11, 11
				MouseMove, ox+varyby22+705, oy+varyby11+254, 0 ;smelting stat box
					Random, wait3to5sec, 3000, 5000
					Sleep, wait3to5sec+1500
						Random, varyby13, -13, 13
						Random, varyby14, -14, 14
						MouseMove, ox+varyby13+642, oy+varyby14+186, 0 ;inventory bag icon
							Random, wait200to900milis, 200, 900
							Sleep, wait200to900milis+900
							LogOutCheck()
							DisconnectCheck()
								Click, down
									Random, wait5to100milis, 5, 100
									Sleep, wait5to100milis
								Click, up
							Random, wait200to900milis, 200, 900
							Sleep, wait200to900milis
			Random, varyby765, 0, 765
			Random, varyby503, 0, 503
			MouseMove, ox+varyby765, oy+varyby503, 0 ;move mouse to a random spot on the screen after checking stats
			Random, wait400to900milis, 200, 900
			Sleep, wait400to900milis
		Gui, Destroy
	Return
	}
