#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;begin by standing in front of Edgeville bank booth (second closest one to furnace) with cannon ball mold already in first inventory slot
;you must have enough run energy to make it to the furnace and back
;run energy must be nearly full and turned on; steel bars must be first item of second row in bank
;bank pin must have already been entered

;it takes just under 162 seconds to smelt an inventory
;an entire trip takes about 2m55.8s (175.84s), round up to 180s to err on side of conservatism
;smelting 100 bars would take 0h 11m 6s (667s)
;smelting 1,000 bars would take 1h 51m (6,667s)
;smelting 10,000 bars would take 18h31m (66,667s)

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

OrientClient()

OpenBank()
{
	Global
	Random, varyby11, -11, 11
	Random, varyby5, -5, 5
	MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to100milis, 5, 100
				Sleep, wait5to100milis
			Click, up
				Random, DoubleClickRoll, 1, 20 ;chance to double-click
					if DoubleClickRoll = 1
						{
							Random, wait90to250milis, 90, 250
							Sleep, wait90to250milis
								Click, down
									Random, wait5to100milis, 5, 100
									Sleep, wait5to100milis
								Click, up
						}
	Loop, 3
		{
		Loop, 1000 ;wait for bank screen to appear
			{
			PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 1, Fast
				if ErrorLevel = 0
					Deposit()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec in total for bank screen to appear
					}
			} ;if loop fails, try clicking on bank again -- try 3 times before aborting macro
			Random, varyby11, -11, 11
			Random, varyby5, -5, 5
			MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position (again)
				Random, wait200to500milis, 200, 500
				Sleep, wait200to500milis+500
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
						Random, DoubleClickRoll, 1, 20 ;chance to double-click on bank
							if DoubleClickRoll = 1
								{
									Random, wait90to250milis, 90, 250
									Sleep, wait90to250milis
										Click, down
											Random, wait5to100milis, 5, 100
											Sleep, wait5to100milis
										Click, up
								}
		}
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because cant open bank
		Gui, Show, Y15, Msgbox
			AbortLogout()
}

Deposit()
{
	Global
	Gui, Destroy ;deposit inventory
	Gui, Add, Text, ,Depositing inventory ...
	Gui, Show, Y15, Msgbox
		Random, wait200to400milis, 200, 400
		Sleep, wait200to400milis
			Random, varyby10, -10, 10
			Random, varyby9, -9, 9
			MouseMove, ox+varyby10+620, oy+varyby9+228, 0 ;second item in inventory
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down, right
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up, right
		Random, wait300to900milis, 200, 900
		Sleep, wait300to900milis
			Random, varyby25, -25, 25
			Random, varyby5, -5, 5
			MouseMove, varyby25+0, varyby5+73, 0, R ;second inventory spot Deposit-All right-click option
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
	Loop, 3
		{
		Loop, 1000 ;wait for inventory to be deposited
			{
			PixelSearch, InvSlot2EmptyX,InvSlot2EmptyY, ox+620, oy+220, ox+620, oy+230, 0x354049, 1, Fast
				if ErrorLevel = 0
					Withdrawal()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec total for inv to be deposited
					}
			} ;if loop fails, try depositing inv again -- try 3 times before aborting macro
			Random, wait200to400milis, 200, 400
			Sleep, wait200to400milis
				Random, varyby10, -10, 10
				Random, varyby9, -9, 9
				MouseMove, ox+varyby10+620, oy+varyby9+228, 0 ;second item in inventory
					Random, wait300to900milis, 200, 900
					Sleep, wait300to900milis
						Click, down, right
							Random, wait5to100milis, 5, 100
							Sleep, wait5to100milis
						Click, up, right
			Random, wait300to900milis, 200, 900
			Sleep, wait300to900milis
				Random, varyby25, -25, 25
				Random, varyby5, -5, 5
				MouseMove, varyby25+0, varyby5+73, 0, R ;second inventory spot Deposit-All right-click option
					Random, wait300to900milis, 200, 900
					Sleep, wait300to900milis
						Click, down
							Random, wait5to100milis, 5, 100
							Sleep, wait5to100milis
						Click, up
		}
		Gui, Destroy
		Gui, Add, Text, AbortLogout called because cant deposit inventory
		Gui, Show, Y15, Msgbox
			Random, wait300to900milis, 200, 900
			Sleep, wait300to900milis
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				MouseMove, varyby9+486, varyby8+23, 0 ;X in top right corner of bank window
					Random, wait300to900milis, 200, 900
					Sleep, wait300to900milis
						Click, down
							Random, wait5to100milis, 5, 100
							Sleep, wait5to100milis
						Click, up
		AbortLogout()
}

