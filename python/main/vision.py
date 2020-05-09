import logging as log
import pyautogui as pag
import sys
from python.main import misc
from python.main import input
sys.setrecursionlimit(9999)


class Vision:

    def __init__(self, left, top, width, height, haystack=0, grayscale=False):
        self.haystack = haystack
        self.grayscale = grayscale
        self.left = left
        self.top = top
        self.width = width
        self.height = height

    def mlocate(self, needle, loctype='regular', conf=0.95):
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
            target_image = pag.locate(needle, self.haystack,
                                      confidence=conf,
                                      grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found needle: ' + (str(needle)) +
                          ' in haystack: ' + str(self.haystack) + ', ' +
                          str(target_image))
                return target_image
            else:
                log.info('Cannot find needle: ' + str(needle) +
                         ' in haystack: ' + str(self.haystack) + ', ' +
                         str(target_image) + ', conf=' + str(conf))
                return 1

        if self.haystack == 0 and loctype == 'regular':
            target_image = pag.locateOnScreen(needle,
                                              confidence=conf,
                                              region=(self.left, self.top,
                                                      self.width, self.height),
                                              grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found regular image ' + str(needle) + ', ' +
                          str(target_image))
                return target_image
            elif target_image is None:
                log.info('Cannot find regular image ' + str(needle) +
                         ' conf=' + str(conf))
                return 1

        if self.haystack == 0 and loctype == 'center':
            target_image = pag.locateCenterOnScreen(needle,
                                                    confidence=conf,
                                                    region=(self.left,
                                                            self.top,
                                                            self.width,
                                                            self.height),
                                                    grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found center of ' + str(needle) + ', ' +
                          str(target_image))
                return target_image
            elif target_image is None:
                log.info('Cannot find center of ' + str(needle) +
                         ', conf=' + str(conf))
                return 1

        else:
            raise RuntimeError('Incorrect mlocate function parameters!')

    def wait_for_image(self, needle, loctype='regular', conf=0.95, loop_num=10,
                       loop_sleep_min=10, loop_sleep_max=1000):
        """Repeatedly searches the haystack for the needle."""

        # log.debug('Looking for ' + str(needle))

        for tries in range(1, loop_num):
            target_image = Vision.mlocate(self, conf=conf, needle=needle,
                                          loctype=loctype)

            if target_image != 0:
                log.debug('Found ' + str(needle) + ' after trying '
                          + str(tries) + ' times.')
                return target_image
            else:
                log.warning('Cannot find ' + str(needle) + ', tried '
                            + str(tries) + ' times.')
                misc.sleep_rand(loop_sleep_min, loop_sleep_max)

        log.error('Timed out looking for ' + str(needle) + '!')
        return 1

    def click_image(self, needle, button='left', conf=0.95,
                    loop_num=25, loop_sleep_min=10, loop_sleep_max=1000):

        """Moves the mouse to the provided needle image and clicks on it. If a
        haystack is provided, searches for the provided needle image within the
        haystack. If a haystack or set of coordinates is not provided, searches
        within the entire display.

        Arguments:

            self.needle: A filepath to the image to search for, relative to the
                         script's working directory.

            self.haystack: The image in which to search for the needle.
            from."""

        log.debug('Looking for ' + str(needle) + ' to click on.')

        target_image = self.wait_for_image(loop_num=loop_num,
                                           loop_sleep_min=loop_sleep_min,
                                           loop_sleep_max=loop_sleep_max,
                                           loctype='regular',
                                           needle=needle,
                                           conf=conf)
        if target_image == 1:
            return 1
        else:
            (x, y, w, h) = target_image
            # Randomize the location the pointer will move to using the
            #   dimensions of needle image.
            input.move_to(x, y, xmin=0, xmax=w, ymin=0, ymax=h)
            log.debug('Clicking on ' + str(needle) + '.')
            input.click(button=button)
            return 0
