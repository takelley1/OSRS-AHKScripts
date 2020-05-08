import logging as log
import sys
import pyautogui as pag
import random as rand
import logging
import random
import sys
import time
import traceback
import os
import time
from unittest import TestCase
from python.main import misc
from python.main import orient
from python.main import vision as vis

# This file is a full regression test of the bot that intends to test every
#   "main" behavior in sequence, as if the actual bot is being run.
# Images are presented in sequence to simluate the game client.
# Intended for Linux with the feh image viewer.


def test_cannonball_smelter():

    # Present the haystack image to the bot. -----------------------------------
    os.system('pkill feh')
    os.system('feh -dB black ./tests/haystacks/'
              'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
    time.sleep(.3)
    # --------------------------------------------------------------------------

    # Click on the bank booth.
    bank_booth = vis.Vision(needle='./bank_booth').click_image()
    if bank_booth == 1:
        #logout()
        raise RuntimeError('couldnt find bank booth')

    # If the function passes, remove the haystack and replace it with a new one.
    os.system('pkill -f "tests/haystacks/'
              'smithing-edgeville-cannonballs/edgeville-bank-booth.png" &')
    time.sleep(.3)
    os.system('feh -dB black ./tests/haystacks/'
              'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
    time.sleep(.3)
    # --------------------------------------------------------------------------

    # Wait for the bank window to appear.
    bank_window = vis.Vision(needle='./bank_window').wait_for_image()
    if bank_window == 1:
        #logout()
        raise RuntimeError ('timed out waiting for bank booth to open')

    # Withdrawl the steel bars.
    #   Right click icon of steel bars.
    right_click_steel = vis.Vision(needle='./steel_bar_in_bank'). \
        click_image(button='right')
    if right_click_steel == 1:
        sys.exit(1)

    #   Select withdrawl option in right-click menu.
    withdrawl_steel = vis.Vision(needle='./windrawl_all').click_image()
    if withdrawl_steel == 1:
        sys.exit(1)

    #   Wait for the items to appear in the player's inventory.
    steel_bars_in_inventory = vis.Vision(needle='./steel_bar_in_inv') \
        .wait_for_image(xmin=inv_xmin, xmax=inv_xmax, ymin=inv_ymin, ymax=inv_ymax)
    if steel_bars_in_inventory == 1:
        print('timed out waiting for steel bars to show up in inv')