Withdrawal()
{
Global
Loop, 1000 ;look for steel bars
	{
	PixelSearch, BarsX, BarsY, ox+89, oy+132, ox+89, oy+132, 0x6e6f77, 1, Fast
		if ErrorLevel = 0
			Goto, Barswithdrawal
		else
			Sleep, 1
	}
	Gui, Destroy
	Gui, Add, Text, ,AbortLogout called because out of steel bars
	Gui, Show, Y15, Msgbox
		AbortLogout()
Barswithdrawal:

LogOutCheck() ;check if client has been disconnected
DisconnectCheck()

;withdrawal steel bars
Gui, Destroy
Gui, Add, Text, ,Withdrawing bars ...
Gui, Show, Y15, Msgbox
	Random, wait200to400milis, 200, 400
	Sleep, wait200to400milis
		Random, varyby11, -11, 11
		Random, varyby10, -10, 10
		MouseMove, ox+varyby11+88, oy+varyby10+136, 0 ;first item in second row of bank
			Random, wait300to900milis, 200, 900
			Sleep, wait300to900milis
				Click, down, right
					Random, wait5to100milis, 5, 100
					Sleep, wait5to100milis
				Click, up, right
	Random, wait300to900milis, 200, 900
	Sleep, wait300to900milis
		Random, varyby25, -25, 25
		Random, varyby5, -5, 5
		MouseMove, varyby25+0, varyby5+73, 0, R ;Withdrawal-All right-click option
			Random, wait300to900milis, 200, 900
			Sleep, wait300to900milis
				Click, down
					Random, wait5to100milis, 5, 100
					Sleep, wait5to100milis
				Click, up
Loop, 3
	{
	Loop, 1000 ;wait for bars to appear in inventory
		{
			PixelSearch, InvBarsX,InvBarsY, ox+706, oy+409, ox+706, oy+409, 0x868690, 1, Fast
			if ErrorLevel = 0
				GoToFurnace()
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis ;wait 5-10sec total for inv to be deposited
				}
		} ;if loop fails, try again -- try 3 times before aborting macro
		Random, wait200to400milis, 200, 400
		Sleep, wait200to400milis
			Random, varyby10, -10, 10
			Random, varyby9, -9, 9
			MouseMove, ox+varyby10+88, oy+varyby9+136, 0 ;location of bars in bank
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down, right
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up, right
		Random, wait300to900milis, 200, 900
		Sleep, wait300to900milis
			Random, varyby25, -25, 25
			Random, varyby5, -5, 5
			MouseMove, varyby25+0, varyby5+73, 0, R ;Withdrawal-All right-click option
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
	}
	Gui, Destroy
	Gui, Add, Text, ,AbortLogout called because cant deposit inventory
	Gui, Show, Y15, Msgbox
		Random, wait300to900milis, 200, 900
		Sleep, wait300to900milis
			Random, varyby9, -9, 9
			Random, varyby8, -8, 8
			MouseMove, varyby9+486, varyby8+23, 0 ;X in top right corner of bank window
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
	AbortLogout()
}

GoToFurnace()
{
Global
Loop, 1000 ;look for furnace on minimap
	{
	PixelSearch, FurnaceGoX, FurnaceGoY, ox+696, oy+64, ox+696, oy+64, 0x1e73fe, 1, Fast
		if ErrorLevel = 0
			Goto, FurnaceGo
		else
			{
			Random, wait5to10milis, 5, 10
			Sleep, wait5to10milis ;wait 5-10sec total
			}
	}
	Gui, Destroy
	Gui, Add, Text, ,AbortLogout called because cant find furnace on minimap
	Gui, Show, Y15, Msgbox
		AbortLogout()
FurnaceGo:

LogOutCheck() ;check if client has been disconnected
DisconnectCheck()

Random, varyby7, -7, 7
Random, varyby4, -4, 4
MouseMove, ox+varyby7+689, oy+varyby4+64, 0 ;furnace on minimap
	Random, wait200to500milis, 200, 500
	Sleep, wait200to500milis+500
		Click, down
			Random, wait5to100milis, 5, 100
			Sleep, wait5to100milis
		Click, up
			Random, DoubleClickRoll, 1, 25 ;chance to double-click
				if DoubleClickRoll = 5
					{
						Random, wait90to250milis, 90, 250
						Sleep, wait90to250milis
							Click, down
								Random, wait5to100milis, 5, 100
								Sleep, wait5to100milis
							Click, up
					}
Random, wait5to10sec, 5000, 10000
Sleep, wait5to10sec
}

