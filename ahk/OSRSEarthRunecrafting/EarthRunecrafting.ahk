#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;begin at varrock east bank in third-to-last booth from the left, with rune pouch in inventory and rune essence first slot in bank
;client must be oriented north (click compass) and camera must be tilted all the way upwards (hold arrow key)
;client must also be fully zoomed out and brightness set at default



CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent


;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
if ErrorLevel = 0
{
Sleep, wait100to500milis
Gosub, GetRandoms
MouseMove, OrientX, OrientY
Sleep, wait100to500milis
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
Sleep, 50
Click, 2
Sleep, 5
Send {Up down}
Sleep, 750 
Send {Up up}
Sleep, 100

;configure client zoom settings to be fully zoomed out
MouseMove, ox+675, oy+484, 0 ;options screen location
Sleep, 100
Click, 2
Sleep, 100
MouseMove, ox+675, oy+274, 0 ;options screen zoom bar location
Sleep, 100
Click
Sleep, 100
MouseClickDrag, L, ox+675, oy+274,  ox+515, oy+274, 0
Sleep, 100
MouseMove, ox+642, oy+185, 0 ;inventory bag icon
Sleep, 100
Click, 2
Sleep, 100

;Loop ;begin main loop
{

;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+588, oy+131, ox+588, oy+131, 0x596160 ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 10
Click
}

MouseMove, ox+260, oy+191, 0 ;open bank from starting position
Sleep, 10
Click, 2
Loop, 250 ;wait for bank screen to appear
{
PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
if ErrorLevel = 0
Goto, ContinueBankWindow
else
{
Click
Sleep, 50
Click, 2
Sleep, 1000
Continue
}}
MsgBox, error with BankWindow loop
ExitApp
ContinueBankWindow:

;deposit runes
MouseMove, ox+621, oy+228, 0 ;right click second stack of items in inventory
Sleep, 10
Click, right
Sleep, 10
MouseMove, ox+621, oy+328, 0 ;select "all" on drop down second stack of items in inventory
Sleep, 10
Click, 2
Sleep, 10

Loop, 50 ;wait for inventory to be deposited
{
PixelSearch, InvSlot2EmptyX,InvSlot2EmptyY, ox+620, oy+220, ox+620, oy+230, 0x354049
if ErrorLevel = 0
Goto, ContinueInvSlot2Empty
else
{
MouseMove, ox+620, oy+228, 0 ;right click second stack of items in inventory
Sleep, 10
Click, right
Sleep, 10
MouseMove, ox+620, oy+328, 0 ;select "all" on drop down second stack of items in inventory
Sleep, 10
Click
Sleep, 10
}}
MsgBox, error with InvSlot2Empty loop
ContinueInvSlot2Empty:


Loop, 10 ;look for regular rune essence
{
PixelSearch, regx, regy, ox+101, oy+95, ox+101, oy+95, 0x83838d
if ErrorLevel = 0
Goto, runeswithdrawal
else
Sleep, 100
}

Loop, 100 ;look for pure rune essence
{
PixelSearch, purex, purey, ox+101, oy+95, ox+101, oy+95, 0xbabbc3
if ErrorLevel = 0
Goto, runeswithdrawal
else
Sleep, 100
}
MsgBox, out of runes
ExitApp
runeswithdrawal:

;withdrawal essence
MouseMove, ox+89, oy+96, 0 ;first bank slot
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+89, oy+195, 0 ;right click withdrawal all location in bank
Sleep, 100
Click
Sleep, 100

Loop, 10 ;check if essence are in inventory
{
PixelSearch, invessX, invessY, ox+575, oy+251, ox+575, oy+251, 0x010000
if ErrorLevel = 0
Goto, invess
else
MouseMove, ox+89, oy+96, 0 ;first bank slot
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+89, oy+195, 0 ;right click withdrawal all location in bank
Sleep, 100
Click
Sleep, 100
}
MsgBox, error with invess loop
ExitApp
invess:

MouseMove, ox+486, oy+23, 0 ;close bank window
Sleep, 10
Click
Sleep, 500

MouseMove, ox+577, oy+233, 0 ;fill pouch
Sleep, 10
Click, 5
Sleep, 500

MouseMove, ox+260, oy+191, 0 ;open bank from starting position
Sleep, 10
Click, 2
Loop, 250 ;wait for bank screen to appear
{
PixelSearch, BankWindow2X, BankWindow2Y, ox+360, oy+315, ox+360, oy+315, 0x42b2f4
if ErrorLevel = 0
Goto, ContinueBankWindow2
else
{
Click
Sleep, 50
Click, 2
Sleep, 1000
Continue
}}
MsgBox, error with BankWindow2 loop
ExitApp
ContinueBankWindow2:

Loop, 2 ;look for regular rune essence
{
PixelSearch, reg2x, reg2y, ox+101, oy+95, ox+101, oy+95, 0x83838d
if ErrorLevel = 0
Goto, runeswithdrawal2
else
Sleep, 1
}

Loop, 100 ;look for pure rune essence
{
PixelSearch, pure2x, pure2y, ox+101, oy+95, ox+101, oy+95, 0xbabbc3
if ErrorLevel = 0
Goto, runeswithdrawal2
else
Sleep, 100
}
MsgBox, out of runes
ExitApp
runeswithdrawal2:

;withdrawal essence
MouseMove, ox+89, oy+96, 0 ;first bank slot
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+89, oy+195, 0 ;right click withdrawal all location in bank
Sleep, 100
Click
Sleep, 100

Loop, 10 ;check if essence are in inventory
{
PixelSearch, invess2X, invess2Y, ox+617, oy+215, ox+617, oy+215, 0x010000
if ErrorLevel = 0
Goto, invess2
else
MouseMove, ox+89, oy+96, 0 ;first bank slot
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+89, oy+195, 0 ;right click withdrawal all location in bank
Sleep, 100
Click
Sleep, 100
}
MsgBox, error with invess loop
ExitApp
invess2:

MouseMove, ox+705, oy+48, 0 ;click on first checkpoint
Sleep, 10
Click
Sleep, 8500

Loop, 100 ;look for first checkpoint
{
PixelSearch, checkpoint1X, checkpoint1Y, ox+355, oy+259, ox+355, oy+259, 0x111115
if ErrorLevel = 0
Goto, checkpoint1
else
Sleep, 100
}
MsgBox, error with checkpoint1 loop
ExitApp
checkpoint1:

MouseMove, ox+705, oy+48, 0 ;click on second checkpoint
Sleep, 10
Click
Sleep, 8500

Loop, 100 ;look for second checkpoint
{
PixelSearch, checkpoint2X, checkpoint2Y, ox+87, oy+141, ox+87, oy+141, 0xa7a8b2
if ErrorLevel = 0
Goto, checkpoint2
else
Sleep, 100
}
MsgBox, error with checkpoint2 loop
ExitApp
checkpoint2:

MouseMove, ox+673, oy+19, 0 ;click on third checkpoint
Sleep, 10
Click
Sleep, 8500

Loop, 100 ;look for third checkpoint
{
PixelSearch, checkpoint3X, checkpoint3Y, ox+470, oy+200, ox+470, oy+200, 0x355873
if ErrorLevel = 0
Goto, checkpoint3
else
Sleep, 100
}
MsgBox, error with checkpoint3 loop
ExitApp
checkpoint3:

MouseMove, ox+676, oy+18, 0 ;click on fourth checkpoint
Sleep, 10
Click
Sleep, 8000

Loop, 100 ;look for fourth checkpoint
{
PixelSearch, checkpoint4X, checkpoint4Y, ox+220, oy+168, ox+220, oy+168, 0x355873
if ErrorLevel = 0
Goto, checkpoint4
else
Sleep, 100
}
MsgBox, error with checkpoint4 loop
ExitApp
checkpoint4:

MouseMove, ox+328, oy+80, 0 ;click to enter ruins (checkpoint5)
Sleep, 50
Click, 3
Sleep, 2000

Loop, 100 ;look for fifth checkpoint
{
PixelSearch, checkpoint5tX, checkpoint5Y, ox+399, oy+303, ox+399, oy+303, 0x3f7688
if ErrorLevel = 0
Goto, checkpoint5
else
Sleep, 100
}
MsgBox, error with checkpoint5 loop
ExitApp
checkpoint5:

MouseMove, ox+643, oy+62, 0 ;click to approach altar (checkpoint6)
Sleep, 50
Click, 3
Sleep, 5000

Loop, 100 ;look for sixth checkpoint
{
PixelSearch, checkpoint6X, checkpoint6Y, ox+305, oy+158, ox+305, oy+158, 0x6f7376
if ErrorLevel = 0
Goto, checkpoint6
else
Sleep, 100
}
MsgBox, error with checkpoint6 loop
ExitApp
checkpoint6:

MouseMove, ox+283, oy+74, 0 ;click to craft runes (checkpoint 7)
Sleep, 50
Click, 3
Sleep, 6000


Loop, 100 ;look for seventh checkpoint
{
PixelSearch, checkpoint7X, checkpoint7Y, ox+250, oy+191, ox+250, oy+191, 0x5b6168
if ErrorLevel = 0
Goto, checkpoint7
else
Sleep, 100
}
MsgBox, error with checkpoint7 loop
ExitApp
checkpoint7:

MouseMove, ox+577, oy+233, 0 ;empty pouch
Sleep, 10
Click, right
MouseMove, ox+530, oy+273, 0
Sleep, 10
Click
MouseMove, ox+577, oy+233, 0 ;empty pouch
Sleep, 10
Click, right
MouseMove, ox+530, oy+273, 0
Sleep, 10
Click

MouseMove, ox+290, oy+125, 0 ;click to craft runes from pouch
Sleep, 50
Click, 3
Sleep, 6000


MouseMove, ox+642, oy+120, 0 ;click to approach portal (checkpoint 8)
Sleep, 50
Click, 3
Sleep, 100
Click, 5
Sleep, 5000

Loop, 100 ;look for eighth checkpoint
{
PixelSearch, checkpoint8tX, checkpoint8Y, ox+396, oy+307, ox+396, oy+307, 0x3f7688
if ErrorLevel = 0
Goto, checkpoint8
else
Sleep, 100
}
MsgBox, error with checkpoint8 loop
ExitApp
checkpoint8:

MouseMove, ox+199, oy+207, 0 ;click to enter portal (checkpoint 9)
Sleep, 50
Click, 3
Sleep, 5000

Loop, 100 ;look for ninth checkpoint
{
PixelSearch, checkpoint9tX, checkpoint9Y, ox+139, oy+140, ox+139, oy+140, 0x2c4960
if ErrorLevel = 0
Goto, checkpoint9
else
Sleep, 100
}
MsgBox, error with checkpoint9 loop
ExitApp
checkpoint9:

;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+588, oy+131, ox+588, oy+131, 0x596160 ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 10
Click
}

