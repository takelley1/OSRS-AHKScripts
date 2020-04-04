# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import random
import time
import pyautogui as pag
from src import keyboard as key, locate as lo, mouse, navigation as nav
from src.navigation import wait_for_dock
from src.vars import originx, originy, windowx, windowy, conf


def set_dest():
    """Issues a 'set destination' command for the lowest-numbered bookmark that
    isn't blacklisted."""
    target_dest = 1
    dest = lo.mlocate('./img/dest/dest' + (str(target_dest)) + '.bmp',
                      conf=0.98, loctype='c')

    while dest == 0:
        target_dest += 1
        logging.debug('looking for dest ' + (str(target_dest)))
        dest = lo.mlocate('./img/dest/dest' + (str(target_dest)) + '.bmp',
                          conf=0.98, loctype='c')

    if dest != 0:
        logging.debug('setting destination waypoint')
        (x, y) = dest
        pag.moveTo((x + (random.randint(-1, 200))),
                   (y + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click_right()
        pag.moveRel((0 + (random.randint(10, 80))),
                    (0 + (random.randint(20, 25))),
                    mouse.duration(), mouse.path())
        mouse.click()
        time.sleep(float(random.randint(1000, 2000)) / 1000)
        return


def is_home():
    """Checks if the ship is at its home station by looking for a
    gree bookmark starting with '000'."""
    if lo.mlocate('./img/dest/at_dest0.bmp') == 0:
        logging.debug('not at home station')
        return 0
    elif lo.mlocate('./img/dest/at_dest0.bmp') != 0:
        logging.debug('at home station')
        return 1


def set_home():
    """Sets destination to the first bookmark beginning with '000'."""
    home = lo.mlocate('./img/dest/dest0.bmp', loctype='c')
    if home != 0:
        logging.debug('setting home waypoint')
        (x, y) = home
        pag.moveTo((x + (random.randint(-1, 200))),
                   (y + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click_right()
        pag.moveRel((0 + (random.randint(10, 80))),
                    (0 + (random.randint(20, 25))),
                    mouse.duration(), mouse.path())
        mouse.click()
        return 1
    else:
        logging.error('could not find home waypoint!')
        return 0


def iterate_through_bookmarks_rand(total_site_num):
    """Randomly attempts to warp to any bookmark up to the provided number.

    Ex: try warping to bookmark X in the system. If bookmark X doesn't exist,
    is not in the current system, or your ship is already there, try warping
    to bookmark Y in the system."""
    target_site_num = (random.randint(1, total_site_num))

    for iterations in range(1, (total_site_num + 10)):
        warping_to_bookmark = warp_to_local_bookmark(target_site_num)
        
        if warping_to_bookmark == 1:
            if nav.wait_for_warp_to_complete() == 1:
                return 1
        
        if warping_to_bookmark == 0:
            target_site_num = (random.randint(1, total_site_num))

    # If script randomly checks (total_site_num + 10) bookmarks, give up.
    logging.error('failed to warp')
    return 0


def iterate_through_bookmarks(target_site_num, total_site_num):
    """Tries warping to the target bookmark. If not possible, warps
    to the next consecutive bookmark by number, up to the total
    number of bookmarks.

    Ex: try warping to bookmark X in the system. If bookmark X doesn't exist,
    is not in the current system, or your ship is already there. try
    warping to bookmark X+1."""

    # Try running through bookmarks multiple times before giving up.
    for iterations in range(1, 4):
        warping_to_bookmark = warp_to_local_bookmark(target_site_num)

        for tries in range((target_site_num - 1), total_site_num):
            if warping_to_bookmark == 1:
                # Once a valid site is found, remember the site number the
                # ship is warping to so script doesn't try warping there again.
                if nav.wait_for_warp_to_complete() == 1:
                    return 1

        # If script runs out of bookmarks to check for, it resets the target
        # site to 1 and goes through them again until the 'for' loop completes.
        logging.debug('out of sites to check for, starting over' +
                      (str(iterations)))

    logging.error('gave up looking for sites to warp to!')
    return 0
   

def warp_to_local_bookmark(target_site_num):
    """Tries warping to the provided target bookmark, assuming the bookmark
    is in the current system. If the ship is already at or near the
    requested bookmark, return the function."""
    # Confidence must be >0.95 because script will confuse 6 with 0.
    target_site_bookmark = lo.mlocate('./img/dest/at_dest' + (str(
        target_site_num)) + '.bmp', conf=0.98, loctype='c')

    if target_site_bookmark != 0:
        (x, y) = target_site_bookmark
        pag.moveTo((x + (random.randint(10, 200))),
                   (y + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click_right()
        approach_location = lo.mlocate(
            './img/buttons/detect_warp_to_bookmark.bmp', conf=0.90)

        # If the 'approach location' option is found in the right-click
        # menu, the ship is already near the bookmark.
        if approach_location != 0:
            logging.debug('already at bookmark ' + (str(target_site_bookmark)))
            key.keypress('esc')  # Close right-click menu.
            return 0

        # If the 'approach location' option is not found, look for a 'warp
        # to' option and select it.
        elif approach_location == 0:
            warp_to_site = lo.mlocate('./img/buttons/warp_to_bookmark.bmp',
                                      conf=0.90, loctype='c')

            if warp_to_site != 0:
                logging.info(
                    'warping to bookmark ' + (str(target_site_bookmark)))
                pag.moveRel((0 + (random.randint(10, 80))),
                            (0 + (random.randint(10, 15))),
                            mouse.duration(), mouse.path())
                mouse.click()
                time.sleep(float(random.randint(1500, 1800)) / 1000)
                return 1
            elif warp_to_site == 0:
                logging.error('unable to warp to target site, is ship docked?')
                return 0


def dock_at_local_bookmark():
    """Docks at the first bookmark beginning with a '0' in its name,
    assuming it's in the same system as you and the bookmark is a station."""
    dock = lo.mlocate('./img/dest/at_dest0.bmp', loctype='c')
    if dock != 0:
        (x, y) = dock
        pag.moveTo((x + (random.randint(-1, 200))),
                   (y + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click_right()

        pag.moveRel((0 + (random.randint(10, 80))),
                    (0 + (random.randint(35, 40))),
                    mouse.duration(), mouse.path())
        # Sleep used to fix bug in which client doesn't immediately
        # highlight 'dock' after opening right-click menu.
        # (see video 2019-07-06_13-26-14 at 33m50s for bug).
        time.sleep(float(random.randint(700, 1000)) / 1000)
        mouse.click()
        wait_for_dock()


def detect_bookmark_location():
    """Checks if any bookmarks are green, indicating that the bookmark is in the
    ship's current system."""
    global n
    n = 0
    # Confidence must be higher than normal or script mistakes dest3 for dest2.
    at_dest = lo.mlocate('./img/dest/at_dest' + (str(n)) + '.bmp', conf=0.98,
                         loctype='c')

    while at_dest == 0:
        n += 1
        logging.debug('looking if at destination ' + (str(n)))
        at_dest = lo.mlocate('./img/dest/at_dest' + (str(n)) + '.bmp',
                             conf=0.98, loctype='c')

        if n == 9 and at_dest == 0:
            print('out of destinations to look for')
            return -1
    if at_dest != 0:
        logging.debug('at dest ' + (str(n)))
        return n


# The below blacklisting functions have had little testing.


def blacklist_station():
    """Blacklists the first green bookmark by editing its name.
    This will prevent other functions from identifying the bookmark
    as a potential site."""
    at_dest = detect_bookmark_location()
    if at_dest != 0:
        logging.debug('blacklisting station')
        at_dest = pag.locateCenterOnScreen(
            ('./img/dest/at_dest' + (str(n)) + '.bmp'),
            confidence=conf,
            region=(originx, originy, windowx, windowy))

        (at_destx), (at_desty) = at_dest
        pag.moveTo((at_destx + (random.randint(-1, 200))),
                   (at_desty + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())

        time.sleep(float(random.randint(1000, 2000)) / 1000)
        mouse.click()
        # Click once to focus entry, then double-click the entry to edit.
        time.sleep(float(random.randint(1000, 2000)) / 1000)
        mouse.click()
        time.sleep(float(random.randint(5, 50)) / 1000)
        mouse.click()
        time.sleep(float(random.randint(3000, 4000)) / 1000)
        pag.keyDown('home')
        time.sleep(float(random.randint(0, 500)) / 1000)
        pag.keyUp('home')
        time.sleep(float(random.randint(0, 1000)) / 1000)
        pag.keyDown('b')
        # Add a 'b' to beginning of the name indicating site is blacklisted.
        pag.keyUp('b')
        time.sleep(float(random.randint(0, 1000)) / 1000)
        pag.keyDown('enter')
        time.sleep((random.randint(0, 200)) / 100)
        pag.keyUp('enter')
        return


def blacklist_local_bookmark():
    """Determines which bookmark ship is at by looking at the right-click
    menu. If a bookmark is on grid with the user's ship, blacklist the
    bookmark by editing its name."""
    logging.debug('blacklisting local bookmark')

    # First check to see if the bookmark even exists.
    bookmark = 1
    bookmark_to_blacklist = pag.locateCenterOnScreen(
        ('./img/dest/at_dest' + (str(bookmark)) + '.bmp'),
        confidence=0.95,
        region=(originx, originy, windowx, windowy))

    # If bookmark exists, check right-click menu.
    while bookmark_to_blacklist != 0:

        bookmark_to_blacklist = pag.locateCenterOnScreen(
            ('./img/dest/at_dest' + (str(bookmark)) + '.bmp'),
            confidence=0.95,
            region=(originx, originy, windowx, windowy))

        if bookmark_to_blacklist != 0:

            (bookmark_to_blacklistx), (
                bookkmark_to_blacklisty) = bookmark_to_blacklist
            pag.moveTo((bookmark_to_blacklistx + (random.randint(-1, 200))),
                       (bookkmark_to_blacklisty + (random.randint(-3, 3))),
                       mouse.duration(), mouse.path())

            # Right-click on bookmark to check if an 'approach location'
            # option is available. If it is, blacklist bookmark. If it
            # isn't, try another bookmark.
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            mouse.click_right()
            time.sleep(float(random.randint(1000, 2000)) / 1000)

            at_bookmark = pag.locateCenterOnScreen(
                './img/buttons/detect_warp_to_bookmark.bmp',
                confidence=0.90,
                region=(originx, originy, windowx, windowy))

            # If 'approach location' is present, blacklist that bookmark.
            if at_bookmark != 0:
                logging.debug('blacklisting bookmark ' + (str(bookmark)))
                time.sleep(float(random.randint(1000, 2000)) / 1000)
                key.keypress('esc')
                mouse.click()
                # Click once to focus entry, then double-click the entry to
                # edit.
                time.sleep(float(random.randint(1000, 2000)) / 1000)
                mouse.click()
                time.sleep(float(random.randint(50, 100)) / 1000)
                mouse.click()
                time.sleep(float(random.randint(3000, 4000)) / 1000)
                pag.keyDown('home')
                time.sleep(float(random.randint(0, 500)) / 1000)
                pag.keyUp('home')
                time.sleep(float(random.randint(0, 1000)) / 1000)
                pag.keyDown('b')
                # Add a 'b' to beginning of the name indicating site
                # is blacklisted.
                pag.keyUp('b')
                time.sleep(float(random.randint(0, 1000)) / 1000)
                pag.keyDown('enter')
                time.sleep((random.randint(0, 200)) / 100)
                pag.keyUp('enter')
                return 1

            # If 'approach location' is not present,
            # close the right-click menu and check the next bookmark.
            if at_bookmark == 0:
                logging.debug('not at bookmark ' + (str(bookmark)))
                key.keypress('esc')
                bookmark += 1
                continue

        elif bookmark_to_blacklist == 0:
            logging.warning('out of bookmarks to look for')
            return 0


def blacklist_set_bookmark(target_site):
    """Blacklist a specific bookmark by changing its name."""
    # TODO: possibly blacklist bookmarks instead by deleting them, which
    # could lead to fewer bugs as sometimes the 'rename bookmark' window
    # does not behave consistently.
    logging.debug('blacklisting bookmark ' + (str(target_site)))
    bookmark_to_blacklist = pag.locateCenterOnScreen(
        ('./img/dest/at_dest' + (str(target_site)) + '.bmp'),
        confidence=conf,
        region=(originx, originy, windowx, windowy))

    (bookmark_to_blacklistx), (bookmark_to_blacklisty) = bookmark_to_blacklist
    pag.moveTo((bookmark_to_blacklistx + (random.randint(-1, 200))),
               (bookmark_to_blacklisty + (random.randint(-3, 3))),
               mouse.duration(), mouse.path())

    time.sleep(float(random.randint(1000, 2000)) / 1000)
    # Multiple clicks to focus the text input field.
    mouse.click()
    time.sleep(float(random.randint(1000, 2000)) / 1000)
    mouse.click()
    time.sleep(float(random.randint(5, 50)) / 1000)
    mouse.click()
    time.sleep(float(random.randint(3000, 4000)) / 1000)
    key.keypress('home')
    key.keypress('b')
    time.sleep(float(random.randint(0, 1000)) / 1000)
    key.keypress('enter')
    return 1
