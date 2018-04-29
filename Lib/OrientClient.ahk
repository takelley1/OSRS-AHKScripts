OrientClient()
	{
	Global
	
	CoordMode, Pixel, Screen
	CoordMode, Mouse, Screen
	
	ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png ;orient client by searching whole screen for prayer hud icon
	
		if ErrorLevel = 0
			{
			MouseMove, OrientX, OrientY ;move mouse to top left pixel of prayer hud menu icon to create new origin point for coordinate system
			MouseMove, -696, -171, 0, R ; zero-X zero-Y (coordinates from prayer icon to origin point in top right corner)
				MouseGetPos, ox, oy ;use current position of mouse as origin point for coordinate system
			}
			
		else
			{
			MsgBox, Can’t find client!
				ExitApp
			} 
			
	Return		
	}