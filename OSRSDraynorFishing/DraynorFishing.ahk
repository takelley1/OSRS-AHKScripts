#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

Draynor Fishing Macro

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

Gosub, GetRandoms ;generate random numbers for input delays and mouse clicks to mimic human behavior

;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
	if ErrorLevel = 0
		{
			Sleep, wait1to15milis
		MouseMove, OrientX, OrientY ;move mouse to top left pixel of client to create new origin point for coordinate system
			Sleep, wait1to15milis
		MouseMove, -696, -171, 0, R ; 0, 0 ;coordinates from prayer icon to origin point
			Sleep, wait1to15milis
		MouseGetPos, ox, oy
		}
	else
		{
		MsgBox, cant locate client or error with Orient search
			ExitApp
		}
		
Start: ;begin main loop

Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

ContinueInvSlot2Empty:


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

;UPDATE THIS
Loop, 100 ;look for fishing spot on minimap
	{
	PixelSearch, FishGoX, FishGoY, ox+610, oy+134, ox+610, oy+134, 0xc85107
		if ErrorLevel = 0
			Goto, FishGo
		else
			Sleep, 1
	}
FurnaceGo:


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

MouseMove, FishGoX-1+varyby2, FishGoY-6+varyby2, 0 ;click on fishing spot on minimap
	Sleep, wait200to500milis
		Click
		Sleep, wait1to15milis+100
		Click
	Sleep, wait5to10sec
Loop, 100 ;wait until at fishing spot
	{
	PixelSearch, FishAtX, FishAtY, ox+627, oy+82, ox+627, oy+82, 0x010000
		if ErrorLevel = 0
			Goto, FurnaceAt
		else
			Sleep, wait100to500milis-50
	}

FishAt:

Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

;look for viable fishing spots by mousing over each possible spot until top left corner of screen indicates available fishing spot


Loop, 10 ;look at spot one
{
MouseMove, ox+233+varyby4, ox+181+varyby4, 0
	Sleep, wait800to1200milis
	PixelSearch, ViableX, ViableY, ox+80, oy+13, ox+80, oy+13, 0x03d5d5
	if ErrorLevel = 0
		{
		Click, varyby1+3
		Sleep, wait100to500milis-50
		Goto, NowFishing
		}
	else
		Sleep, 300
}


Loop, 10 ;look at spot two
{
MouseMove, ox+233+varyby4, ox+181+varyby4, 0
	Sleep, wait800to1200milis
	PixelSearch, ViableX, ViableY, ox+80, oy+13, ox+80, oy+13, 0x03d5d5
	if ErrorLevel = 0
		{
		Click, varyby1+3
		Sleep, wait100to500milis-50
		Goto, AtSpotTwo
		}
	else
		Sleep, 300
}

NowFishing:

Loop, 100 ;wait until inventory full or fishing spot empty
	{
	PixelSearch, ViableX, ViableY, ox+80, oy+13, ox+80, oy+13, 0x03d5d5 ;check fishing spot
		if ErrorLevel = 0
			{
			PixelSearch, InvFullX, InvFullY, ox+80, oy+13, ox+80, oy+13, 0x03d5d5 ;check inventory
				if ErrorLevel = 0
					Goto, DoneFishing
				else 
					Continue
			}
		else
			Goto, FishAt
	}	






Gosub, ChatBot

Loop, 150 ;check if client has been disconnected for 150 seconds
	{
	Gosub, LogOutCheck
	Gosub, DisconnectCheck
	Gosub, GetRandoms
	Sleep, 850+wait100to500milis
	}
Loop, 800 ;spend remaining seconds waiting for last fish to appear inventory
	{
	PixelSearch, DoneGatheringX, DoneGatheringY, ox+706, oy+446, ox+706, oy+446, 0x868690
		if ErrorLevel = 0
			Goto, AfterLogin
		else
			Gosub, GetRandoms
			Sleep, 850+wait100to500milis
	}

