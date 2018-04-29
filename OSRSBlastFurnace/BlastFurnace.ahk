#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;BlastFurnaceTextDoc
;begin facing blast furnace bank chest with coin stack you intend to deposit into coffer

;7 runs can be completed before stopping for run energy to regenerate

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
if ErrorLevel = 0
{
Sleep, 100
MouseMove, OrientX, OrientY
Sleep, 100
;move mouse to top left pixel of client to create new origin point for coordinate system
MouseMove, -696, -171, 0, R ; 0, 0 coordinates from prayer icon
MouseGetPos, ox, oy
}
else
{
MsgBox, Can’t find client!
ExitApp
}

;click compass to orient client North
MouseMove, ox+561, oy+20, 0 ;compass
Sleep, 500
Click
Sleep, 5
Click
Sleep, 5
Send {Up down}
Sleep, 750 
Send {Up up}

;configure client zoom settings to be fully zoomed out
MouseMove, ox+675, oy+484, 0 ;options screen location
Sleep, 100
Click
Sleep, 5
Click
Sleep, 100
MouseMove, ox+675, oy+274, 0 ;options screen zoom bar location
Sleep, 100
Click
Sleep, 100
MouseClickDrag, L, ox+675, oy+274,  ox+515, oy+274, 0
Sleep, 100
MouseMove, ox+642, oy+185, 0 ;inventory bag icon
Sleep, 100
Click

;deposit coin stack into coffer
Gosub, Deposit/WithdrawalCoffer

;begin main loop
Loop
{

;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+588, oy+131, ox+588, oy+131, 0x596160 ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 100
Click
}

;check run energy again, at 10% or lower, withdrawal money from coffer and wait till energy has restored itself, then deposit money back into coffer
PixelSearch, RunOutX, RunOutY, ox+586, oy+147, ox+586, oy+147, 0x0B0B0B 
if ErrorLevel = 0
{

;deposit inventory to allow room for coin stack
Sleep, 100
MouseMove, ox+264, oy+195, 0 ;open bank from starting position
Sleep, 100
Click
Sleep, 1
Click

;wait for bank screen to appear
Loop, 250
{
PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
if ErrorLevel = 0
Goto, Continue0BankWindow
else
{
Click
Sleep, 50
Click
Sleep, 600
Continue
}}
MsgBox, error with 0BankWindow loop
ExitApp
Continue0BankWindow:

;deposit inventory
MouseMove, ox+444, oy+314, 0 ;deposit inventory button in bank window
Sleep, 100
Click
Sleep, 3
Click
Sleep, 600

;wait for inventory to be deposited
Loop, 50
{
PixelSearch, InvSlot1EmptyX,InvSlot1EmptyY, ox+579, oy+225, ox+579, oy+225, 0x354049
if ErrorLevel = 0
Goto, Continue0InvSlot1Empty
else
{
MouseMove, ox+444, oy+314, 0 ;deposit inventory button in bank window
Sleep, 100
Click
Sleep, 3
Click
Sleep, 300
}}
MsgBox, error with 0InvSlot1Empty loop
ExitApp
Continue0InvSlot1Empty:

Sleep, 100
MouseMove, ox+487, oy+23, 0 ;bank window close
Click
Sleep, 1
Click

;withdrawal from coffer and return to start position
Gosub, Deposit/WithdrawalCoffer

;keep checking every five seconds until run energy full
Loop, 1800000
{
Sleep, 5000

;click on inventory icon periodically to prevent client timeout
MouseMove, ox+642, oy+185, 0 ;inventory bag icon
Sleep, 100
Click
PixelSearch, RunX, RunY, ox+549, oy+139, ox+549, oy+139, 0x00ff00 ;run 100% energy
if ErrorLevel = 0
{

;when run energy full, return money to coffer
Gosub, Deposit/WithdrawalCoffer
Goto, Start
}}
MsgBox, Error with run energy regeneration loop
ExitApp
}

Start:

;open bank chest in front of you
Sleep, 100
MouseMove, ox+264, oy+195, 0 ;open bank from starting position
Sleep, 100
Click
Sleep, 1
Click

;wait for bank screen to appear
Loop, 250
{
PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
if ErrorLevel = 0
Goto, ContinueBankWindow
else
{
Click
Sleep, 200
Continue
}}
MsgBox, error with BankWindow loop
ExitApp
ContinueBankWindow:

