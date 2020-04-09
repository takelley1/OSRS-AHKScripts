from unittest import TestCase
from python.src import misc
import os
import time

class TestFunc1(TestCase):
    def test_func1(self):
        # present an ingame screenshot to the script to simulate running the
        # actual bot
        os.system('sxiv -f -z 100 '
                  '/home/austin/OSRS-AHKScripts/python/test2.png &')
        # run a test function
        result = misc.sleep_rand(0, 100)
        # check the result of the test function to see if it's correct
        test = self.assertEqual(1, 0)
        print(test)
        if test is None:
            # if it is correct, take down the image and stop the test
            os.system('killall sxiv')
        # If the test doesn't pass, the image will simply stay on the screen
