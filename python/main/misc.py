import random as rand
import sys
import time

sys.setrecursionlimit(9999)


def rand_seconds(rmin=0, rmax=100):
    """Gets a random integer between two values. Input is in miliseconds
    but output is in seconds. For example, if this function generates a
    random value of 391, it will return a value of 0.391.

    Arguments:
        rmin (default = 0)  : The minimum number of miliseconds.
        rmax (default = 100): The maximum number of miliseconds.

    Returns:
        Returns a float."""

    randval = float(rand.randint(rmin, rmax)) / 1000
    # log.debug('Got random value of ' + str(randval) + '.')
    return randval


def sleep_rand(rmin=0, rmax=100):
    """Does nothing for a random period of time. Input arguments are in
    miliseconds.

    Arguments:
        rmin (default = 0)  : The minimum number of miliseconds to wait.
        rmax (default = 100): The maximum number of miliseconds to wait.

    Returns:
        Returns 0 after sleeping."""

    sleeptime = rand_seconds(rmin, rmax)
    # log.debug('Sleeping for ' + str(sleeptime) + ' seconds.')
    time.sleep(float(sleeptime))
    return 0