;deposit held bars
MouseMove, ox+665, oy+227, 0 ;right click third stack of items in inventory
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+656, oy+328, 0 ;select "all" on drop down third stack of items in inventory
Sleep, 100
Click
Sleep, 100

;wait for inventory to be deposited
Loop, 50
{
PixelSearch, InvSlot1EmptyX,InvSlot1EmptyY, ox+579, oy+225, ox+579, oy+225, 0x354049
if ErrorLevel = 0
Goto, Continue00InvSlot1Empty
else
{
MouseMove, ox+665, oy+227, 0 ;right click third stack of items in inventory
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+656, oy+328, 0 ;select "all" on drop down third stack of items in inventory
Sleep, 100
Click
Sleep, 100
}}
MsgBox, error with InvSlot1Empty loop
Continue00InvSlot1Empty:

;look for ore, if not present, withdrawal all money from coffer and terminate
PixelSearch, MainOreX, MainOreY, ox+80, oy+100, ox+80, oy+100, 0x48667f
if ErrorLevel
{
Msgbox, No ore
Gosub, Deposit/WithdrawalCoffer
ExitApp
}

PixelSearch, CoalX, CoalY, ox+140, oy+100, ox+140, oy+100, 0x263739
if ErrorLevel
{
Msgbox, No coal
Gosub, Deposit/WithdrawalCoffer
ExitApp
}

;withdrawal ore if present
Sleep, 10
MouseMove, ox+89, oy+96, 0 ;main ore location in bank
Sleep, 50
Click, right
Sleep, 50
MouseMove, ox+89, oy+170, 0 ;main ore right click withdrawal saved X location in bank
Sleep, 50
Click
Sleep, 50
MouseMove, ox+140, oy+96, 0 ;coal ore location in bank
Sleep, 50
Click, right
Sleep, 50
MouseMove, ox+140, oy+166, 0 ;coal ore right click withdrawal saved X location in bank
Sleep, 50
Click
Sleep, 50

;click minimap to move to belt
GoingtoBelt:
MouseMove, ox+618, oy+44, 0 ;belt location on minimap from start
Sleep, 50
Click
Sleep, 1
Click
Sleep, 3000

;Keep checking water icon on minimap until you've arrived at belt
Loop, 400
{
PixelSearch, BeltArriveX, BeltArriveY, ox+639, oy+128, ox+639, oy+128, 0xe78d7b
if ErrorLevel = 0
Goto, ContinueBeltArrive
else
Sleep, 100
}
MsgBox, error with BeltArrive loop
ExitApp
ContinueBeltArrive:

;deposit ore onto belt
Sleep, 100
MouseMove, ox+288, oy+174, 0 ;deposit ore onto belt location
Sleep, 100
Click
Sleep, 1
Click
Sleep, 1
Click
Sleep, 500

;move to and open bar dispenser
MouseMove, ox+213, oy+284, 0 ;dispenser location from belt
Sleep, 100
Click
Sleep, 1
Click
Sleep, 1
Click
Sleep, 2500

;wait for character to arrive at dispenser and stop moving
Loop, 800
{
PixelSearch, DispenserArriveX, DispenserArriveY, ox+647, oy+117, ox+647, oy+117, 0xe78d7b
if ErrorLevel = 0
Goto, ContinueDispenserArrive
Else
Sleep, 100
}
MsgBox, error with DispenserArrive loop
ExitApp
ContinueDispenserArrive:

;if dispenser window is not open, click on dispenser again since you may have a level up pending in the chat window
Sleep, 100
Loop, 100
{
PixelSearch, DispenserWindowX, DispenserWindowY, ox+332, oy+35, ox+332, oy+35, 0x1F98FF
if ErrorLevel = 0
Goto, CheckBars
else
Sleep, 600
MouseMove, ox+263, oy+187, 0 ;at dispenser, open dispenser 
Sleep, 50
Click
Sleep, 50
}
MsgBox, error with opening dispenser window for the first time
ExitApp

;check if finished bars are available, if not, close window and keep reopening until bars are available
CheckBars:
PixelSearch, DispenserBarsPresentX, DispenserBarsPresentY, ox+229, oy+143, ox+229, oy+143, 0x1F98FF

;if bars are available, immediately skip to withdrawing them
if ErrorLevel = 0
Goto, WithdrawalBars

