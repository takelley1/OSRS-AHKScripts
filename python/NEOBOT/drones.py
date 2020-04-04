# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import random
import time
from src import keyboard as key, locate as lo


def launch_drones(drone_num):
    """Launches drones and waits for them to leave the drone bay. User must
    manually set the "launch drones" hotkey to be Shift-l."""
    if drone_num != 0:
        logging.info('launching drones')
        time.sleep(float(random.randint(5, 500)) / 1000)
        key.hotkey('shift', 'l')

        for tries in range(1, 25):
            drones_launched = lo.mlocate(
                './img/indicators/drones/0_drone_in_bay.bmp')
            
            if drones_launched == 1:
                logging.debug('drones launched ' + (str(tries)))
                return 1
            
            elif drones_launched == 0:
                logging.debug('waiting for drones to launch ' + (str(tries)))
                time.sleep(float(random.randint(500, 2000)) / 1000)

        logging.warning('timed out waiting for drones to launch')
        return 0
    elif drone_num == 0:
        return 1


def recall_drones(drone_num):
    """Recalls drones and waits for them to return to the drone bay."""
    if drone_num != 0:
        time.sleep(float(random.randint(5, 500)) / 1000)
        key.hotkey('shift', 'r')
        time.sleep(float(random.randint(1000, 2000)) / 1000)

        # Wait for all drones to return to drone bay. Very sensitive to the
        # drones variable. Won't work unless the drones variable is correct.
        for tries in range(1, 30):
            drones_returned = lo.mlocate('./img/indicators/drones/' +
                                         (str(drone_num)) +
                                         '_drone_in_bay.bmp', grayscale=True)

            if drones_returned == 1:
                logging.debug('drones returned to bay')
                return 1

            elif drones_returned == 0:
                logging.info('waiting for drones to return to bay ' +
                             (str(tries)))
                time.sleep(float(random.randint(1000, 2000)) / 1000)
                return 0

        logging.warning('timed out waiting for drones to return')
        return 0
    elif drone_num == 0:
        return 0
