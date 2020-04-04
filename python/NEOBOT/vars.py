# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import sys
import pyautogui as pag
import yaml
# set high recursion limit for functions that call themselves.
sys.setrecursionlimit(9999999)
conf = 0.95

system_mining = 1  # Tell the miner script if you're mining in the same
# system you're storing your ore in. 1 is yes, 0 is no.

# search for the eve neocom logo in top left corner of the eve client window.
# This will become the origin of the coordinate system.
origin = pag.locateCenterOnScreen('./img/buttons/neocom.bmp', confidence=0.90)
if origin is None:
    print("origin -- can't find client!")
    sys.exit(0)
else:
    (originx, originy) = origin

# Move the origin up and to the left slightly to get it to the exact top
# left corner of the eve client window. This is necessary  because the image
# searching algorithm returns coordinates to the center of the image rather
# than its top right corner.
originx -= 20
originy -= 20

# Read config file and get client resolution.
with open('./config.yaml') as f:
    config = yaml.safe_load(f)

windowx = config['client_width']
windowy = config['client_height']
