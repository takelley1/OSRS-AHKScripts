import logging as log
import sys
import pyautogui as pag
import random as rand
import logging
import random
import sys
import time
import traceback
import os
import time
from unittest import TestCase
from python.main import misc
from python.main import orient
from python.main import vision


import yaml
from PIL import ImageOps

import tkinter
from tkinter import ttk

log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s',
                level='DEBUG')

#os.system('sxiv -z 100 /home/austin/OSRS-AHKScripts/python/tests/images/'
          #'smithing-edgeville-cannonballs/CSAtBank2.png &')
test = vision.wait_for_image(conf=0.7, needle='/home/austin/OSRS-AHKScripts/python/tests/images/Orient1.PNG')
#pag.mouseInfo()
#Mouse('left').move_away()

sys.exit(0)
