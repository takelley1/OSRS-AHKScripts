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

Orient()

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



Loop, 1000 ;look for flax
	{
	PixelSearch, FlaxX, FlaxY, ox+228, oy+133, ox+228, oy+133, 0xBBB756
		if ErrorLevel = 0
			Goto, Flaxwithdrawal
		else
			Sleep, 1
	}
	
Flaxwithdrawal:



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

Loop, 150 ;check if got unstuck and reached spinning wheel by looking for chat menu
	{
	PixelSearch, SpinningChatMenuX, SpinningChatMenuY, ox+468, oy+356, ox+468, oy+356, 0x7E9194
	if ErrorLevel = 0
			Goto, StartSpinning
		else
			Sleep, 100
	}
StartSpinning:





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

^q::ExitApp
^p::Pause
