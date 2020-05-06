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
test_return = vision.Vision(needle='./main/needles/menu/prayers.png') \
    .click_image()

print("hello")

sys.exit(0)