AtFurnace()
{
Global
InFrontofFurnaceCheck:
	Loop, 1000 ;wait until transportation arrow appears in right edge of minimap
		{
		PixelSearch, FurnaceAt2X, FurnaceAt2Y, ox+711, oy+94, ox+711, oy+94, 0x1b67db, 1, Fast
			if ErrorLevel = 0
				FurnaceAt()
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis ;wait 5-10sec total
				}
		}
}

	;ADD ADDITIONAL ELSE OPTIONS TO THIS LOOP FOR STUCK POSITIONS IN FRONT OF FURNACE


Smelt()
{
Global
LogOutCheck() ;check if client has been disconnected
DisconnectCheck()

Random, wait300to900milis, 200, 900
Sleep, wait300to900milis
	Random, varyby7, -6, 6
	Random, varyby4, -4, 4
	MouseMove, ox+varyby6+621, oy+varyby4+230, 0 ;select first steel bar
		Random, wait300to900milis, 200, 900
		Sleep, wait300to900milis
			Click, down
				Random, wait5to100milis, 5, 100
				Sleep, wait5to100milis
			Click, up
		Random, wait300to900milis, 200, 900
		Sleep, wait300to900milis
			Random, varyby12, -12, 12
			Random, varyby4, -4, 4
			MouseMove, ox+varyby4+300, oy+varyby12+162, 0 ;click on furnace to open smelting chat menu
				Random, wait300to900milis, 200, 900
				Sleep, wait300to900milis
					Click, down
						Random, wait5to100milis, 5, 100
						Sleep, wait5to100milis
					Click, up
Loop, 1000 ;wait until cannonball icon appears in chat menu
	{
	PixelSearch, BeginSmeltX, BeginSmeltY, ox+256, oy+435, ox+256, oy+435, 0x3a3a3f, 1, Fast
		if ErrorLevel = 0
			Goto, BeginSmelt
		else
			{
			Random, wait5to10milis, 5, 10
			Sleep, wait5to10milis ;wait 5-10sec total
			}
	}
	Gui, Destroy
	Gui, Add, Text, ,AbortLogout called because cant see cannonball icon in chat menu
	Gui, Show, Y15, Msgbox
		AbortLogout()
BeginSmelt:

Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Send {Space down} ;hit space bar to begin smelting
	Random, wait20to150milis, 20, 150
	Sleep, wait20to150milis
Send {Space up}
	Random, wait2to5sec, 2000, 5000
	Sleep, wait2to5sec
		Gui, Destroy
		Gui, Add, Text, ,Rolling for behaviors ... ;roll for randomized "human-simulating" behavior
		Gui, Show, Y15, Msgbox
			Random, wait100to150milis, 100, 150
			Sleep, wait100to150milis
				Random, SelectChatRoll, 1, 20
					if SelectChatRoll = 1 ;chance per inventory to enter predetermined text into chat (chance should be lower than BriefLogout chances to prevent duplicate messages appearing to the same people)
						Gosub, SelectChat
				Random, CheckStatsRoll, 1, 8
					if CheckStatsRoll = 1 ;chance per inventory to check skill stat and xp
						Gosub, CheckStats
		Gui, Destroy
	Loop, 150 ;check if client has been disconnected once per second for 150 seconds
		{
		Gosub, LogOutCheck
		Gosub, DisconnectCheck
		Sleep, 990
		}
	Loop, 900 ;use final 3 seconds waiting for last steel bar to disappear from inventory
		{
		PixelSearch, DoneSmeltingX, DoneSmeltingY, ox+706, oy+446, ox+706, oy+446, 0x868690, 1, Fast
			if ErrorLevel
				{
				Random, RandomSleepRoll, 1, 3
				if RandomSleepRoll = 1 ;chance per inventory to briefly "stall"
					Gosub, RandomSleep
				Goto, AfterLogin
				}
			else
				Sleep, 50
		}
}


