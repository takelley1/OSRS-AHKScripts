#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
 #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;begin at lumbridge bank, middle booth
;client must be oriented north (click compass) and camera must be tilted all the way upwards (hold arrow key)
;client must also be fully zoomed out and brightness set at default
;run must be turned on with enough energy to get there and back

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

Gosub, GetRandoms ;obtain random numbers
;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
	if ErrorLevel = 0
		{
			Sleep, wait100to500milis
		MouseMove, OrientX, OrientY ;move mouse to top left pixel of client to create new origin point for coordinate system
			Sleep, wait200to500milis
		MouseMove, -696, -171, 0, R ; 0, 0 ;coordinates from prayer icon to origin point
			Sleep, wait200to500milis+wait1to15milis
		MouseGetPos, ox, oy
		}
	else
		{
		MsgBox, Can’t find client!
			ExitApp
		}	
Goto, Start
;Start: ;begin main loop




Gosub, GetRandoms 
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

MouseMove, ox+262+varyby4, oy+132+varyby4, 0 ;open bank from starting position
	Sleep, wait200to500milis
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, wait800to1200milis
Loop, 250 ;wait for bank screen to appear
	{
	PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
		if ErrorLevel = 0
			Goto, ContinueBankWindow
		else
			{
			Click
			Sleep, wait200to500milis*3
			}
	}
Loop, 10 ;try again with longer wait intervals
	{
	PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
		if ErrorLevel = 0
			Goto, ContinueBankWindow
		else
			{
			Gosub, GetRandoms 
				Click
				Sleep, wait200to500milis
				Click
				Sleep, wait2to5sec+1000
			}
	} 
	MsgBox, error with BankWindow loop
		ExitApp

ContinueBankWindow:




Gosub, GetRandoms 
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 100 ;wait for inventory to be deposited
	{
	PixelSearch, InvSlot3EmptyX,InvSlot3EmptyY, ox+659, oy+229, ox+659, oy+229, 0x333c45
		if ErrorLevel = 0
			Goto, ContinueInvSlot3Empty
		else
			{
			MouseMove, ox+620+varyby4, oy+228+varyby3, 0 ;right click second stack of items in inventory
				Sleep, wait200to500milis
				Click, right
				Gosub, GetRandoms 
				Sleep, wait200to500milis
			MouseMove, ox+620+varyby5, oy+328+varyby2, 0 ;select "all" on drop down second stack of items in inventory
				Sleep, wait200to500milis
				Click
				Gosub, GetRandoms 
				Sleep, wait200to500milis
			}
	}

ContinueInvSlot3Empty:




Gosub, GetRandoms 
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 1000 ;look for flax
	{
	PixelSearch, FlaxX, FlaxY, ox+228, oy+133, ox+228, oy+133, 0xBBB756
		if ErrorLevel = 0
			Goto, Flaxwithdrawal
		else
			Sleep, 1
	}
	
Flaxwithdrawal:




Gosub, GetRandoms 
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 150 ;withdrawal and wait for flax to appear in inventory
	{
	PixelSearch, InvFlaxX,InvFlaxY, ox+574, oy+227, ox+574, oy+227, 0xBBB756
		if ErrorLevel = 0
			Goto, ContinueInvFlax
		else
			{
			MouseMove, ox+233+varyby4, oy+134+varyby3, 0 
				Sleep, wait200to500milis
				Click, right
				Gosub, GetRandoms 
				Sleep, wait200to500milis
			MouseMove, ox+233+varyby3, oy+234+varyby2, 0 
				Sleep, wait200to500milis+50
				Click
				Gosub, GetRandoms 
				Sleep, wait200to500milis
			}
	}

ContinueInvFlax:




Gosub, GetRandoms 
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

MouseMove, ox+631+varyby2, oy+129+varyby2, 0 ;click on stairs on minimap
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, 4000
Loop, 100 ;wait until bank teller minimap yellow dot moves towards top of minimap
	{
	PixelSearch, StairsAtTopX, StairsAtTopY, ox+657, oy+30, ox+657, oy+30, 0x13FEFE
		if ErrorLevel = 0
			Goto, StairsAtTop
		else
			Sleep, 100
	}
StairsAtTop:




Gosub, GetRandoms 

;go down stairs
Sleep, 5000
MouseMove, ox+253+varyby5, oy+205+varyby5, 0 ;top of stairs, click to go down
	Sleep, wait100to500milis
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, wait800to1200milis
Loop, 500 ;wait until at bottom of stairs
	{
	PixelSearch, SpinningWheelIconX, SpinningWheelIconY, ox+671, oy+67, ox+671, oy+67, 0x406694
	if ErrorLevel = 0
			Goto, ContinueToWheel
		else
			Sleep, wait200to500milis
	}
	MsgBox, cant tell if at bottom of stairs, error with ContinueToWheel loop
		ExitApp

ContinueToWheel:




