from unittest import TestCase
from python.main import vision
import os
import time


class TestWait_for_image(TestCase):

    def test_wait_for_image_orient(self):
        os.system('sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png &')
        time.sleep(.3)
        test_return = vision.Vision(needle='./tests/images/Orient1.PNG')
        test_return = test_return.wait_for_image()
        self.assertNotEqual(test_return, 1)
        os.system('pkill -f "./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png"')

    def test_wait_for_image_bank(self):
        os.system('sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png &')
        time.sleep(.3)
        test_return = vision.Vision(needle='./tests/images/needles/game-screen/'
                                           'bank-booth-edgeville.png')
        test_return = test_return.wait_for_image()
        self.assertNotEqual(test_return, 1)
        os.system('pkill -f "./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png"')
