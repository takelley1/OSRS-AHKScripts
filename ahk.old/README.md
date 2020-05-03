## OldSchoolRunescape AutoHotkey Scripts

**Active development has ceased on this repo, though it may resume in the future when I have more free time. PRs are welcome.** 

This repo contains scripts for cannonball smelting, magic splashing, mining, spinning flax, running the Blast Furnace, and runecrafting. Not all scripts are fully functional.

  The script with the most work and testing done is the `CannonballSmelting.ahk` script at the root of the directory tree. The script will run indefinitely without issues (I've tested it for 8+ hours at a time). Almost all interaction with the OSRS client is randomized to the greatest degree possible. Please read the comments at the top of each script file for information on how to properly configure your client. More detailed information and referenced files for each script are in their corresponding directories. 

  AutoHotkey by itself is poor at image recognition, which is the primary reason I switched to Python for my next bot. As a result of this limitation, I was forced to use single-pixel color-matching rather than more tolerant image-matching methods. For the cannonball smelting script, a single image (the four-pointed star prayer icon) is used to locate the OSRS client and create a coordinate plane based on its location on your desktop (see https://github.com/takelley1/OSRS-AHKScripts/issues for troubleshooting). Beyond that, everything else is based on single-pixel color-matching, usually on certain icons within the minimap for navigation or certain pieces of text in menus for interacting with items and buttons.
  
  Because of these limitations, the bot may have difficulty locating and/or orienting itself on your particular setup. Unfortunately I cannot say with confidence that these scripts are friendly towards casual players with no scripting experience. A basic knowledge of AutoHotkey will be necessary to modify the pixel locations and/or color tolerances to adapt the script to your particular monitor and/or desktop's color properties.
  
  
#### No client injection, no memory dumping, and no packet hacking. The bot interacts with the game the same way a human would: with the mouse and keyboard.