AfterLogin:


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 100 ;look for Box on minimap
	{
	ImageSearch, BoxReturnX, BoxReturnY, ox+585, oy+108, ox+587, oy+110, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn
		else
			Sleep, wait1to15milis
	}
Loop, 10 ;try looking for Box again with longer wait intervals and wider search range
	{
	ImageSearch, BoxReturnX, BoxReturnY, ox+579, oy+102, ox+599, oy+122, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn
		else
			Sleep, wait100to500milis
	}
Loop, 5 ;try looking for Box again with even longer wait intervals and even wider search range (third try)
	{
	ImageSearch, BoxReturnX, BoxReturnY, ox+569, oy+92, ox+609, oy+132, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn
		else
			Sleep, wait2to5sec
	}
Loop, 3 ;try looking for Box again searching whole minimap (fourth try)
	{
	ImageSearch, BoxReturnX, BoxReturnY, ox+565, oy+3, ox+722, oy+162, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn
		else
			Sleep, wait5to10sec
	}
	MsgBox, error with BoxReturn loops
		ExitApp
 
BoxReturn: 


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

MouseMove, BoxReturnX+5, BoxReturnY-3, 0 ;click on Box booth on minimap to return to Box
		Click
	Sleep, wait1to15milis+120
		Click
	Sleep, wait2to5sec

BoxReturnWait:


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 5000 ;wait until arrived at Box booth
	{
	PixelSearch, BoxAt2X, BoxAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b
		if ErrorLevel = 0
			Goto, BoxAt
		else
			Sleep, 1
	}
Loop, 10 ;wait until arrived at Box booth again with longer wait intervals
	{
	PixelSearch, BoxAt2X, BoxAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b
		if ErrorLevel = 0
			Goto, BoxAt
		else
			Sleep, wait100to500milis
	}
Loop, 5 ;wait until arrived at Box booth again with even longer wait intervals (third try)
	{
	PixelSearch, BoxAt2X, BoxAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b
		if ErrorLevel = 0
			Goto, BoxAt
		else
			Sleep, wait5to10sec+1000 
	}
Loop, 100 ;if still not at Box booth yet, look for Box again on minimap with longer wait intervals
	{
	ImageSearch, BoxReturn2X, BoxReturn2Y, ox+585, oy+108, ox+587, oy+110, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn2
		else
			Sleep, wait1to15milis
	}
Loop, 5 ;look for Box again on minimap with even longer wait intervals (third try)
	{
	ImageSearch, BoxReturn2X, BoxReturn2Y, ox+565, oy+3, ox+722, oy+162, BoxOrient.png
		if ErrorLevel = 0
			Goto, BoxReturn2
		else
			Sleep, wait5to10sec+500 
	}
	MsgBox, error with BoxAt2/BoxReturn2 loops
		ExitApp

BoxReturn2: 


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

MouseMove, BoxReturn2X+5, BoxReturn2Y-3, 10 ;click on Box booth on minimap to return to Box with longer wait intervals
	Sleep, wait5to10sec+2000 
		Click
	Sleep, wait1to15milis+20
		Click
	Sleep, wait5to10sec+2000 
Loop, 100 ;wait until arrived at Box booth
	{
	PixelSearch, BoxAt2X, BoxAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b
		if ErrorLevel = 0
			Goto, BoxAt
		else
			Sleep, wait100to500milis
	}
Loop, 10 ;try again with longer wait intervals
	{
	PixelSearch, BoxAt2X, BoxAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b
		if ErrorLevel = 0
			Goto, BoxAt
		else
			Sleep, wait5to10sec+2000 
	}
	MsgBox, error with BoxAt2/BoxReturn2 loops
		ExitApp

BoxAt:

MouseMove, ox+varyby4+256, oy+varyby4+186, 0 ;open deposit box
	Sleep, wait100to500milis
		Click, varyby2+4
	Gosub, GetRandoms