;if bars not available, click on dispenser until window is open and recheck, if bars still not available, close and reopen window again, if you try 25 times and bars still aren’t there then coffer must be empty
else
{
Loop, 25
{

;wait 1/2 tick, then close window
Sleep, 300
MouseMove, ox+487, oy+42, 0 ;dispenser window close
Sleep, 100
Click
Sleep, 100

;keep clicking on dispenser until dispenser window reopens, then recheck bars
Loop, 50
{
PixelSearch, DispenserWindowX, DispenserWindowY, ox+332, oy+35, ox+332, oy+35, 0x1F98FF
if ErrorLevel = 0
Goto, CheckBars
else
MouseMove, ox+263, oy+187, 0 ;at dispenser, open dispenser 
Sleep, 100
Click
Sleep, 100
}
MsgBox, error with DispenserWindow loop
ExitApp
}
MsgBox, error with loop DispenserWindow parent loop
ExitApp
}

;withdrawal bars, keep clicking until in inventory
WithdrawalBars:

MouseMove, ox+229, oy+143, 0 ;location to withdrawal steel bars at dispenser
Click, 2
Sleep, 700

Loop, 10
{
PixelSearch, BarsGetX, BarsGetY, ox+581, oy+228, ox+581, oy+228, 0x868690
if ErrorLevel = 0
Goto, ContinueBarsGet
else
{
MouseMove, ox+229, oy+143, 0 ;location to withdrawal steel bars at dispenser
Click
Sleep, 600
}}
MsgBox, error with BarsGet loop
ContinueBarsGet:

;search for bank icon colors on minimap
Loop, 100
{
PixelSearch, BankfromDispenserX, BankfromDispenserY, ox+674, oy+118, ox+674, oy+118, 0x026475
if ErrorLevel = 0
Goto, GoToBank
else
Sleep, 100
}
MsgBox, error with BankfromDispenser loop
ExitApp
GoToBank:

;if bank found, move mouse upwards slightly and click on icon
MouseMove, BankfromDispenserX+1, BankfromDispenserY-6, 0 ;bank location on minimap from dispenser
Sleep, 50
Click
Sleep, 50
Click
Sleep, 1000

;Keep checking water icon on minimap until you've returned to bank chest
Loop, 500
{
PixelSearch, BankArriveX, BankArriveY, ox+615, oy+89, ox+615, oy+89, 0xe78d7b
if ErrorLevel = 0
Goto, ContinueBankArrive
else
Sleep, 100
}

;if after 500 loops you haven't arrived at bank chest, try again since you may have a level up message pending in the chat menu
Sleep, 100
MouseMove, BankfromDispenserX+1, BankfromDispenserY-6, 0 ;bank location on minimap from dispenser
Sleep, 100
Click
Sleep, 50
Click
Sleep, 1000

Loop, 500
{
PixelSearch, BankArriveX, BankArriveY, ox+615, oy+89, ox+615, oy+89, 0xe78d7b
if ErrorLevel = 0
Goto, ContinueBankArrive
else
Sleep, 100
}
MsgBox, error with BankArrive loop
ExitApp
ContinueBankArrive:
}
;end of main loop




;beginning of subroutines
Deposit/WithdrawalCoffer:
{
MouseMove, ox+200, oy+170, 0 ;coffer location from bank
Sleep, 200
Click
Sleep, 3
Click
Sleep, 1000

;wait for coffer prompt chat menu to appear
Loop, 200
{
PixelSearch, CofferPromptX, CofferPromptY, ox+106, oy+368, ox+106, oy+368, 0x9c9f3f
if ErrorLevel = 0
Goto, ContinueCofferPrompt
else
Sleep, 100
}
MsgBox, error with CofferPrompt loop
ExitApp 
ContinueCofferPrompt:

Sleep, 200
SendInput, {1}
Sleep, 600

;wait for coffer prompt2 chat menu to appear
Loop, 100
{
PixelSearch, CofferPrompt2X, CofferPrompt2Y, ox+259, oy+427, ox+259, oy+427, 0x800000
if ErrorLevel = 0
Goto, ContinueCofferPrompt2
else
Sleep, 100
}
MsgBox, error with CofferPrompt2 loop
ExitApp
ContinueCofferPrompt2:

Sleep, 200
SendInput, {Raw}999999999 
Sleep, 600
SendInput, {Enter}
Sleep, 600

;wait for coffer confirm chat menu to appear
Loop, 100
{
PixelSearch, CofferConfirmX, CofferConfirmY, ox+66, oy+428, ox+66, oy+428, 0x48d1fb
if ErrorLevel = 0
Goto, ContinueCofferConfirm
else
Sleep, 100
}
MsgBox, error with CofferPrompt2 loop
ExitApp
ContinueCofferConfirm:

SendInput, {Space}
Sleep, 1200
MouseMove, ox+646, oy+85, 0 ;bank location on minimap from coffer
Sleep, 100
Click
Sleep, 3
Click
Sleep, 1000
Return
}












































































