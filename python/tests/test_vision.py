import logging as log
import os
import time
import sys
from unittest import TestCase
from python.main import vision

sys.setrecursionlimit(9999)
log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s',
                level='DEBUG')


class TestWaitForImage(TestCase):
    os.system('pkill feh')

    def test_wait_for_image_prayers(self):
        # Tests if the script can see the prayers icon in the main main-menu for
        # establishing the script's coordinate system.
        os.system('feh -dB black ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
        time.sleep(.3)
        test_return = vision.Vision(needle='./main/needles/main-menu/prayers.png')\
            .wait_for_image()
        self.assertNotEqual(test_return, 1)
        os.system('pkill -f "tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png" &')
        time.sleep(.3)

    def test_wait_for_image_minimap_edgeville_bank_booth(self):
        # Tests if the script can recognize when the player is standing on the
        # correct tile in Edgeville bank by checking the minimap.
        os.system('feh -dB black ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
        time.sleep(.3)
        test_return = vision.Vision(needle='./main/needles/minimap/'
                                           'edgeville-bank-booth.png') \
            .wait_for_image()
        self.assertNotEqual(test_return, 1)
        os.system('pkill -f "tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png" &')
        time.sleep(.3)

    def test_wait_for_image_game_screen_edgeville_bank_booth(self):
        # Tests if the script can recognize the Edgeville bank booth in the
        # game screen when the player is standing on the correct tile.
        os.system('feh -dB black ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
        time.sleep(.3)
        test_return = vision.Vision(needle='./main/needles/game-screen/'
                                           'edgeville-bank-booth.png') \
            .wait_for_image()
        self.assertNotEqual(test_return, 1)
        os.system('pkill -f "tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png" &')
        time.sleep(.3)


class TestOrient(TestCase):

    def test_orient_atbank(self):
        # Present an ingame screenshot to the bot to simulate the game client.
        # The process MUST be forked into the background using '&'.
        os.system('sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/CSAtBank.png &')
        # This sleep is required or the test will fail before the image is
        #   displayed.
        # Run the image-recognition test function(s).
        test_return = python.main.vision.orient()
        # Check the return value of the test function to see if it was
        #   successful.
        time.sleep(1)
        self.assertEqual(test_return, 0)
        # If the test passes, remove the image.
        # If the test fails, the image will stay on the screen.
        os.system('pkill -f "sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/CSAtBank.png"')

    def test_orient_atbank2(self):

        os.system('sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png &')
        test_return2 = python.main.vision.orient()
        time.sleep(1)
        self.assertEqual(test_return2, 0)
        os.system('pkill -f "sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png"')