Sleep, wait100to500milis+300
Loop, 1000 ;wait for box screen to appear
	{
	Gosub, GetRandoms
	PixelSearch, BoxWindowX, BoxWindowY, ox+140, oy+50, ox+140, oy+50, 0x1f98ff
		if ErrorLevel = 0
			Goto, ContinueBoxWindow
		else
			{
			MouseMove, ox+varyby4+256, oy+varyby4+186, 0
			Sleep, 300
			Click
			Sleep, wait100to500milis+300
			}
	}

ContinueBoxWindow:


Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 10 ;deposit inventory
	{
	Gosub, GetRandoms
	PixelSearch, InvSlot2EmptyX,InvSlot2EmptyY, ox+620, oy+220, ox+620, oy+230, 0x354049
		if ErrorLevel = 0
			Goto, ContinueInvSlot2Empty
		else
			{
			MouseMove, ox+varyby4+177, oy+varyby4+95, 0 ;right click second stack of items in deposit box window
				Sleep, wait200to500milis
					Click, right
					Gosub, GetRandoms
				Sleep, wait200to500milis
			MouseMove, ox+varyby10+177, oy+varyby4+168, 0 ;select "all" on drop down second stack of items in inventory
					Gosub, GetRandoms
				Sleep, wait200to500milis
					Click
					Gosub, GetRandoms
				Sleep, wait800to1200milis+400
			}
	}


Gosub, GetRandoms
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

;debugging only
MsgBox, Generated Number %Behavior%
;1/5 chance per trip to check fishing skill stats to better mimic human getting impatient while training
if Behavior > 80
Gosub, CheckFishingStats
;1/20 chance per trip to logout briefly to simulate a "bathroom break" 
if Behavior > 95
Gosub, BriefLogout
;1/10 chance per trip of stopping macro completely
if Behavior > 10
Goto, Start
else
ExitApp

;beginning of subroutines

LogOutCheck: ;if client has been unexpectedly booted to main login screen, attempt to log back in
	PixelSearch, LogOutX, LogOutY, ox+73, oy+485, ox+73, oy+485, 0xffffff
		if ErrorLevel = 0 ;if client logged out, log back in and go back to starting position
		{ 

		Sleep, wait5to10sec+2000
			Send {Enter} ;same as clicking "existing user" button
		Random, wait2to5sec, 2000, 5000
		Sleep, wait2to5sec-1000
			Send {Raw}B
		Random, wait2to5sec, 2000, 5000
		Sleep, wait2to5sec-1000
			Send {Tab}
		Random, wait2to5sec, 2000, 5000
		Sleep, wait2to5sec-1500
			Send {Raw}zkRE6rJc3URG8ic6Vwyt
		Random, wait2to5sec, 2000, 5000
		Sleep, wait2to5sec-1000
			Send {Enter}
		Random, wait5to10sec, 2000, 5000
		Sleep, wait5to10sec
	Random, wait5to10sec, 2000, 5000
		PostLogin:
		Loop, 25
			{
			PixelSearch, PostLoginX, PostLoginY, ox+762, oy+500, ox+762, oy+500, 0x000000 ;look for black pixel in bottom right corner of screen where HUD should be
				if Errorlevel = 0
					{	
		ImageSearch, PostLoginButtonX, PostLoginButtonY, 0, 0, A_Screenwidth, A_Screenheight, PostLoginButton.png ;check if post-login screen has been reached, if not, try hitting login button again
						if ErrorLevel = 0
								{
							MouseMove, PostLoginButtonX+varyby8+35, PostLoginButtonY+varyby8+25, 50
								Sleep, wait1to3sec
									Click
								Random, wait5to10sec, 2000, 5000
								Sleep, wait5to10sec+2000
						PixelSearch, LogOutX, LogOutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating World selection
							if ErrorLevel
								Goto, AfterLogin
								else
								Goto, PostLogin
								}
						else
								{
								Random, wait2to5sec, 2000, 5000 
								Sleep, Wait2to5sec
							Send {Enter} ;try hitting login button again if can't connect to server yet
									Random, wait5to10sec, 2000, 5000
								Sleep, wait5to10sec+5000
								}
					}
				else
					{
						Random, wait2to5sec, 2000, 5000 
						Sleep, Wait2to5sec
					Send {Enter} ;try hitting login button again if can't connect to server yet
							Random, wait5to10sec, 2000, 5000
						Sleep, wait5to10sec+5000
					}
			}
			MsgBox, cant get past post-login or error with LogOutCheck loop
				ExitApp
		}
		else
			Return ;abort subroutine and return to location it was called from
