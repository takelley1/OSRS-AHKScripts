import time
import logging as log
import random as rand

import pyautogui as pag

log.basicConfig(format='(%(asctime)s) %(funcName)s - %(''message)s',
                level=log.DEBUG)


def rand_val(rmin=0, rmax=100):
    """Returns a random integer between two values. This is
    used for waiting a random period of time within other functions. The
    input is in miliseconds, but the output is in seconds.

    parameters:
        rmin (default = 0): The minimum period of time to wait for.
        rmax (default = 100): The maximum period of time to wait for."""
    log.debug('Generating random value between ' + str(rmin) + ' and ' + str(
            rmax))
    randval = float(rand.randint(rmin, rmax)) / 1000
    return randval


def sleep_rand(rmin=0, rmax=100):
    log.debug('Sleeping between ' + str(rmin) + ' and ' + str(rmax) +
              ' miliseconds.')
    time.sleep(float(rand.randint(rmin, rmax)) / 1000)
    return 0


def keypress(key, timedown_min=5, timedown_max=190):
    """Holds down the specified key for a random period of time.
    parameters:
        key:
        timedown_min (default = 5):
        timedown_max (default = 190):
    """
    log.debug('Pressing key: ' + str(key))
    sleep_rand(500, 1000)
    pag.keyDown(key)
    sleep_rand(timedown_min, timedown_max)
    pag.keyUp(key)
    sleep_rand(500, 1000)
    return 0


def double_hotkey_press(key1, key2):
    """Performs a two-key hotkey shortcut, such as Ctrl-c for copying text."""
    log.debug('Pressing hotkeys: ' + str(key1) + ' + ' + str(key2))
    sleep_rand(500, 1000)
    pag.keyDown(key1)
    sleep_rand(10, 500)
    pag.keyDown(key2)
    sleep_rand(10, 500)
    pag.keyUp(key1)
    sleep_rand(10, 500)
    pag.keyUp(key2)
    sleep_rand(500, 1000)
    return 0