MouseMove, ox+626, oy+152, 0 ;click on tenth checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 100 ;look for tenth checkpoint
{
PixelSearch, checkpoint10X, checkpoint10Y, ox+340, oy+24, ox+340, oy+24, 0x3f6a88
if ErrorLevel = 0
Goto, checkpoint10
else
Sleep, 100
}
MsgBox, error with checkpoint10 loop
ExitApp
checkpoint10:

MouseMove, ox+626, oy+152, 0 ;click on eleventh checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 100 ;look for eleventh checkpoint
{
PixelSearch, checkpoint11X, checkpoint11Y, ox+380, oy+240, ox+380, oy+240, 0x355873
if ErrorLevel = 0
Goto, checkpoint11
else
Sleep, 100
}
MsgBox, error with checkpoint11 loop
ExitApp
checkpoint11:

MouseMove, ox+611, oy+135, 0 ;click on twelfth checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 100 ;look for twelfth checkpoint
{
PixelSearch, checkpoint12X, checkpoint12Y, ox+128, oy+96, ox+128, oy+96, 0x203748
if ErrorLevel = 0
Goto, checkpoint12
else
Sleep, 100
}
MsgBox, error with checkpoint12 loop
ExitApp
checkpoint12:

MouseMove, ox+572, oy+93, 0 ;click on thirteenth checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 100 ;look for thirteenth checkpoint
{
PixelSearch, checkpoint13X, checkpoint13Y, ox+471, oy+112, ox+471, oy+112, 0x395d7a
if ErrorLevel = 0
Goto, checkpoint13
else
Sleep, 100
}
MsgBox, error with checkpoint14 loop
ExitApp
checkpoint13:

MouseMove, ox+583, oy+117, 0 ;click on fourteenth (final) checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 100 ;look for fourteenth checkpoint (starting position)
{
PixelSearch, checkpoint14X, checkpoint14Y, ox+157, oy+215, ox+157, oy+215, 0x00001d
if ErrorLevel = 0
Goto, checkpoint14
else
Sleep, 100
}
MsgBox, error with checkpoint14 loop
ExitApp
checkpoint14:

}


^q::ExitApp




