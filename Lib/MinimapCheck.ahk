MinimapCheck()
	{
	Global
	Gui, Destroy
	MiniMapCheck := 0
	Loop, 5000
	{
	PixelSearch, MiningSpot1X, MiningSpot1Y, ox+670, oy+132, ox+674, oy+136, 0x0000e4, 45, Fast ;check minimap to make sure character hasn't moved accidentally
		if ErrorLevel
			Sleep, 50
		else
			MiniMapCheck += 1	
	PixelSearch, MiningSpot2X, MiningSpot2Y, ox+638, oy+151, ox+642, oy+155, 0x0000e4, 45, Fast ;check minimap to make sure character hasn't moved accidentally
		if ErrorLevel
			Sleep, 50
		else
			{
			MiniMapCheck += 1
			Break
			}
		LogoutCheck() ;check if character has been logged out accidentally
		DisconnectCheck() ;check if client has been disconnected accidentally
	}
	if MiniMapCheck = 2
		Return
	else
		{
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because character not at mining spot / %InvDeposited% Invs deposited (~%OreDeposited% Ore)
		Gui, Show, Y15, Msgbox
			Random, wait800to1200milis, 800, 1200
			Sleep, wait800to1200milis
				AbortLogout()
		}
	}