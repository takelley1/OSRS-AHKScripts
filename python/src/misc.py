import time
import logging as log
import random as rand

import pyautogui as pag


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


