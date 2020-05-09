import logging as log
import os
import time

import pyautogui as pag

from python.main import vision as vis

# This file is a full regression test of the bot that intends to test every
#   "main" behavior in sequence, as if the actual bot is being run.
# Images are presented in sequence to simluate the game client.
# Intended for Linux with the feh image viewer.

log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s'
                , level='DEBUG')
kill_cmd = 'pkill --signal 9 feh &> /dev/null'


def test_cannonball_smelter():
    interval = 1
    global kill_cmd

    # -------------------------------------------------------------------------
    # Present the first client image to the bot.
    os.system(kill_cmd)
    time.sleep(interval)
    os.system('feh ./tests/haystacks/'
              'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Orient client to establish coordinate space.
    # Read config file and get client resolution.
    # with open('./config.yaml') as f:
    # config = yaml.safe_load(f)

    # client_xmax = config['client_width']
    # client_ymax = config['client_height']

    # Get initial display size.
    screen_width = pag.size().width
    screen_height = pag.size().height

    # Look for the prayers icon on the display. If it's found, use its location
    #   within the game client to determine the edges and coordinate space of
    #   the game client relative to the display's coordinate space.
    anchor = vis.Vision(left=0, top=0,
                        width=screen_width,
                        height=screen_height)\
        .wait_for_image(needle='./main/needles/menu/prayers.png')

    # The wait_for_image function returns a tuple with a few vars we don't
    #   need.
    (client_left, client_top, unused_var1, unused_var2) = anchor

    # The left corner of the game client is 709 pixels to the left of the
    #   prayers icon
    client_left -= 709
    client_top -= 186

    # These are constants. The width and height of the client in pixels does
    #   not change.
    client_width = 765
    client_height = 503

    # Now we can create an object with the client's X and Y coordinates.
    # This will allow us to search for needles within the client, rather than
    #   within the whole display, which is much faster.
    client = vis.Vision(left=client_left, width=client_width,
                        top=client_top, height=client_height)

    # Click on the bank booth.
    bank_booth = client.click_image(needle='./main/needles/game-screen/'
                                           'edgeville-bank-booth-01.png')
    if bank_booth == 1:
        raise RuntimeError('Could not find bank booth!')

    # -------------------------------------------------------------------------
    # If the function passes, remove the client image and replace it with a new
    #   one.
    os.system(kill_cmd)
    time.sleep(interval)
    os.system('feh ./tests/haystacks/'
              'smithing-blast-furnace/blast-furnace-bank-window-05.png &')
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Wait for the bank window to appear.
    bank_window = client.wait_for_image('./main/needles/buttons/'
                                        'bank-window-close.png')
    if bank_window == 1:
        raise RuntimeError('Timed out waiting for bank window to open!')

    # Right click icon of steel bars.
    # Confidence must be high so bot can distinguish "full" items and
    #   "depleted" item slots within the bank.
    # Can't use the right mouse button during simulations.
    right_click_steel = client.click_image(button='left', conf=0.9995,
                                           needle='./main/needles/'
                                                  'items/steel-bar.png')
    if right_click_steel == 1:
        raise RuntimeError('Could not right click steel bars!')

    # -------------------------------------------------------------------------
    os.system(kill_cmd)
    time.sleep(interval)
    os.system('feh ./tests/haystacks/'
              'smithing-blast-furnace/blast-furnace-bank-window-02.png &')
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Select the withdraw option in right-click menu.
    withdraw_steel_bars = client.click_image(needle='./main/needles/buttons/'
                                                    'right-click-'
                                                    'withdraw-all.png')
    if withdraw_steel_bars == 1:
        raise RuntimeError('Could not click "Withdraw All" for steel bars!')

    # -------------------------------------------------------------------------
    os.system(kill_cmd)
    time.sleep(interval)
    os.system('feh ./tests/haystacks/'
              'smithing-edgeville-cannonballs/edgeville-furnace-01.png &')
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Wait for the items to appear in the player's inventory.

    # Get a new coordinate space for the player's item inventory screen
    #   relative to the game client.

    # The left edge of the inventory is about 555 pixels to the right of the
    #   left edge of the game client.
    inv_left = client_left + 555
    inv_top = client_top + 220

    # These are constants.
    inv_width = 190   # Total width of the inventory screen, in pixels.
    inv_height = 265  # Total height of the inventory screen, in pixels.

    inv = vis.Vision(left=inv_left, top=inv_top,
                     width=inv_width, height=inv_height)
    steel_bars_in_inventory = inv.wait_for_image(needle='./main/needles/'
                                                        'items/steel-bar.png')
    if steel_bars_in_inventory == 1:
        raise RuntimeError('Timed out waiting for steel bars to show up'
                           'in inventory!')


# -----------------------------------------------------------------------------
os.system(kill_cmd)
# -----------------------------------------------------------------------------

test_cannonball_smelter()
