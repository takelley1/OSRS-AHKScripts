import subprocess as sub
import time

import psutil

from ocvbot import input

# This file is a full regression test of the bot that intends to test every
#   "ocvbot" behavior in sequence, as if the actual bot is being run.
# Images are presented in sequence to simulate the game client.
# Intended for Linux with the feh image viewer.


def kill(procname):
    """
    Kills the provided process by name.
    """
    for proc in psutil.process_iter():
        if proc.name() == procname:
            proc.kill()


def test_cannonball_smelter():
    """
    Full simulation of the cannonball_smelter script using
    screenshots.
    """

    from ocvbot.vision import vgame_screen, vchat_menu, vinv
    interval = 0.05

    # -------------------------------------------------------------------------
    # Present the first client image to the bot.
    time.sleep(interval)
    kill('feh')
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-bank-booth-01.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Click on the bank booth.
    bank_booth = vgame_screen.click_image(needle='./ocvbot/needles/game-screen/'
                                         'edgeville-bank-booth-03.png',
                                         conf=0.995)
    if bank_booth == 1:
        raise RuntimeError('Could not find bank booth!')

    # -------------------------------------------------------------------------
    # If the function passes, remove the client image and replace it
    #   with a new one.
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-blast-furnace/"
                      "blast-furnace-bank-window-05.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Wait for the bank window to appear.
    bank_window = vgame_screen.wait_for_image('./ocvbot/needles/buttons/'
                                             'bank-window-close.png')
    if bank_window == 1:
        raise RuntimeError('Timed out waiting for bank window to open!')

    # Right click icon of steel bars.
    # Confidence must be high so bot can distinguish "full" items and
    #   "depleted" item slots within the bank.
    # Can't use the right mouse button during simulations.
    right_click_steel = vgame_screen.click_image(button='left', conf=0.9995,
                                                needle='./ocvbot/needles/'
                                                'items/steel-bar.png')
    if right_click_steel == 1:
        raise RuntimeError('Could not right click steel bars!')

    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-blast-furnace/"
                      "blast-furnace-bank-window-02.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Select the withdraw option in right-click ocvbot-menu.
    withdraw_steel_bars = vgame_screen.click_image(needle='./ocvbot/needles/'
                                                  'buttons/right-click-'
                                                  'withdraw-all.png')
    if withdraw_steel_bars == 1:
        raise RuntimeError('Could not click "Withdraw All" for steel bars!')

    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-bank-window-02.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Wait for the items to appear in the player's inventory.

    # Get a new coordinate space for the player's item inventory screen
    #   relative to the game client.

    # The left edge of the inventory is about 555 pixels to the right of the
    #   left edge of the game client.
    #inv_left = client_left + 555
    #inv_top = client_top + 220

    #inv = vis.Vision(left=inv_left, top=inv_top,
                     #width=INV_WIDTH, height=INV_HEIGHT)
    #steel_bars_in_inventory = inv.wait_for_image(needle='./ocvbot/needles/'
                                                        #'items/steel-bar.png')
    #if steel_bars_in_inventory == 1:
        #raise RuntimeError('Timed out waiting for steel bars to show up'
                           #'in inventory!')

    # Close the bank window
    bank_window_close = vgame_screen.click_image(needle='./ocvbot/needles/'
                                                'buttons/bank-window-'
                                                'close.png')
    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-bank-booth-06.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    furnace = vgame_screen.click_image(needle='./ocvbot/needles/game-screen/'
                                      'edgeville-furnace-from-bank.png')

    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-furnace-03.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Press spacebar to begin smelting the cannonballs.
    begin_smelting = vchat_menu.wait_for_image(needle='./ocvbot/needles/chat-menu/'
                                              'smelting.png')
    if begin_smelting == 1:
        raise RuntimeError('Could not find smelting.png chat menu!')

    input.keypress('space')

    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-furnace-04.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Smelting has completed when the bottom half of the inventory is empty.
    # Continually check for this, waiting at least 10 minutes.
    done_smelting = vinv.wait_for_image(loop_num=600,
                                       loop_sleep_min=1000,
                                       loop_sleep_max=5000,
                                       conf=0.98,
                                       needle='./ocvbot/needles/ocvbot-menu/'
                                       'inventory-empty-'
                                       'lower-half.png')

    # Even if wait_for_image times out, return to the bank.
    if done_smelting == 1 or done_smelting != 1:
        bank = vgame_screen.click_image(needle='./ocvbot/needles/game-screen'
                                       '/edgeville-bank-from-furnace-01.png')

        # ---------------------------------------------------------------------
        kill('feh')
        time.sleep(interval)
        sub.Popen(["feh", "./tests/haystacks/"
                          "smithing-edgeville-cannonballs/"
                          "edgeville-furnace-04.png"])
        time.sleep(interval)
        # ---------------------------------------------------------------------
    # -------------------------------------------------------------------------
    #kill('feh')
    # -------------------------------------------------------------------------

        # Deposit cannonballs once bank window appears

# Small chance to do nothing before returning to bank.

#test_cannonball_smelter()

