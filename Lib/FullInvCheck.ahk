FullInvCheck()
	{
	Global
	PixelSearch, InvFullX, InvFullY, ox+705, oy+445, ox+705, oy+445, 0x3a424b, 5, Fast ;deposit inventory if an item is in the last inventory spot
		if ErrorLevel
			EmptyInv()
		else
			Return	
	}