GoToBank()
{
Global
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Loop, 1000 ;look for bank on minimap
	{
	ImageSearch, BankReturnX, BankReturnY, ox+585, oy+108, ox+587, oy+110, BankOrient.png
		if ErrorLevel = 0
			Goto, BankReturn
		else
			{
			Random, wait5to10milis, 5, 10
			Sleep, wait5to10milis
			}
	}
Loop, 5 ;try looking for bank again searching whole minimap (2nd try)
	{
	ImageSearch, BankReturnX, BankReturnY, ox+565, oy+3, ox+722, oy+162, BankOrient.png
		if ErrorLevel = 0
			Goto, BankReturn
		else
			{
			Random, wait5to10milis, 5, 10
			Sleep, wait5to10milis
			}
	}
	Gui, Destroy
	Gui, Add, Text, ,AbortLogout called because cant find bank after smelting
	Gui, Show, Y15, Msgbox
		Goto, AbortLogout
BankReturn:





Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Random, varyby3, -3, 3
Random, varyby4, -4, 4
MouseMove, varyby3+BankReturnX+5, varyby4+BankReturnY-3, 0 ;bank on minimap
	Random, wait200to500milis, 200, 500
	Sleep, wait200to500milis+500
		Click, down
			Random, wait5to100milis, 5, 100
			Sleep, wait5to100milis
		Click, up
			Random, DoubleClickRoll, 1, 5 ;chance to double-click
				if DoubleClickRoll = 1
					{
						Random, wait90to250milis, 90, 250
						Sleep, wait90to250milis
							Click, down
								Random, wait5to100milis, 5, 100
								Sleep, wait5to100milis
							Click, up
					}
BankReturnWait:





Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

	Random, wait4to8sec, 4000, 8000
	Sleep, wait4to8sec ;wait until arrived at bank booth
Loop, 1000 ;look for bank booth
	{
	PixelSearch, BankAt2X, BankAt2Y, ox+595, oy+47, ox+595, oy+47, 0xe78d7b, 1, Fast
		if ErrorLevel = 0
			Goto, BankAt
		else
			{
			Random, wait8to10milis, 8, 10
			Sleep, wait8to10milis
			}
	}




;ADD ADDITIONAL ELSE OPTIONS TO THIS LOOP FOR STUCK POSITIONS IN FRONT OF BANK




BankAt:

Random, wait160to250milis, 160, 250
Sleep, wait160to250milis ;wait for character to stop moving
	Random, BriefLogoutRoll, 1, 30
		if BriefLogoutRoll = 1 ;chance per inventory to logout briefly to simulate a quick break
			Goto, BriefLogout

	Random, AbortLogoutRoll, 1, 55
		if AbortLogoutRoll = 1 ;chance per inventory to logout and stop macro completely
			{
			Gui, Destroy
			Gui, Add, Text, ,AbortLogout randomly called
			Gui, Show, Y15, Msgbox
				Goto, AbortLogout
			}
Gosub, LogOutCheck ;check if client has been disconnected
Gosub, DisconnectCheck

Goto, Start
}



CheckStats()
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
			MouseMove, ox+varyby13+576, oy+varyby8+185, 0 ;stats icon
				Random, wait200to900milis, 200, 900
				Sleep, wait200to900milis+300
				Gosub, LogoutCheck
				Gosub, DisconnectCheck
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
						Gosub, LogoutCheck
						Gosub, DisconnectCheck
							Click, down
								Random, wait5to100milis, 5, 100
								Sleep, wait5to100milis
							Click, up
	Gui, Destroy
Return
}

SelectChat()
{
Global
SelectChat:
	Random, wait500to900milis, 500, 900
	Sleep, wait500to900milis
		Random, varyby10, -10, 10
		Random, varyby9, -9, 9
		MouseMove, ox+varyby10+258, oy+varyby9+144, 0 ;click on rock
			Random, wait200to500milis, 200, 500
			Sleep, wait200to500milis
				Click, down
					Random, wait5to100milis, 5, 100
					Sleep, wait5to100milis
				Click, up
					Random, DoubleClickRoll, 1, 32 ;small chance to double-click on rock
						if DoubleClickRoll = 1
							{
							Random, wait180to500milis, 180, 500
							Sleep, wait180to500milis
								Click, down
									Random, wait5to100milis, 5, 100
									Sleep, wait5to100milis
								Click, up
							Random, wait300to600milis, 300, 600
							Sleep, wait300to600milis
							Gui, Destroy
							}
	Random, SelectChat, 1, 14 ;if macro decides to chat, determine which message it will type, with equal chances for each message
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
			Send {Raw}why is smithing so slow to lvl
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
			Send {Raw}making cannonballsz is sooo fun
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		if SelectChat = 12
			{
			Send {Raw}smelting = fun
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
			Send {Raw}oink
				Random, wait400to700milis, 400, 700
				Sleep, wait400to700milis+1000
			Send {Enter}
			}
		else
			Sleep, 1
	Gui, Destroy
	Gui, Add, Text, ,SelectChat (%SelectChat%) rolled ...
	Gui, Show, Y15, Msgbox
		Random, wait300to600milis, 300, 600
		Sleep, wait300to600milis
	Gui, Destroy
Return
}

;hotkeys
^q::ExitApp
^p::
{
Gui, Destroy
ListVars
ListLines
KeyHistory
Pause
}
