import time
import logging as log
import random as rand

import pyautogui as pag


def rand_val(rmin=0, rmax=100):
    """Gets a random integer between two values. This is used for waiting
    a random period of time inside of other functions. The input is in
    miliseconds, but the output is in seconds.

    Arguments:

        rmin (default = 0): The minimum period of time to wait for.
        rmax (default = 100): The maximum period of time to wait for.

    Returns:
        
        Returns a random float."""

    log.debug('Generating random value between ' + str(rmin) + ' and ' + str(
            rmax))
    randval = float(rand.randint(rmin, rmax)) / 1000
    return randval


def sleep_rand(rmin=0, rmax=100):
    log.debug('Sleeping between ' + str(rmin) + ' and ' + str(rmax) +
              ' miliseconds.')
    """Does nothing for a random period of time. Argument values are in
    miliseconds.

    Arguments:

        rmin (default = 0): The minimum time to wait.
        rmax (default = 100): The maximum time to wait.

    Returns:

        Always returns 0."""

    time.sleep(float(rand.randint(rmin, rmax)) / 1000)
    return 0


