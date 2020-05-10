import logging as log
import subprocess as sub
import time

import psutil
import pyautogui as pag

from python.main import behavior as behav
from python.main import input
from python.main import vision as vis

# This file is a full regression test of the bot that intends to test every
#   "main" behavior in sequence, as if the actual bot is being run.
# Images are presented in sequence to simulate the game client.
# Intended for Linux with the feh image viewer.

log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s'
                , level='DEBUG')


def kill(procname):
    """Kills the provided process by name."""
    for proc in psutil.process_iter():
        if proc.name() == procname:
            proc.kill()


def miner():

    # TODO: make more generic, accept variables as needles
    (client, inv) = vis.orient()

    while True:
        # if first rock is full, begin mining it.
        rock1_full = client.click_image(needle='./main/needles/south_full.png',
                                        conf=0.85,
                                        move_duration_min=10,
                                        move_duration_max=500,
                                        click_sleep_before_min=0,
                                        click_sleep_before_max=100,
                                        click_sleep_after_min=0,
                                        click_sleep_after_max=100,
                                        loop_sleep_min=100, loop_sleep_max=100,
                                        loop_num=2)
        if rock1_full != 1:

            # Before checking to see if the first rock is empty, check
            #   if the player's inventory is full.
            inv_full = client.wait_for_image(needle='./main/needles/chat-menu/'
                                                    'mining-inventory-full.png'
                                             , loop_num=1)

            # If the player's inventory is full, drop all copper ore.
            if inv_full != 1:
                inv.drop_all_item(item='./main/needles/items/copper-ore.png')

            # Wait first rock is empty.
            client.wait_for_image(needle='./main/needles/south_empty.png',
                                  conf=0.85,
                                  loop_sleep_min=100, loop_sleep_max=100,
                                  loop_num=50)

        # If/when first rock is empty, check second rock.
        rock2_full = client.click_image(needle='./main/needles/east_full.png',
                                        conf=0.85,
                                        move_duration_min=10,
                                        move_duration_max=500,
                                        click_sleep_before_min=0,
                                        click_sleep_before_max=100,
                                        click_sleep_after_min=0,
                                        click_sleep_after_max=100,
                                        loop_sleep_min=100, loop_sleep_max=100,
                                        loop_num=2)
        if rock2_full != 1:
            inv_full = client.wait_for_image(needle='./main/needles/chat-menu/'
                                                    'mining-inventory-'
                                                    'full.png', loop_num=1)
            if inv_full != 1:
                inv.drop_all_item(item='./main/needles/items/copper-ore.png')

            client.wait_for_image(needle='./main/needles/east_empty.png',
                                  conf=0.85,
                                  loop_sleep_min=100, loop_sleep_max=100,
                                  loop_num=40)


def test_cannonball_smelter():
    """Full simulation of the cannonball_smelter script using
    screenshots."""

    interval = 0.05
    (client, inv) = vis.orient()

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
    bank_booth = client.click_image(needle='./main/needles/game-screen/'
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
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-blast-furnace/"
                      "blast-furnace-bank-window-02.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    # Select the withdraw option in right-click main-menu.
    withdraw_steel_bars = client.click_image(needle='./main/needles/buttons/'
                                                    'right-click-'
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
    #steel_bars_in_inventory = inv.wait_for_image(needle='./main/needles/'
                                                        #'items/steel-bar.png')
    #if steel_bars_in_inventory == 1:
        #raise RuntimeError('Timed out waiting for steel bars to show up'
                           #'in inventory!')

    # Close the bank window
    bank_window_close = client.click_image(needle='./main/needles/'
                                           'buttons/bank-window-close.png')
    # -------------------------------------------------------------------------
    kill('feh')
    time.sleep(interval)
    sub.Popen(["feh", "./tests/haystacks/"
                      "smithing-edgeville-cannonballs/"
                      "edgeville-bank-booth-06.png"])
    time.sleep(interval)
    # -------------------------------------------------------------------------

    furnace = client.click_image(needle='./main/needles/game-screen/'
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
    begin_smelting = client.wait_for_image(needle='./main/needles/chat-menu/'
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
    done_smelting = client.wait_for_image(loop_num=600,
                                          loop_sleep_min=1000,
                                          loop_sleep_max=5000,
                                          conf=0.98,
                                          needle='./main/needles/main-menu/'
                                                 'inventory-empty-'
                                                 'lower-half.png')

    # Even if wait_for_image times out, return to the bank.
    if done_smelting == 1 or done_smelting != 1:
        bank = client.click_image(needle='./main/needles/game-screen'
                                         '/edgeville-bank-from-furnace-01.png')

        # ---------------------------------------------------------------------
        kill('feh')
        time.sleep(interval)
        sub.Popen(["feh", "./tests/haystacks/"
                          "smithing-edgeville-cannonballs/"
                          "edgeville-furnace-04.png"])
        time.sleep(interval)
        # ---------------------------------------------------------------------

        # Deposit cannonballs once bank window appears

# Small chance to do nothing before returning to bank.
# behav.wait_rand(chance=10, wait_min=10000, wait_max=60000)


# -----------------------------------------------------------------------------
kill('feh')
# -----------------------------------------------------------------------------

miner()
