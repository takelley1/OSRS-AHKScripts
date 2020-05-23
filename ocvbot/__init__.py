import logging as log
import os
import sys

import pyautogui as pag

"""
Creates objects containing useful game coordinates for other
functions to serach through.
"""

sys.setrecursionlimit(9999)

# These are constants.
# See ./tests/haystacks/client_anatomy.png for more info.
# Width and height of the entire game client.
CLIENT_WIDTH = 765
CLIENT_HEIGHT = 503

# Width and height of the inventory screen, in pixels.
INV_WIDTH = 186
INV_HEIGHT = 262

# Width and height of just the game screen in the game client.
GAME_SCREEN_WIDTH = 512
GAME_SCREEN_HEIGHT = 334

CHAT_MENU_WIDTH = 506
CHAT_MENU_HEIGHT = 129

# Dimensions of the most recent "line" in the chat history.
CHAT_MENU_RECENT_WIDTH = 489
CHAT_MENU_RECENT_HEIGHT = 14

# Get the display size in pixels.
DISPLAY_WIDTH = pag.size().width
DISPLAY_HEIGHT = pag.size().height

log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s'
                , level='DEBUG')

# TODO: Find a better way to do this.
# Clean up left over screenshots from failed runs.
#sub.Popen(["rm", "./.screenshot2*"])

os.chdir('/home/austin/OSRS-AHKScripts/ocvbot')
