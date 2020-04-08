# encoding: utf-8
import logging as log
import sys
import pyautogui as pag
import random as rand
from python.src import misc, mouse
from python.src.orient import client_xmax, client_ymin, client_ymax, client_xmin

log.basicConfig(format='(%(asctime)s) %(funcName)s - %(''message)s',
                level=log.DEBUG)


def m_locate(needle, haystack=0, conf=0.95, loctype='regular', grayscale=False):
    
    """Searches the haystack image for the needle image, returning a tuple
    containing the needle's XY coordinates within the haystack. If a haystack
    image is not provided, this function searches the entire client window.

    parameters:

        needle: The image to search for. Must be a filepath.

        haystack (default = 0): The image to search within for the needle.
                                If this is 0, the function will search the
                                client window.

        conf (default = 0.95): The confidence value required to match the image
                               successfully. This is used by Pyautogui.

        loctype (default = 'regular'): The method and/or haystack used to
                                       search for images. If a haystack is
                                       provided, this parameter is ignored.

            regular: Searches the client window. If the needle is found,
                     returns '1'.

            center: Searches the client window. If the needle is found,
                    returns the XY coordinates of its center, relative to the
                    coordinate plane of the haystack image.

        grayscale (default = False): Converts the haystack to grayscale before
                                     searching within it. Speeds up searching by
                                     about 30%."""
    
    if haystack != 0:
        m_locate_var = pag.locate(needle, haystack, confidence=conf,
                                  grayscale=grayscale)
        if m_locate_var is not None:
            log.debug('Found needle: ' + (str(needle)) + ' in haystack: ' +
                      str(haystack) + ', ' + str(m_locate_var))
            return m_locate_var
        else:
            log.info('Cannot find needle: ' + str(needle) + ' in haystack: '
                      + str(haystack) + ', ' + str(m_locate_var) + ', conf='
                      + str(conf))
            return 0

    if haystack == 0 and loctype == 'regular':
        m_locate_var = pag.locateOnScreen(needle, confidence=conf, region=(
            client_xmin, client_ymin, client_xmax, client_ymax),
                                          grayscale=grayscale)
        if m_locate_var is not None:
            log.debug('Found regular image ' + str(needle) + ', ' +
                      str(m_locate_var))
            # If the center of the image is not needed, don't return any
            # coordinates.
            return 1
        elif m_locate_var is None:
            log.info('Cannot find regular image ' + str(needle) + ' conf=' +
                     str(conf))
            return 0

    if haystack == 0 and loctype == 'center':
        m_locate_var = pag.locateCenterOnScreen(needle, confidence=conf, region=(
            client_xmin, client_ymin, client_xmax, client_ymax),
                                                grayscale=grayscale)
        if m_locate_var is not None:
            log.debug('Found center of ' + str(needle) + ', ' +
                      str(m_locate_var))
            return m_locate_var
        elif m_locate_var is None:
            log.info('Cannot find center of ' + str(needle) + ', conf=' +
                     str(conf))
            return 0

    else:
        log.critical('Incorrect m_locate function parameters!')
        sys.exit(1)


def wait_for_image(needle, haystack=0, loop_num=10, loop_sleep_min=100,
                   loop_sleep_max=1000):

    log.debug('Searching for ' + str(needle))

    for tries in range(1, loop_num):
        target_image = m_locate(needle=needle, haystack=haystack,
                                loctype='center')

        if target_image != 0:
            log.debug('Found ' + str(needle) + ', after trying ' + str(tries)
                      + ' times')
            return target_image
        else:
            log.warning('Cannot find ' + str(needle) + ', tried ' + str(
                    tries) + ' times')
            misc.sleep_rand(loop_sleep_min, loop_sleep_max)

    log.error('Timed out looking for ' + str(needle))
    return 1


def click_image(needle, haystack=0, button='left', loop_num=10,
                loop_sleep_min=100, loop_sleep_max=1000, rand_xmin=3,
                rand_xmax=3, rand_ymin=3, rand_ymax=3):
    """Moves the mouse to the provided needle image and clicks on it. If a
    haystack is provided, searches for the provided image within the
    haystack. If a haystack is not provided, searches within an area defined by
    the loctype parameter.
    parameters:
        needle: a filepath to the image to search for, relative to the
        script's working directory
        haystack: the image to search for the needle within. Must be a PIL
        image variable.
        loctype: if the haystack parameter is 0, this parameter is used to
        create a haystack.
            c: (default) searches client for the xy center of the needle.
            Returns x,y coordinates
            co: Searches the overview for the xy center of the needle.
        button: the mouse button to click when the script locates the image.
        rx1 / ry1: the minimum x/y value to generate a random variable from.
        rx2 / ry2: the maximum x/y/ value to generate a random variable from."""

    log.debug('Looking for ' + str(needle) + ' to click on.')

    for tries in range(1, loop_num):
        target_image = m_locate(needle=needle, haystack=haystack,
                                loctype='center')

        if target_image != 0:
            (x, y) = target_image
            pag.moveTo((x + (rand.randint(rand_xmin, rand_xmax))),
                       (y + (rand.randint(rand_ymin, rand_ymax))),
                       mouse.move_duration(), mouse.move_path())
            mouse.click(button=button)
            log.debug('Found ' + str(needle) + ' to click on, after trying '
                      + str(tries) + ' times')
            return 0
        else:
            log.warning('Cannot find ' + str(needle) +
                        ' to click on, tried ' + str(tries) + ' times')
            misc.sleep_rand(loop_sleep_min, loop_sleep_max)

    log.error('Timed out looking for ' + str(needle) + ' to click on.')
    return 1
