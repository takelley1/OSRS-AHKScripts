import logging as log
import pyautogui as pag
import random as rand
import sys
from python.main import misc
from python.main import input
sys.setrecursionlimit(9999)


def orient():
    global client_xmin
    global client_ymin
    anchor = Vision(needle='./main/needles/menu/prayers.png').wait_for_image()
    if anchor is None:
        log.fatal('Cannot find anchor image ' + str(anchor) + ' on client!')
        return 1
    else:
        log.debug('Found anchor' + str(anchor))
        (client_xmin, client_ymin) = anchor
        # Move the origin up and to the left slightly to get it to the exact top
        # left corner of the eve client window.
        #   This is necessary because the image
        # searching algorithm returns coordinates to the center of the image
        #   rather than its top right corner.
        return 0

    # Search for the 'anchor image'.
    # This will provide the basis for the client's the coordinate system.

    # Read config file and get client resolution.
    #with open('./config.yaml') as f:
    #config = yaml.safe_load(f)

    #client_xmax = config['client_width']
    #client_ymax = config['client_height']

client_xmin = 0
client_ymin = 0
client_xmax = 1920
client_ymax = 1080


class Vision:

    def __init__(self, needle, haystack=0, grayscale=False, conf=0.95):
        self.needle = needle
        self.haystack = haystack
        self.grayscale = grayscale
        self.conf = conf

    def mlocate(self, loctype='regular',
                xmin=client_xmin, ymin=client_ymin,
                xmax=client_xmax, ymax=client_ymax):
        """Searches the haystack image for the needle image, returning a tuple
        containing the needle's XY coordinates within the haystack. If a
        haystack image is not provided, this function searches the entire client
        window.

        Arguments:

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
                         returns the needle's left, top, width, and height.

                center: Searches the client window. If the needle is found,
                        returns the XY coordinates of its center, relative to
                        the coordinate plane of the haystack image.

            self.grayscale (default = False): Converts the haystack to grayscale
                                              before searching within it. Speeds
                                              up searching by about 30%."""

        if self.haystack != 0:
            target_image = pag.locate(self.needle, self.haystack,
                                      confidence=self.conf,
                                      grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found needle: ' + (str(self.needle)) +
                          ' in haystack: ' + str(self.haystack) + ', ' +
                          str(target_image))
                return target_image
            else:
                log.info('Cannot find needle: ' + str(self.needle) +
                         ' in haystack: ' + str(self.haystack) + ', ' +
                         str(target_image) + ', conf=' + str(self.conf))
                return 1

        if self.haystack == 0 and loctype == 'regular':
            target_image = pag.locateOnScreen(self.needle,
                                              confidence=self.conf,
                                              region=(xmin, ymin, xmax, ymax),
                                              grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found regular image ' + str(self.needle) + ', ' +
                          str(target_image))
                return target_image
            elif target_image is None:
                log.info('Cannot find regular image ' + str(self.needle) +
                         ' conf=' + str(self.conf))
                return 1

        if self.haystack == 0 and loctype == 'center':
            target_image = pag.locateCenterOnScreen(self.needle,
                                                    confidence=self.conf,
                                                    region=(xmin, ymin,
                                                            xmax, ymax),
                                                    grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found center of ' + str(self.needle) + ', ' +
                          str(target_image))
                return target_image
            elif target_image is None:
                log.info('Cannot find center of ' + str(self.needle) +
                         ', conf=' + str(self.conf))
                return 1

        else:
            raise RuntimeError('Incorrect mlocate function parameters!')

    def wait_for_image(self, loctype='regular', loop_num=10,
                       loop_sleep_min=10, loop_sleep_max=1000,
                       xmin=client_xmin, ymin=client_ymin,
                       xmax=client_xmax, ymax=client_ymax):
        """Repeatedly searches the haystack for the needle."""

        log.debug('Searching for ' + str(self.needle))

        for tries in range(1, loop_num):
            target_image = Vision.mlocate(self, loctype=loctype,
                                          xmin=xmin, ymin=ymin,
                                          xmax=xmax, ymax=ymax)

            if target_image != 0:
                log.debug('Found ' + str(self.needle) + ' after trying '
                          + str(tries) + ' times.')
                return target_image
            else:
                log.warning('Cannot find ' + str(self.needle) + ', tried '
                            + str(tries) + ' times.')
                misc.sleep_rand(loop_sleep_min, loop_sleep_max)

        log.error('Timed out looking for ' + str(self.needle) + '!')
        return 1

    def click_image(self, button='left', loop_num=25,
                    loop_sleep_min=10, loop_sleep_max=1000,
                    xmin=client_xmin, ymin=client_ymin,
                    xmax=client_xmax, ymax=client_ymax):
        """Moves the mouse to the provided needle image and clicks on it. If a
        haystack is provided, searches for the provided needle image within the
        haystack. If a haystack or set of coordinates is not provided, searches
        within the entire display.

        Arguments:

            self.needle: A filepath to the image to search for, relative to the
                         script's working directory.

            self.haystack: The image in which to search for the needle.
            from."""

        log.debug('Looking for ' + str(self.needle) + ' to click on.')

        target_image = self.wait_for_image(loop_num=loop_num,
                                           loop_sleep_min=loop_sleep_min,
                                           loop_sleep_max=loop_sleep_max,
                                           loctype='regular',
                                           xmin=xmin, ymin=ymin,
                                           xmax=xmax, ymax=ymax)
        if target_image == 1:
            return 1
        else:
            (x, y, w, h) = target_image
            # Randomize the location the pointer will move to using the
            #   dimensions of needle image.
            input.move_to(x, y, xmin=0, xmax=w, ymin=0, ymax=h)
            log.debug('Clicking on ' + str(self.needle) + '.')
            input.click(button=button)
            return 0