Gosub, GetRandoms 

MouseMove, ox+337+varyby3, oy+81+varyby3, 0 ;spinning wheel, click to go to it, through wall
	Sleep, wait100to500milis
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, wait2to5sec
Loop, 100 ;wait until at spinning wheel by looking for chat menu
	{
	PixelSearch, SpinningChatMenuX, SpinningChatMenuY, ox+468, oy+356, ox+468, oy+356, 0x7E9194
	if ErrorLevel = 0
			Goto, StartSpinning
		else
			Sleep, 40
	}
Loop, 10	
	{
	PixelSearch, StuckX, StuckY, ox+671, oy+98, ox+671, oy+98, 0xf6efe5 ;check if character has gotten stuck behind wall
		if ErrorLevel = 0
			{
			MouseMove, ox+320+varyby3, oy+166+varyby3, 0 ;click on spinning wheel again since character may be stuck behind wall
				Click
				Random, DoubleClick, 200, 250
				Sleep, DoubleClick
				Click
			}
		else
			Sleep, 100
	}
Sleep, 3000
Gosub, GetRandoms
 
Loop, 150 ;check if got unstuck and reached spinning wheel by looking for chat menu
	{
	PixelSearch, SpinningChatMenuX, SpinningChatMenuY, ox+468, oy+356, ox+468, oy+356, 0x7E9194
	if ErrorLevel = 0
			Goto, StartSpinning
		else
			Sleep, 100
	}
StartSpinning:




Gosub, GetRandoms 

Send {Raw}3 ;hit 3 key to begin spinning bow strings
Loop, 144 ;check if client has been disconnected twice per second for 72 seconds
	{
	Gosub, LogOutCheck
	Gosub, DisconnectCheck
	Sleep, 460
	}
Gosub, GetRandoms 

Loop, 200 ;use final 3 seconds waiting for last flax to disappear from inventory
	{
	PixelSearch, DoneSpinningX, DoneSpinningY, ox+700, oy+335, ox+700, oy+335, 0xBBB756
		if ErrorLevel = 0
			Sleep, 50
		else
			Goto, AfterSpinning
	}

AfterSpinning:




Gosub, GetRandoms 

MouseMove, ox+107+varyby2, oy+333+varyby2, 0 ;click on stairs within client, just above chat menu on left side
	Sleep, 150
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, wait2to5sec
Loop, 2000 ;wait until stair climb option appears in chat menu
	{
	PixelSearch, StairsAtBottomX, StairsAtBottomY, ox+52, oy+369, ox+52, oy+369, 0x99D5DC
		if ErrorLevel = 0
			Goto, StairsAtBottom
		else
			Sleep, wait200to500milis
	}
	
StairsAtBottom:




Gosub, GetRandoms 

Send {Raw}1 ;select chat option to climb up stairs
	Sleep, wait200to500milis
Send {Raw}1
	Sleep, wait2to5sec+wait100to500milis
Loop, 100 ;wait until bank teller minimap yellow dot appears towards top of minimap, indicating character is back on top floor
	{
	PixelSearch, StairsAtTopReturnX, StairsAtTopReturnY, ox+657, oy+30, ox+657, oy+30, 0x13FEFE
		if ErrorLevel = 0
			Goto, AfterLogin
		else
			Sleep, 100
	}

AfterLogin:




Gosub, GetRandoms 

Loop, 100 ;look for bank on minimap
	{
	ImageSearch, BankReturnX, BankReturnY, ox+665, oy+40, ox+667, oy+41, BankOrient.png
		if ErrorLevel = 0
			Goto, BankReturn
		else
			Sleep, wait200to500milis
	}
Loop, 3 ;try looking for bank again searching whole minimap (fourth try)
	{
	ImageSearch, BankReturnX, BankReturnY, ox+565, oy+3, ox+722, oy+162, BankOrient.png
		if ErrorLevel = 0
		Goto, BankReturn
		else
			Sleep, wait5to10sec
	}
	MsgBox, cant find bank on return or error with BankReturn loops
		ExitApp

BankReturn: 




Gosub, GetRandoms 

MouseMove, BankReturnX-11+varyby2, BankReturnY-2+varyby2, 0 ;click on bank booth on minimap to return to bank
		Click
		Random, DoubleClick, 200, 250
		Sleep, DoubleClick
		Click
	Sleep, wait2to5sec+3000
Loop, 5000 ;wait until arrived at bank booth
	{
	PixelSearch, BankAtX, BankAtY, ox+646, oy+74, ox+646, oy+74, 0x0efefe
		if ErrorLevel = 0
			Goto, BankAt
		else
			Sleep, 5
	}
Loop, 50 ;wait until arrived at bank booth again with longer wait intervals
	{
	PixelSearch, BankAtX, BankAtY, ox+646, oy+74, ox+646, oy+74, 0x0efefe
		if ErrorLevel = 0
			Goto, BankAt
		else
			Sleep, 100
	}
	
