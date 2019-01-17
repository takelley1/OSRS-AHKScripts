# AHK OSRS GitHub

Active development has ceased on this repo, though it may resume in the future when I have more free time. 

The script with the most work and testing done is the CannonballSmelting.ahk script at the root directory.
More detailed information and referenced files for each script are in their corresponding directories.

  AHK is poor at image recognition, which is the primary reason I switched to python for my EVE Online bot. As a result, I was forced to use single-pixel color-matching. For the CannonballSmelting script, a single image (the four-pointed-star prayer icon) is used to locate the OSRS client and create a coordinate plane based on its location on your desktop. Beyond that, everything is highly-restrictive single-pixel color-matching, usually on certain icons in the minimap for navigation or certain pieces of text in menus or the HUD for interacting with items or buttons.
  As a result, the bot may have difficulty locating your client and/or orienting itself. These scripts are not for casual players with no technical experience. Some tweaking with the color tolerances and locations may be necessary to adapt the script to your particular setup.  
