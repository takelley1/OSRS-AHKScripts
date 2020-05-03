import os
import time
from unittest import TestCase
from python.main import misc
from python.main import orient


class Tests(TestCase):

    def test_orient(self):
        # Present an ingame screenshot to the bot to simulate the game client.
        # The process MUST be forked into the background using '&'.
        os.system('sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank.png &')
        # This sleep is required or the test will fail before the image is
        #   displayed.
        time.sleep(0.1)
        # Run the image-recognition test function(s).
        orient_test = orient.orient()
        # Check the return value of the test function to see if it was
        #   successful.
        self.assertEqual(orient_test, 0)
        # If the test passes, remove the image.
        # If the test fails, the image will stay on the screen.
        os.system('pkill -f "sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank.png"')
