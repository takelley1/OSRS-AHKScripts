import os
from unittest import TestCase
from python.main import orient


class TestOrient(TestCase):

    def test_orient_atbank(self):
        # Present an ingame screenshot to the bot to simulate the game client.
        # The process MUST be forked into the background using '&'.
        os.system('sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank.png &')
        # This sleep is required or the test will fail before the image is
        #   displayed.
        # Run the image-recognition test function(s).
        test_return = orient.orient()
        # Check the return value of the test function to see if it was
        #   successful.
        self.assertEqual(test_return, 0)
        # If the test passes, remove the image.
        # If the test fails, the image will stay on the screen.
        os.system('pkill -f "sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank.png"')

    def test_orient_atbank2(self):

        os.system('sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png &')
        test_return = orient.orient()
        self.assertEqual(test_return, 0)
        os.system('pkill -f "sxiv -z 100 ./tests/images/'
                  'smithing-edgeville-cannonballs/CSAtBank2.png"')
