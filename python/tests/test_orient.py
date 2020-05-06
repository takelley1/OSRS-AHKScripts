import os
import time
from unittest import TestCase
from python.main import orient


class TestOrient(TestCase):

    def test_orient_atbank(self):
        # Present an ingame screenshot to the bot to simulate the game client.
        # The process MUST be forked into the background using '&'.
        os.system('sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/CSAtBank.png &')
        # This sleep is required or the test will fail before the image is
        #   displayed.
        # Run the image-recognition test function(s).
        test_return = orient.orient()
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
        test_return2 = orient.orient()
        time.sleep(1)
        self.assertEqual(test_return2, 0)
        os.system('pkill -f "sxiv -z 100 ./tests/haystacks/'
                  'smithing-edgeville-cannonballs/edgeville-bank-booth.png"')
