import os
import subprocess as sub
import time
from unittest import TestCase

import psutil

from ocvbot import behavior, vision

interval = 0.05


def kill(procname):
    """
    Kills the provided process by name.
    """
    for proc in psutil.process_iter():
        if proc.name() == procname:
            proc.kill()


kill('feh')
# Provide an image for the client to orient itself.
sub.Popen(["feh", "../tests/unit-tests/"
                  "test_behavior/"
                  "image_002.png"])
time.sleep(interval)
vision.init_vision()
kill('feh')


class TestLogout(TestCase):

    def test_logout_01(self):
        # Function recognizes when client is already logged out.
        time.sleep(interval)
        kill('feh')
        sub.Popen(["feh", "../tests/unit-tests/"
                          "test_behavior/"
                          "image_001.png"])
        time.sleep(interval)
        result = behavior.logout()
        kill('feh')
        self.assertEqual(result, 1)

    #def test_logout_02(self):
        # Function recognizes when client is logged in but "logout"
        #   side stone is not active.
        #time.sleep(interval)
        #kill('feh')
        #sub.Popen(["feh", "../tests/unit-tests/"
                          #"test_behavior/"
                          #"image_003.png"])
        #time.sleep(interval)
        #result = behavior.logout()
        #kill('feh')
        #self.assertRaises(result, RuntimeError)

    def test_logout_03(self):
        # Function recognizes when client is logged in and "logout"
        #   side stone is active.
        time.sleep(interval)
        kill('feh')
        sub.Popen(["feh", "../tests/unit-tests/"
                          "test_behavior/"
                          "image_004.png"])
        time.sleep(interval)
        result = behavior.logout()
        kill('feh')
        self.assertEqual(result, 0)
