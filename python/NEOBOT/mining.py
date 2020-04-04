# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import random
import sys
import time
from src import keyboard as key, locate as lo
sys.setrecursionlimit(9999999)


def activate_miners(module_num):
    """Activates mining modules based on the number passed to this function.
    If the module is out of range, script will try to wait until ship gets
    within range before activating any more modules."""
    for n in range(1, (module_num + 1)):
        key.keypress('f' + (str(n)))
        logging.debug('activating miner ' + (str(n)))
        out_of_range = lo.mlocate('./img/popups/miner_out_of_range.bmp',
                                  conf=0.90, grayscale=True)
        tries = 0
        while out_of_range == 1 and tries <= 25:
            tries += 1
            time.sleep(float(random.randint(15000, 30000)) / 1000)
            out_of_range = lo.mlocate('./img/popups/miner_out_of_range.bmp',
                                      conf=0.90, grayscale=True)
            if out_of_range == 0 and tries <= 25:
                time.sleep(float(random.randint(0, 3000)) / 1000)
                logging.debug('activating miner ' + (str(n)))
                key.keypress('f' + (str(n)))
        if out_of_range == 0 and tries <= 25:
            continue
        elif out_of_range == 1 and tries > 25:
            logging.error('timed out waiting for ship to get within '
                          'module range')
            return 0
    return 1


def time_at_site(timer_var):
    """Timeout timer for mining. If, for some reason, ship gets stuck in
    belt, the timer can be used to restart the script after a certain period of
    time."""
    logging.debug('time spent at site is ' + (str(timer_var)) + 's')
    if timer_var >= 800:
        logging.warning('timed out!')
        return 1
    elif timer_var < 800:
        return 0
