# encoding: utf-8
import sys
import logging as log
import pyautogui as pag
import yaml


# Set high recursion limit for functions that call themselves.
sys.setrecursionlimit(9999)
conf = 0.95


# Search for 'anchor image'.
# This will become the origin of the coordinate system.
def orient():
    global client_xmin
    global client_ymin
    anchor = pag.locateCenterOnScreen('./tests/images/Orient1.PNG', confidence=conf)
    if anchor is None:
        log.fatal('Cannot find image ' + str(anchor) + ' on client!')
        return 1
    else:
        log.debug('Found anchor' + str(anchor))
        (client_xmin, client_ymin) = anchor
        # Move the origin up and to the left slightly to get it to the exact top
        # left corner of the eve client window.
        #   This is necessary because the image
        # searching algorithm returns coordinates to the center of the image
        #   rather than its top right corner.
        return 0


# Read config file and get client resolution.
#with open('./config.yaml') as f:
    #config = yaml.safe_load(f)

#client_xmax = config['client_width']
#client_ymax = config['client_height']

client_xmin = 0
client_ymin = 0

client_xmax = 1920
client_ymax = 1080
