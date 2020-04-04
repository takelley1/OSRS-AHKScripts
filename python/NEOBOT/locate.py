# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import sys
import pyautogui as pag
from src.vars import originx, originy, windowx, windowy


def mlocate(needle, haystack=0, conf=0.95, loctype='l', grayscale=False):
    
    """Searches the haystack image for the needle image, returning a tuple
    of the needle's coordinates within the haystack. If a haystack image is
    not provided, searches the client window or the overview window,
    as specified by the loctype parameter.
    parameters:
    
        needle: The image to search for. Must be a PIL image object.
        
        haystack: The image to search within. By default this is not set,
                  causing the mlocate function to capture and search the client
                  window.
        
        conf: The confidence value required to match the image successfully.
              By default this is 0.95.
        
        loctype: The method and/or haystack used to search for images. If a
                 haystack is provided, this parameter is not used.
        
            l: Search the client window. If the needle is found, return '1'.
            
            c: Search the client window for the needle and obtain its xy center
               coordinates. If the needle is found, return the coordinates of its
               center, relative to the coordinate plane of the haystack's resolution.
               
            o: Same as 'l', except searches only within the client's overview, assuming
               it's attached on the right side of the client window.
            
            oc: Same as 'c', but searches only within the client's overivew.
            
        grayscale: Convert the haystack to grayscale before searching within it. Speeds up
                   searching by about 30%. Defaults to False."""
    
    if haystack != 0:
        locate_var = pag.locate(needle, haystack, confidence=conf,
                                grayscale=grayscale)
        if locate_var is not None:
            logging.debug('found needle  ' + (str(needle)) +
                          ' in haystack' + (str(haystack)) + ', ' +
                          (str(locate_var)))
            return locate_var
        else:
            logging.debug('cant find needle  ' + (str(needle)) +
                          ' in haystack' + (str(haystack)) + ', ' +
                          (str(locate_var)) + ', conf=' + (str(conf)))
            return 0

    if haystack == 0 and loctype == 'l':  # 'l' for regular 'locate'
        locate_var = pag.locateOnScreen(needle, confidence=conf, region=(
            originx, originy, windowx, windowy), grayscale=grayscale)
        if locate_var is not None:
            logging.debug('found l image ' + (str(needle)) + ', ' + (str(
                locate_var)))
            # If the center of the image is not needed, don't return any
            # coordinates.
            return 1
        elif locate_var is None:
            logging.debug('cannot find l image ' + (
                    str(needle) + ' conf=' + (str(conf))))
            return 0

    if haystack == 0 and loctype == 'c':  # 'c' for 'center'
        locate_var = pag.locateCenterOnScreen(needle, confidence=conf, region=(
            originx, originy, windowx, windowy), grayscale=grayscale)
        if locate_var is not None:
            logging.debug('found c image ' + (str(needle)) + ', ' + (str(
                locate_var)))
            # Return the xy coordinates for the center of the image, relative to
            # the coordinate plane of the haystack.
            return locate_var
        elif locate_var is None:
            logging.debug('cannot find c image ' + (
                    str(needle) + ', conf=' + (str(conf))))
            return 0

    if haystack == 0 and loctype == 'o':  # 'o' for 'overview'
        overviewx = (originx + (windowx - (int(windowx / 3.8))))
        overviewlx = (int(windowx / 3.8))
        locate_var = pag.locateOnScreen(needle, confidence=conf, region=(
            overviewx, originy, overviewlx, windowy), grayscale=grayscale)
        if locate_var is not None:
            logging.debug('found o image ' + (str(needle)) + ', ' + (str(
                locate_var)))
            return 1
        elif locate_var is None:
            logging.debug('cannot find o image ' + (
                    str(needle) + ', conf=' + (str(conf))))
            return 0

    if haystack == 0 and loctype == 'co':  # 'co' for 'center of overview'
        overviewx = (originx + (windowx - (int(windowx / 3.8))))
        overviewlx = (int(windowx / 3.8))
        locate_var = pag.locateCenterOnScreen(needle, confidence=conf, region=(
            overviewx, originy, overviewlx, windowy), grayscale=grayscale)
        if locate_var is not None:
            logging.debug('found co image ' + (str(needle)) + ', ' + (str(
                locate_var)))
            return locate_var
        elif locate_var is None:
            logging.debug('cannot find co image ' + (
                    str(needle) + ', conf=' + (str(conf))))
            return 0

    else:
        logging.critical('incorrect function parameters')
        sys.exit()
