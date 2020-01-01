;BlastFurnaceTextDoc

;designed for 1600x900 screen inside windowed VM with official runescape client "snapped" to left half
;of screen

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
if ErrorLevel
{
MsgBox, Can’t find client!
ExitApp
}
else
{
Sleep, 100
MouseMove, OrientX, OrientY
Sleep, 100
;move mouse to top left pixel of client to create new origin point for coordinate system
MouseMove, -696, -171, 0, R ; 0, 0 coordinates from prayer icon
Sleep, 600
MouseGetPos, ox, oy
}

;click compass to orient client North
Sleep, 100
MouseMove, ox+562, oy+20, 0 ;compass
Sleep, 100
Click
Sleep, 5
Click
Sleep, 5
Send {Up down}
Sleep, 750 
Send {Up up}

;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+590, oy+138, ox+590, oy+138, 0x01a8ce ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 100
Click, RunX, RunY
}

;begin main repeating routine
Loop
{

;check run energy again, if below a certain amount, withdrawal money from coffer and wait till energy has restored itself, then deposit money back into coffer
PixelSearch, RunOutX, RunOutY, ox+576, oy+133, ox+576, oy+133, 0x0B0B0B ;run 10% energy
if ErrorLevel = 0
{

;deposit inventory to allow room for coin stack
MouseMove, ox+297, oy+229, 0 ;open bank from starting position
Sleep, 100
Click
Sleep, 3
Click
Sleep, 600

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
Goto, Continue1
}
ExitApp
Continue1:

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
Goto, Continue2
}
ExitApp
Continue2:
Sleep, 100
MouseMove, ox+487, oy+23, 0 ;bank window close
Click
Sleep, 1
Click

;withdrawal from coffer and return to start position
MouseMove, ox+205, oy+170, 0 ;coffer location from bank
Sleep, 100
Click
Sleep, 3
Click
Sleep, 3000
SendInput, {1}
Sleep, 1000
SendInput, {Raw}999999999 
Sleep, 1000
SendInput, {Enter}
Sleep, 1000
SendInput, {Space}
Sleep, 1000
MouseMove, ox+285, oy+192, 0 ;bank location from coffer
Sleep, 100
Click
Sleep, 3000
MouseMove, ox+487, oy+23, 0 ;bank window close
Sleep, 100
Click

;keep checking every five seconds until run energy full
Loop, 1800000
{
Sleep, 5000

;click on compass to prevent client timeout
MouseMove, ox+562, oy+20, 0 ;compass
Sleep, 100
Click
PixelSearch, RunX, RunY, ox+590, oy+138, ox+590, oy+138, 0x01a8ce ;run 90% energy
if ErrorLevel = 0
{

;if full, return money to coffer
MouseMove, ox+205, oy+170, 0 ;coffer location from bank
Sleep, 100
Click
Sleep, 3
Click
Sleep, 3000
SendInput, {1}
Sleep, 1000
SendInput, {Raw}999999999 
Sleep, 1000
SendInput, {Enter}
Sleep, 1000
SendInput, {Space}
Sleep, 1000
MouseMove, ox+285, oy+192, 0 ;bank location from coffer
Sleep, 100
Click
Sleep, 3000
MouseMove, ox+487, oy+23, 0 ;bank window close
Sleep, 100
Click
Goto, Start
}
else
ExitApp
}}

Start:
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
Goto, Continue3
}
ExitApp
Continue3:

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

PixelSearch, PotionX, PotionY, ox+181, oy+96, ox+181, oy+96 0x4c7fa6
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

;the following is the banking procedure when a new stamina potion is NOT required

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
Goto, Continue3
}
ExitApp
Continue3:

;deposit held bars
MouseMove, ox+665, oy+227, 0 ;right click third stack of items in inventory
Sleep, 500
Click, right
Sleep, 500
MouseMove, ox+656, oy+328, 0 ;select "all" on drop down third stack of items in inventory
Sleep, 500
Click
Sleep, 500

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
Goto, Continue5
}
ExitApp
Continue5:

