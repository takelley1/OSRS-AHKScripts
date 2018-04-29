#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;begin at edgeville bank in second-closest booth to furnace, with rune pouch in inventory and rune essence first slot in bank

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

;orient client by searching whole screen for prayer hud icon
ImageSearch, OrientX, OrientY, 0, 0, A_Screenwidth, A_Screenheight, Orient1.png
if ErrorLevel = 0
{
Sleep, 50
MouseMove, OrientX, OrientY
Sleep, 50
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



Loop ;begin main loop
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





MouseMove, ox+714, oy+48, 0 ;click on first checkpoint
Sleep, 10
Click
Sleep, 8500

Loop, 500 ;look for first checkpoint
{
PixelSearch, checkpoint1X, checkpoint1Y, ox+222, oy+145, ox+222, oy+145, 0x355873
if ErrorLevel = 0
Goto, checkpoint1
else
Sleep, 100
}
MsgBox, error with checkpoint1 loop
ExitApp
checkpoint1:

MouseMove, ox+698, oy+111, 0 ;click on second checkpoint
Sleep, 10
Click
Sleep, 17500


;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+588, oy+131, ox+588, oy+131, 0x596160 ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 10
Click
}

Loop, 500 ;look for second checkpoint
{
PixelSearch, checkpoint2X, checkpoint2Y, ox+333, oy+99, ox+333, oy+99, 0x30516a
if ErrorLevel = 0
Goto, checkpoint2
else
Sleep, 100
}
MsgBox, error with checkpoint2 loop
ExitApp
checkpoint2:

MouseMove, ox+285, oy+203, 0 ;click on third checkpoint (right click fairy ring)
Sleep, 10
Click, right
Sleep, 10
MouseMove, ox+285, oy+245, 0 ;click on third checkpoint (click fairy ring)
Sleep, 10
Click
Sleep, 3000
MouseMove, ox+594, oy+305, 0 ;click on third checkpoint (destination fairy ring)
Sleep, 10
Click, 3
Sleep, 3000
MouseMove, ox+258, oy+288, 0 ;click on third checkpoint (travel fairy ring)
Sleep, 10
Click, 3
Sleep, 6000

Loop, 10 ;look for third checkpoint
{
PixelSearch, checkpoint3X, checkpoint3Y, ox+251, oy+250, ox+251, oy+250, 0x4ca381
if ErrorLevel = 0
Goto, checkpoint3
else
Sleep, 100
}
MsgBox, error with checkpoint3 loop
ExitApp
checkpoint3:

MouseMove, ox+640, oy+64, 0 ;click on fourth checkpoint
Sleep, 10
Click
Sleep, 15000

Loop, 500 ;look for fourth checkpoint
{
PixelSearch, checkpoint4X, checkpoint4Y, ox+84, oy+115, ox+84, oy+115, 0x457b96
if ErrorLevel = 0
Goto, checkpoint4
else
Sleep, 100
}
MsgBox, error with checkpoint4 loop
ExitApp
checkpoint4:

MouseMove, ox+713, oy+82, 0 ;click on fifth checkpoint
Sleep, 50
Click, 3
Sleep, 8000

Loop, 500 ;look for fifth checkpoint
{
PixelSearch, checkpoint5tX, checkpoint5Y, ox+298, oy+261, ox+298, oy+261, 0x2e4654
if ErrorLevel = 0
Goto, checkpoint5
else
Sleep, 100
}
MsgBox, error with checkpoint5 loop
ExitApp
checkpoint5:

MouseMove, ox+712, oy+85, 0 ;click on sixth checkpoint
Sleep, 50
Click, 3
Sleep, 8000

Loop, 500 ;look for sixth checkpoint
{
PixelSearch, checkpoint6X, checkpoint6Y, ox+340, oy+258, ox+340, oy+258, 0x699cb9
if ErrorLevel = 0
Goto, checkpoint6
else
Sleep, 100
}
MsgBox, error with checkpoint6 loop
ExitApp
checkpoint6:

MouseMove, ox+711, oy+90, 0 ;click on seventh checkpoint
Sleep, 50
Click, 3
Sleep, 8000

Loop, 500 ;look for seventh checkpoint
{
PixelSearch, checkpoint7X, checkpoint7Y, ox+394, oy+134, ox+394, oy+134, 0x3c6b83
if ErrorLevel = 0
Goto, checkpoint7
else
Sleep, 100
}
MsgBox, error with checkpoint7 loop
ExitApp
checkpoint7:

MouseMove, ox+712, oy+58, 0 ;click on eighth checkpoint
Sleep, 50
Click, 3
Sleep, 8000

Loop, 500 ;look for eighth checkpoint
{
PixelSearch, checkpoint8tX, checkpoint8Y, ox+278, oy+106, ox+278, oy+106, 0x626d75
if ErrorLevel = 0
Goto, checkpoint8
else
Sleep, 100
}
MsgBox, error with checkpoint8 loop
ExitApp
checkpoint8:

MouseMove, ox+188, oy+89, 0 ;click to enter ruins (checkpoint 9)
Sleep, 50
Click, 3
Sleep, 5000