BankAt:
	
	
	
	
Gosub, GetRandoms 
/*
Random, Behavior, 0, 101
MsgBox, Generated Number %Behavior% ;debugging only

if Behavior > 80 ;1/5 chance per trip to check crafting skill stats to mimic human
Gosub, CheckStats
if Behavior > 95 ;1/20 chance per trip to logout briefly to simulate a "bathroom break" 
Gosub, BriefLogout
if Behavior > 5 ;1/20 chance per trip of stopping macro completely
Goto, Start
else
ExitApp
*/
Sleep, 65+wait100to500milis ;wait for character to stop moving

Goto, Start




;beginning of subroutines

LogOutCheck: ;if client has been unexpectedly booted to main login screen, attempt to log back in
	PixelSearch, LogOutX, LogOutY, ox+73, oy+485, ox+73, oy+485, 0xffffff
		if ErrorLevel = 0 ;if client logged out, log back in and go back to starting position
		{ 
			Gosub, GetRandoms 
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
				
WhereAmI: ;look for pixel colors at a handful of different locations on-screen to determine where character is after logging back in due to a disconnect
	Loop, 100 ;check if at spinning wheel by looking for corner of castle on minimap
		{
		PixelSearch, SpinningWheelAtX, SpinningWheelAtY, ox+672, oy+93, ox+672, oy+93, 0xf6efe5
			if ErrorLevel = 0
					Goto, AfterSpinning
				else
					Sleep, wait200to500milis
		}
	Loop, 100 ;check if at bottom of stairs by looking for spinning wheel on minimap
		{
		PixelSearch, SpinningWheelIconX, SpinningWheelIconY, ox+671, oy+67, ox+671, oy+67, 0x406694
			if ErrorLevel = 0
					Goto, StairsAtBottom
				else
					Sleep, wait200to500milis
		}
	Loop, 100 ;check if at top of stairs by looking for bank on minimap
		{
		ImageSearch, BankReturnX, BankReturnY, ox+665, oy+40, ox+667, oy+41, BankOrient.png
			if ErrorLevel = 0
				Goto, BankReturn
			else
				Sleep, wait200to500milis
		}
	Loop, 100 ;check if at bank booth
		{
		PixelSearch, BankAtX, BankAtY, ox+646, oy+74, ox+646, oy+74, 0x0efefe
			if ErrorLevel = 0
				Goto, BankAt
			else
				Sleep, wait200to500milis
		}
		MsgBox, cant tell where character is after loggin in after disconnect, or error with WhereAmI loop
			ExitApp
			
CheckStats: ;check skill level at randomized intervals 
		Random, wait800to1200milis, 800, 1200
		Sleep, wait800to1200milis
	MouseMove, ox+varyby5+582, oy+varyby8+315, 0 ;stats icon
		Random, wait200to500milis, 200, 500 
		Sleep, wait200to500milis+100
		Click
		Random, wait800to1200milis, 800, 1200 
		Sleep, wait800to1200milis+wait200to500milis
	MouseMove, ox+varyby8+625, oy+varyby5+160, 0 ;crafting stat box
		Random, wait1to3sec, 1000, 300
		Sleep, wait1to3sec+500
			Random, ViewSkillGuide, 1, 10 ;1/10 chance to click on crafting stat box and view skill guide
				if ViewSkillGuide = 10
					{
					Sleep, wait200to500milis
					Click
					Random, wait800to1200milis
					Sleep, wait800to1200milis
					}
				else
					Continue
	MouseMove, ox+varyby8+636, oy+varyby6+307, 0 ;inventory bag icon
		Random, wait200to500milis, 200, 500 
		Sleep, wait200to500milis+400
		Click
Return

GetRandoms:	
	;generate random delays for character actions
	Random, wait1to5milis, 1, 5
	Random, wait1to15milis, 1, 15
	Random, wait50to100milis, 50, 100
	Random, wait100to500milis, 100, 500 
	Random, wait200to500milis, 200, 500 
	Random, wait800to1200milis, 800, 1200 
	Random, wait1to2sec, 1000, 2000 
	Random, wait1to3sec, 1000, 3000 
	Random, wait2to5sec, 2000, 5000 
	Random, wait5to10sec, 5000, 10000 

	;generate random numbers for varying mouse clicking coordinates
	Random, varyby1, -1, 1
	Random, varyby2, -2, 2
	Random, varyby3, -3, 3
	Random, varyby4, -4, 4
	Random, varyby5, -5, 5
	Random, varyby6, -6, 6
	Random, varyby7, -7, 7
	Random, varyby8, -8, 8
	Random, varyby9, -9, 9
	Random, varyby10, -10, 10
	Random, varyby11, -11, 11
	Random, varyby12, -12, 12
	Random, varyby15, -15, 15
Return

^q::ExitApp
^p::Pause
