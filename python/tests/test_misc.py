from unittest import TestCase
from python.src import misc


class TestSleepRand(TestCase):
    def test_sleep_rand(self):
        result = misc.sleep_rand(0, 100)
        print(result)
        self.assertEqual(result, 100)