Loop, 500 ;look for ninth checkpoint
{
PixelSearch, checkpoint9tX, checkpoint9Y, ox+310, oy+170, ox+310, oy+170, 0x1de3f3
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

MouseMove, ox+257, oy+60, 0 ;click to craft runes (checkpoint 10)
Sleep, 50
Click, 3
Sleep, 6500

Loop, 500 ;look for tenth checkpoint
{
PixelSearch, checkpoint10X, checkpoint10Y, ox+316, oy+287, ox+316, oy+287, 0x1de5f6
if ErrorLevel = 0
Goto, checkpoint10
else
Sleep, 100
}
MsgBox, error with checkpoint10 loop
ExitApp
checkpoint10:

MouseMove, ox+577, oy+233, 0 ;empty pouch
Sleep, 100
Click, right
MouseMove, ox+530, oy+273, 0
Sleep, 100
Click
MouseMove, ox+577, oy+233, 0 ;empty pouch
Sleep, 100
Click, right
MouseMove, ox+530, oy+273, 0
Sleep, 100
Click

MouseMove, ox+260, oy+146, 0 ;click to craft runes from pouch
Sleep, 50
Click, 3
Sleep, 10
Click, 3
Sleep, 3900

MouseMove, ox+259, oy+323, 0 ;click to exit portal (eleventh checkpoint)
Sleep, 50
Click, 3
Sleep, 6500


Loop, 500 ;look for eleventh checkpoint
{
PixelSearch, checkpoint11X, checkpoint11Y, ox+255, oy+208, ox+255, oy+208, 0x252a2e
if ErrorLevel = 0
Goto, checkpoint11
else
Sleep, 100
}
MsgBox, error with checkpoint11 loop
ExitApp
checkpoint11:

MouseMove, ox+617, oy+140, 0 ;click on twelfth checkpoint
Sleep, 50
Click, 3
Sleep, 8500


Loop, 500 ;look for twelfth checkpoint
{
PixelSearch, checkpoint12X, checkpoint12Y, ox+174, oy+132, ox+174, oy+132, 0x376176
if ErrorLevel = 0
Goto, checkpoint12
else
Sleep, 100
}
MsgBox, error with checkpoint12 loop
ExitApp
checkpoint12:

MouseMove, ox+572, oy+88, 0 ;click on thirteenth checkpoint
Sleep, 50
Click, 3
Sleep, 8500


Loop, 500 ;look for thirteenth checkpoint
{
PixelSearch, checkpoint13X, checkpoint13Y, ox+296, oy+91, ox+296, oy+91, 0x39667d
if ErrorLevel = 0
Goto, checkpoint13
else
Sleep, 100
}
MsgBox, error with checkpoint14 loop
ExitApp
checkpoint13:

MouseMove, ox+570, oy+68, 0 ;click on fourteenth checkpoint
Sleep, 50
Click, 3
Sleep, 8500

Loop, 500 ;look for fourteenth checkpoint
{
PixelSearch, checkpoint14X, checkpoint14Y, ox+195, oy+115, ox+195, oy+115, 0x3f7088
if ErrorLevel = 0
Goto, checkpoint14
else
Sleep, 100
}
MsgBox, error with checkpoint14 loop
ExitApp
checkpoint14:

MouseMove, ox+574, oy+97, 0 ;click on fifteenth checkpoint
Sleep, 10
Click
Sleep, 8500

Loop, 500 ;look for fifteenth checkpoint
{
PixelSearch, checkpoint15X, checkpoint15Y, ox+115, oy+288, ox+115, oy+288, 0x22323c
if ErrorLevel = 0
Goto, checkpoint15
else
Sleep, 100
}
MsgBox, error with checkpoint15 loop
ExitApp
checkpoint15:

MouseMove, ox+604, oy+104, 0 ;click on sixteenth checkpoint
Sleep, 10
Click
Sleep, 8500

;check run energy. if above about 90, turn on run
PixelSearch, RunX, RunY, ox+588, oy+131, ox+588, oy+131, 0x596160 ;run 90% energy
if ErrorLevel = 0
{
MouseMove, RunX, RunY, 0
Sleep, 10
Click
}

Loop, 500 ;look for sixteenth checkpoint
{
PixelSearch, checkpoint16X, checkpoint16Y, ox+308, oy+197, ox+308, oy+197, 0x6293ae
if ErrorLevel = 0
Goto, checkpoint16
else
Sleep, 100
}
MsgBox, error with checkpoint16 loop
ExitApp
checkpoint16:

MouseMove, ox+375, oy+198, 0 ;click on seventeenth checkpoint (right click fairy ring)
Sleep, 100
Click, right
Sleep, 100
MouseMove, ox+375, oy+236, 0 ;click on seventeenth checkpoint (click fairy ring)
Sleep, 100
Click
Sleep, 8000
MouseMove, ox+594, oy+267, 0 ;click on seventeenth checkpoint (destination fairy ring)
Sleep, 10
Click, 3
Sleep, 6000
MouseMove, ox+258, oy+288, 0 ;click on seventeenth checkpoint (travel fairy ring)
Sleep, 10
Click, 3
Sleep, 7000

Loop, 500 ;look for seventeenth checkpoint
{
PixelSearch, checkpoint17X, checkpoint17Y, ox+57, oy+249, ox+57, oy+249, 0x1a2432
if ErrorLevel = 0
Goto, checkpoint17
else
Sleep, 100
}
MsgBox, error with checkpoint17 loop
ExitApp
checkpoint17:

MouseMove, ox+572, oy+89, 0 ;click on eighteenth checkpoint
Sleep, 10
Click
Sleep, 18500

Loop, 500 ;look for eighteenth checkpoint
{
PixelSearch, checkpoint18X, checkpoint18Y, ox+22, oy+241, ox+22, oy+241, 0x203a48
if ErrorLevel = 0
Goto, checkpoint18
else
Sleep, 100
}
MsgBox, error with checkpoint18 loop
ExitApp
checkpoint18:

MouseMove, ox+578, oy+89, 0 ;click on nineteenth (final) checkpoint
Sleep, 10
Click
Sleep, 12000
continue
}


^q::ExitApp




