# encoding: utf-8
import sys
import logging as log
import pyautogui as pag
import pyaml as yaml

log.basicConfig(format='(%(asctime)s) %(funcName)s - %(''message)s',
                level=log.DEBUG)

# Set high recursion limit for functions that call themselves.
sys.setrecursionlimit(9999999)
conf = 0.95

# Search for 'anchor image'.
# This will become the origin of the coordinate system.
anchor = pag.locateCenterOnScreen('./', confidence=0.90)
if anchor is None:
    log.fatal('Cannot find image ' + str(anchor) + ' on client!')
    sys.exit(1)
else:
    (client_xmin, client_ymin) = anchor

# Move the origin up and to the left slightly to get it to the exact top
# left corner of the eve client window. This is necessary  because the image
# searching algorithm returns coordinates to the center of the image rather
# than its top right corner.
client_xmin -= 20
client_ymin -= 20

# Read config file and get client resolution.
with open('./config.yaml') as f:
    config = yaml.safe_load(f)

client_xmax = config['client_width']
client_ymax = config['client_height']
