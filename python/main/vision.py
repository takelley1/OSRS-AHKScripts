# encoding: utf-8
import sys
import logging as log
import pyautogui as pag
import random as rand
from python.main import misc
from python.main import input
from python.main import orient as ori


class Vision:

    def __init__(self, needle, haystack=0, grayscale=False, conf=0.95):
        self.needle = needle
        self.haystack = haystack
        self.grayscale = grayscale
        self.conf = conf

    def mlocate(self, loctype='regular'):

        """Searches the haystack image for the needle image, returning a tuple
        containing the needle's XY coordinates within the haystack. If a
        haystack image is not provided, this function searches the entire client
        window.

        parameters:

            self.needle: The image to search for. Must be a filepath string.

            self.haystack (default = 0): The image to search within for the
                                         needle. If this is 0, the function will
                                         search the client window.

            conf (default = 0.95): The confidence value required to match the
                                   image successfully. This is used by
                                   Pyautogui.

            loctype (default = 'regular'): The method and/or haystack used to
                                           search for images. If a haystack is
                                           provided, this parameter is ignored.

                regular: Searches the client window. If the needle is found,
                         returns '1'.

                center: Searches the client window. If the needle is found,
                        returns the XY coordinates of its center, relative to
                        the coordinate plane of the haystack image.

            self.grayscale (default = False): Converts the haystack to grayscale
                                              before searching within it. Speeds
                                              up searching by about 30%."""

        if self.haystack != 0:
            target_image = pag.locate(self.needle, self.haystack,
                                      confidence=self.conf, grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found needle: ' + (str(self.needle)) +
                          ' in haystack: ' + str(self.haystack) + ', ' +
                          str(target_image))
                return target_image
            else:
                log.info('Cannot find needle: ' + str(self.needle) +
                         ' in haystack: ' + str(self.haystack) + ', ' +
                         str(target_image) + ', conf=' + str(self.conf))
                return 0

        if self.haystack == 0 and loctype == 'regular':
            target_image = pag.locateCenterOnScreen(self.needle,
                                                    confidence=self.conf,
                                                    region=(ori.client_xmin,
                                                            ori.client_ymin,
                                                            ori.client_xmax,
                                                            ori.client_ymax),
                                                    grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found regular image ' + str(self.needle) + ', ' +
                          str(target_image))
                return 1
            elif target_image is None:
                log.info('Cannot find regular image ' + str(self.needle) +
                         ' conf=' + str(self.conf))
                return 0

        if self.haystack == 0 and loctype == 'center':
            target_image = pag.locateCenterOnScreen(self.needle,
                                                    confidence=self.conf,
                                                    region=(ori.client_xmin,
                                                            ori.client_ymin,
                                                            ori.client_xmax,
                                                            ori.client_ymax),
                                                    grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found center of ' + str(self.needle) + ', ' +
                          str(target_image))
                return target_image
            elif target_image is None:
                log.info('Cannot find center of ' + str(self.needle) +
                         ', conf=' + str(self.conf))
                return 0

        else:
            raise RuntimeError('Incorrect mlocate function parameters!')

    def wait_for_image(self, loop_num=10, loop_sleep_min=100,
                       loop_sleep_max=1000):
        """Continuously loops until the desired image is found."""

        log.debug('Searching for ' + str(self.needle))

        for tries in range(1, loop_num):
            target_image = Vision.mlocate(self, loctype= 'center')

            if target_image != 0:
                log.debug('Found ' + str(self.needle) + ', after trying '
                          + str(tries) + ' times.')
                return target_image
            else:
                log.warning('Cannot find ' + str(self.needle) + ', tried '
                            + str(tries) + ' times.')
                misc.sleep_rand(loop_sleep_min, loop_sleep_max)

        log.error('Timed out looking for ' + str(self.needle) + ' !')
        return 1

    def click_image(self, button='left', loop_num=10,
                    loop_sleep_min=100, loop_sleep_max=1000,
                    rand_xmin=3, rand_xmax=3,
                    rand_ymin=3, rand_ymax=3):

        """Moves the mouse to the provided needle image and clicks on it. If a
        haystack is provided, searches for the provided image within the
        haystack. If a haystack is not provided, searches within an area defined
        by the loctype parameter.

        Arguments:

            needle: a filepath to the image to search for, relative to the
                    script's working directory

            haystack: the image to search for the needle within. Must be a PIL
                      image variable.

            loctype: if the haystack parameter is 0, this parameter is used to
                     create a haystack.

                c: (default) searches client for the xy center of the needle.
                   Returns x,y coordinates

                co: Searches the overview for the xy center of the needle.

            rx1 / ry1: the minimum x/y value to generate a random variable from.
            rx2 / ry2: the maximum x/y/ value to generate a random variable
            from."""

        log.debug('Looking for ' + str(self.needle) + ' to click on.')

        target_image = self.wait_for_image(loop_num=loop_num,
                                           loop_sleep_min=loop_sleep_min,
                                           loop_sleep_max=loop_sleep_max)
        if target_image != 1:
            (x, y) = target_image
            pag.moveTo((x + (rand.randint(rand_xmin, rand_xmax))),
                       (y + (rand.randint(rand_ymin, rand_ymax))),
                       input.move_duration(), input.move_path())
            input.click(button=button)
            log.debug('Clicking on ' + str(self.needle) + ' .')
            return 0

        return 1