;look for ore, if not present, withdrawal all money from coffer and terminate
PixelSearch, MainOreX, MainOreY, ox+80, oy+100, ox+80, oy+100, 0x48667f
if ErrorLevel
Goto, WithdrawalCoffer

PixelSearch, CoalX, CoalY, ox+140, oy+100, ox+140, oy+100, 0x263739
if ErrorLevel
Goto, WithdrawalCoffer

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
Sleep, 500
Click
Sleep, 1
Click
Sleep, 3000

;Keep checking water icon on minimap until you've arrived at belt
Loop, 400
{
PixelSearch, BeltArriveX, BeltArriveY, ox+639, oy+128, ox+639, oy+128, 0xE78d7b
if ErrorLevel = 0
Goto, Continue6
else
Sleep, 50
}
ExitApp
Continue6:

;deposit ore onto belt
Sleep, 100
MouseMove, ox+288, oy+174, 0 ;deposit ore onto belt location
Sleep, 500
Click
Sleep, 1
Click
Sleep, 1
Click
Sleep, 500

;move to and open bar dispenser
MouseMove, ox+213, oy+295, 0 ;dispenser location from belt
Sleep, 500
Click
Sleep, 1
Click
Sleep, 1
Click
Sleep, 2500

;wait for character to stop moving
Loop, 800
{
PixelSearch, DispenserArriveX, DispenserArriveY, ox+673, oy+106, ox+673, oy+106, 0x42a0b3
if ErrorLevel = 0
Goto, Continue7
Else
Sleep, 50
}
ExitApp
Continue7:

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

;wait 1 tick, then close window
Sleep, 600
MouseMove, ox+487, oy+42, 0 ;dispenser window close
Sleep, 500
Click
Sleep, 500

;keep clicking on dispenser until dispenser window reopens, then recheck bars
Loop, 1000
{
PixelSearch, DispenserWindowX, DispenserWindowY, ox+332, oy+35, ox+332, oy+35, 0x1F98FF
if ErrorLevel = 0
Goto, CheckBars
else
MouseMove, ox+263, oy+183, 0 ;at dispenser, open dispenser 
Sleep, 50
Click
Sleep, 50
}
ExitApp
}
ExitApp
}

;withdrawal bars, keep clicking until in inventory
WithdrawalBars:
Loop, 25
{
PixelSearch, BarsGetX, BarsGetY, ox+710, oy+225, ox+710, oy+225, 0x868690
if ErrorLevel = 0
Goto, Continue8
else
{
MouseMove, ox+229, oy+143, 0 ;location to withdrawal steel bars at dispenser
Click
Sleep, 100
}}
ExitApp
Continue8:

;click on minimap to return to bank
MouseMove, ox+674, oy+108, 0 ;bank location on minimap from dispenser
Sleep, 100
Click
Sleep, 1
Click
Sleep, 2000

;Keep checking water icon on minimap until you've returned to bank chest
Loop, 500
{
PixelSearch, BankArriveX, BankArriveY, ox+618, oy+83, ox+618, oy+83, 0xe78d7b
if ErrorLevel = 0
Goto, Continue9
else
Sleep, 50
}
ExitApp
Continue9
}


WithdrawalCoffer:
MouseMove, ox+205, oy+170, 0 ;coffer location from bank
Sleep, 100
Click
Sleep, 3
Click
Sleep, 3000
SendInput, {1}
Sleep, 1000
SendInput, {Raw}999999999 
Sleep, 1000
SendInput, {Enter}
Sleep, 1000
SendInput, {Space}
Sleep, 1000
MouseMove, ox+285, oy+192, 0 ;bank location from coffer
Sleep, 100
Click
Sleep, 3000
MouseMove, ox+487, oy+23, 0 ;bank window close
Sleep, 100
Click
ExitApp


^q::ExitApp