/*
;drink stamina potion if potion effect isn't active
PixelSearch, StaminaActiveX, StaminaActiveY, ox+584, oy+140, ox+584, oy+140, 0x3d73e4
if ErrorLevel
{
MouseMove, ox+661, oy+447, 0 ;second-to-last inventory position
Sleep, 100
Click
Sleep, 3
Click

;check if potion effect has been activated, if not, get another potion because the current vial has been depleted
Sleep, 1000
PixelSearch, RunSX, RunSY, 605, 171, 605, 171, 0x3d73e4
if ErrorLevel
{

;open bank chest in front of you
Sleep, 200
MouseMove, ox+297, oy+229, 0 ;open bank from starting position
Sleep, 100
Click
Sleep, 1
Click

;wait for bank screen to appear
Loop, 25
{
PixelSearch, BankWindowX, BankWindowY, ox+362, oy+318, ox+362, oy+318, 0x3095DF
if ErrorLevel
{
Click
Sleep, 600
}
else
Goto, Continue2
}
ExitApp
Continue2:

;deposit inventory
MouseMove, ox+444, oy+314, 0 ;deposit inventory button in bank window
Sleep, 100
Click
Sleep, 3
Click
Sleep, 600

;wait for inventory to be deposited
Loop, 25
{
PixelSearch, InvSlot1EmptyX,InvSlot1EmptyY, ox+579, oy+225, ox+579, oy+225, 0x354049
if ErrorLevel
{
Click
Sleep, 600
}
else
Goto, Continue4
}
ExitApp
Continue4:

;look for ore(s) and stamina potions if any, if not present, withdrawal all money from coffer and terminate
PixelSearch, MainOreX, MainOreY, ox+80, oy+100, ox+80, oy+100, 0x48667f
if ErrorLevel
Goto, WithdrawalCoffer

PixelSearch, CoalX, CoalY, ox+140, oy+100, ox+140, oy+100, 0x263739
if ErrorLevel
Goto, WithdrawalCoffer

PixelSearch, PotionX, PotionY, ox+181, oy+96, ox+181, oy+96, 0x4c7fa6
if ErrorLevel
Goto, WithdrawalCoffer

;withdrawal ore(s) and stamina potion if present
Sleep, 10
MouseMove, ox+89, oy+96, 0 ;main ore location in bank
Sleep, 50
Click, right
Sleep, 50
MouseMove, ox+89, oy+170, 0 ;main ore right click withdrawal saved X location in bank
Sleep, 50
Click
Sleep, 50
MouseMove, ox+140, oy+96, 0 ;coal ore location in bank
Sleep, 50
Click, right
Sleep, 50
MouseMove, ox+140, oy+166, 0 ;coal ore right click withdrawal saved X location in bank
Sleep, 50
Click
Sleep, 50
MouseMove, ox+185, oy+100, 0 ;stamina potions location in bank
Sleep, 50
Click
Sleep, 50
Goto, GoingtoBelt
}}


*/
;wait for ore to withdrawal
; Sleep, 600
; Loop, 25
; {
; PixelSearch, OreGetX, OreGetY, 635, 261, 635, 261, 0x425D74

;if ore takes too long to appear in inventory, try withdrawaling it again
; if ErrorLevel
; {
; Sleep, 100
; Click, right, 112, 130
; Sleep, 100
; Click, 101, 227
; Sleep, 100
; Continue
; }
; else
; {
; Click, 511, 54
; Sleep, 1000
; Click, 683, 479
; Sleep, 2
; Click, 683, 479
; Sleep, 1000
; Goto, GoingtoBelt
; }}}}





^q::ExitApp