DisconnectCheck: ;check if client has been unexpectedly disconnected and booted to post-login screen; if so, attempt to log back in
		PixelSearch, PostLoginX, PostLoginY, ox+762, oy+500, ox+762, oy+500, 0x000000 ;look for black pixel in bottom right corner of screen where HUD should be
			if ErrorLevel = 0
				{
			ImageSearch, PostLoginButtonX, PostLoginButtonY, 0, 0, A_Screenwidth, A_Screenheight, PostLoginButton.png ;to make sure client has been disconnected, look for post-login button
				if ErrorLevel = 0
					{
							Random, wait2to5sec, 2000, 5000 
							Sleep, wait2to5sec
						MouseMove, PostLoginButtonX+varyby8+40, PostLoginButtonY+varyby4+20, 50
							Random, wait2to5sec, 2000, 5000 
							Sleep, wait2to5sec
								Click
						Random, wait5to10sec, 2000, 5000
							Sleep, wait5to10sec
					PixelSearch, LogOutX, LogOutY, ox+73, oy+485, ox+73, oy+485, 0xffffff ;check if client has successfully logged back in by checking for absence of white text in lower-left corner of client indicating World selection
						if ErrorLevel 
								Goto, AfterLogin
						else
							Goto, DisconnectCheck
					}
				else
					Return ;abort subroutine and return to location it was called from
				}
			else
				Return ;abort subroutine and return to location it was called from
GetRandoms:	
	;generate random delays for character actions
	Random, wait1to5milis, 1, 5
	Random, wait1to15milis, 1, 15
	Random, wait100to500milis, 100, 500 
	Random, wait200to500milis, 200, 500 
	Random, wait800to1200milis, 800, 1200 
	Random, wait1to3sec, 1000, 3000 
	Random, wait2to5sec, 2000, 5000 
	Random, wait5to10sec, 5000, 10000 

	;generate random numbers for varying mouse clicking coordinates
	Random, varyby1, -1, 1
	Random, varyby2, -2, 2
	Random, varyby4, -4, 4
	Random, varyby6, -6, 6
	Random, varyby8, -8, 8
	Random, varyby10, -10, 10
	Random, varyby12, -12, 12
Return

ChatBot:
Sleep, wait5to10sec+10000
Random, wait5to10sec, 5000, 10000
Sleep, wait5to10sec+3000
Random, ChatBehavior, 1, 10 ;generate random number for determining if macro will chat while fishing

if ChatBehavior > 9 ;1/10 chance per trip of typing something into chat
	{
	Random, SelectChat, 0, 101 ;if macro decides to chat, determine which message it will type
		if 40 > SelectChat > 20 ;type the following if number is between 20 and 40
			{
			Send {Raw}love me sum fishez
			Send {Enter}
			Return
			}
		if 60 > SelectChat > 40
			{
			Send {Raw}wonder how many of you are bots
			Send {Enter}
			Return
			}
		if 80 > SelectChat > 60
			{
			Send {Raw}fish/wc lvls?
			Send {Enter}
			Sleep, wait5to10sec+2000
			Send {Raw}mine is OVER 9000!!!!
			Send {Enter}
			Sleep, wait2to5sec+1000
			Send {Raw}jk its like two
			Send {Enter}
			Return
			}
		if 100 > SelectChat > 60
			{
			Send {Raw}so boward
			Send {Enter}
			}
else
Return
;hotkeys
^q::ExitApp
^p::Pause
