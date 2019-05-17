# OldSchoolRunescape AutoHotkey Scripts

Active development has ceased on this repo, though it may resume in the future when I have more free time. 

This repo contains scripts for cannonball smelting, magic splashing, mining, spinning flax, running the Blast Furnace, and runecrafting. Not all scripts are fully functional.

  The script with the most work and testing done is the CannonballSmelting.ahk script at the root of the directory tree. The script will run indefinitely without issues (I've tested it for 8+ hours at a time). All interactions with the OSRS client are randomized in both time and location. Please read the comments at the top of each script file for information on how to properly configure your client. More detailed information and referenced files for each script are in their corresponding directories. 

  AutoHotkey by itself is poor at image recognition, which is the primary reason I switched to Python 3 for my next bot project. As a result of this limitation, I was forced to use rigid single-pixel color-matching rather than loose image-matching with tolerances. For the cannonball smelting script, a single image (the four-pointed-star prayer icon) is used to locate the OSRS client and create a coordinate plane based on its location on your desktop. Beyond that, everything else is based on pixel color matching, usually on certain icons within the minimap for navigation or certain pieces of text in menus for interacting with items and buttons.
  
  Because of these limitations, the bot may have difficulty locating and/or orienting itself on your particular setup. Unfortunately I cannot say with confidence that these scripts are friendly towards casual players with no scripting experience. A basic knowledge of AutoHotkey will be necessary to modify the pixel locations and color tolerances to adapt the script to your particular monitor and/or desktop's color properties.  
