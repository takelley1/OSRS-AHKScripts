import logging as log
import subprocess as sub
import sys

import pyautogui as pag

from ocvbot.ocvbot import misc
from ocvbot.ocvbot import input

sys.setrecursionlimit(9999)

def find_anchor():
    # Look for the prayers icon on the display. If it's found, use its
    #   location within the game client to determine the coordinates of
    #   the game client relative to the display's coordinates.
    anchor = vis.Vision(left=0, top=0,
                        width=display_width,
                        height=display_height) \
        .wait_for_image(needle='./ocvbot/needles/find_anchor.png',
                        loctype='center', loop_num=2)
    if anchor != 1:
        return anchor

    if anchor == 1:
        # If the client is not logged in, try a different anchor.
        #anchor='../ocvbot/needles/find_anchor-logged-out.png', loctype='center')

        if anchor != 1:
            return anchor
        elif anchor == 1:
            log.critical('Could not find anchor!')
            raise RuntimeError('Could not find anchor!')




class Vision:
    """
    The primary object used for locating images on the display. All
    coordinates are relative to the display's dimensoins. Coordinate
    units are in pixels.

    Parameters:
        self.haystack (default = 0): The image within which to search
        for the needle. By default this will cause mlocate() to search
        within the coordinates provided by left/top/width/height.

        self.grayscale (default = False): Converts the haystack to
        grayscale before searching within it. Speeds up searching by
        about 30%.

        self.left: The left edge (x) of the coordinate space to search
        within for the needle.

        self.top: The top edge (y) of the coordinate space to search
        within for the needle.

        self.width: The total x width of the coordinate space to search
        within for the needle (going right from self.left).

        self.height: The total y height of the coordinate space to
        search within for the needle (going down from left.top).
    """

    def __init__(self, left, top, width, height, haystack=0, grayscale=False):
        self.haystack = haystack
        self.grayscale = grayscale
        self.left = left
        self.top = top
        self.width = width
        self.height = height

    def mlocate(self, needle, loctype='regular', conf=0.95):
        """Searches the haystack image for the needle image, returning a
        tuple containing the needle's XY coordinates within the
        haystack. If a haystack image is not provided, this function
        searches the entire client window.

        Arguments:
            needle: The image to search within the haystack or
            left/top/width/height coordinate space for. Must be a
            filepath.

            loctype (default = 'regular'): The method and/or haystack
            used to search for images. If a haystack is provided, this
            parameter is ignored.

                regular: Searches the client window. If the needle is
                found, returns the needle's left, top, width, and
                height.

                center: Searches the client window. If the needle is
                found, returns the XY coordinates of its center,
                relative to the coordinate plane of the haystack
                image.

            conf (default = 0.95): The confidence value required to
            match the image successfully. This is used by Pyautogui.

        Returns:
            If the needle is found, returns the needle as a PIL image
            object. If the needle is not found, returns 1.
        """

        if self.haystack != 0:
            target_image = pag.locate(needle,
                                      self.haystack,
                                      confidence=conf,
                                      grayscale=self.grayscale)
            if target_image is not None:
                log.debug('Found needle: ' + str(needle) +
                          ' in haystack: ' + str(self.haystack) + ', ' +
                          str(target_image))
                return target_image

            else:
                log.debug('Cannot find needle: ' + str(needle) +
                         ' in haystack: ' + str(self.haystack) + ', ' +
                         str(target_image) + ', conf=' + str(conf))
                return 1

        if self.haystack == 0 and loctype == 'regular':
            target_image = pag.locateOnScreen(needle,
                                              confidence=conf,
                                              grayscale=self.grayscale,
                                              region=(self.left,
                                                      self.top,
                                                      self.width,
                                                      self.height))
            if target_image is not None:
                log.debug('Found regular image ' + str(needle) + ', ' +
                          str(target_image))
                return target_image

            elif target_image is None:
                log.debug('Cannot find regular image ' + str(needle) +
                         ' conf=' + str(conf))
                return 1

        if self.haystack == 0 and loctype == 'center':
            target_image = pag.locateCenterOnScreen(needle,
                                                    confidence=conf,
                                                    grayscale=self.grayscale,
                                                    region=(self.left,
                                                            self.top,
                                                            self.width,
                                                            self.height))
            if target_image is not None:
                log.debug('Found center of ' + str(needle) + ', ' +
                          str(target_image))
                return target_image

            elif target_image is None:
                log.debug('Cannot find center of ' + str(needle) +
                         ', conf=' + str(conf))
                return 1

        else:
            raise RuntimeError('Incorrect mlocate function parameters!')

    def wait_for_image(self, needle, loctype='regular', conf=0.95,
                       loop_num=10, loop_sleep_min=10, loop_sleep_max=1000):
        """
        Repeatedly searches within the haystack or coordinate space
        for the needle.

        Arguments:
            needle: See mlocate()'s docstring.
            loctype (default = 'regular'): see mlocate()'s docstring.
            conf (default = 0.95): See mlocate()'s docstring.

            loop_num (default = 10): The number of times to search for
            the needle before giving up.

            loop_sleep_min (default = 10): The minimum number of
            miliseconds to wait after each search attempt.

            loop_sleep_max (default = 1000): The maximum number of
            miliseconds to wait after wach search attempt.

        Returns:
            See mlocate()'s docstring.
        """

        # log.debug('Looking for ' + str(needle))

        for tries in range(1, (loop_num + 1)):

            target_image = Vision.mlocate(self,
                                          conf=conf,
                                          needle=needle,
                                          loctype=loctype)

            if target_image == 1:
                log.debug('Cannot find ' + str(needle) + ', tried '
                            + str(tries) + ' times.')
                misc.sleep_rand(loop_sleep_min, loop_sleep_max)

            else:
                log.debug('Found ' + str(needle) + ' after trying '
                          + str(tries) + ' times.')
                return target_image

        log.debug('Timed out looking for ' + str(needle) + '.')
        return 1

    def click_image(self, needle, button='left', conf=0.95,
                    loop_num=25, loop_sleep_min=10, loop_sleep_max=1000,
                    click_sleep_before_min=0, click_sleep_before_max=500,
                    click_sleep_after_min=0, click_sleep_after_max=500,
                    move_duration_min=50, move_duration_max=1500):
        """
        Moves the mouse to the provided needle image and clicks on
        it. If a haystack is provided, searches for the provided needle
        image within the haystack. If a haystack or set of coordinates
        is not provided, searches within the entire display.

        Arguments:
            button: The mouse button to use when clicking on the needle.

            needle: See mlocate()'s docstring.
            conf (default = 0.95): See mlocate()'s docstring.

            loop_num (default = 10): See wait_for_image()'s docstring.
            loop_sleep_min (default = 10): See wait_for_image()'s
            docstring.
            loop_sleep_max (default = 1000): See wait_for_image()'s
            docstring.

        Returns:
            See mlocate()'s docstring.
        """

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
            (left, top, width, height) = target_image
            # Randomize the location the pointer will move to using the
            #   dimensions of needle image.
            input.move_to(left, top,
                          xmin=0, xmax=width,
                          ymin=0, ymax=height,
                          duration_min=move_duration_min,
                          duration_max=move_duration_max)

            log.debug('Clicking on ' + str(needle) + '.')

            input.click(button=button,
                        sleep_before_min=click_sleep_before_min,
                        sleep_before_max=click_sleep_before_max,
                        sleep_after_min=click_sleep_after_min,
                        sleep_after_max=click_sleep_after_max)
            return 0

    def drop_all_item(self, item):
        """
        Drops all instances of the given inventory item.
        """

        # TODO: Use LocateAllOnScreen to make dropping items faster.
        item_to_drop = self.wait_for_image(needle=item)
        log.info('Dropping items.')
        log.debug('Dropping' + str(item) + '.')

        while item_to_drop != 1:
            pag.keyDown('shift')
            item_to_drop = self.click_image(loop_num=1,
                                            click_sleep_before_min=0,
                                            click_sleep_before_max=100,
                                            move_duration_min=5,
                                            move_duration_max=500,
                                            needle=item)
            pag.keyUp('shift')
            misc.sleep_rand(100, 1000)
        return 0

