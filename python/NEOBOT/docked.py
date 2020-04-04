# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import random
import sys
import time
import traceback
import pyautogui as pag
from src import keyboard as key, locate as lo, mouse

logging.basicConfig(format='(%(asctime)s) %(funcName)s - %('
                           'message)s', level=logging.DEBUG)


def is_docked():
    """Checks if the ship is currently docked by looking for the undock
     button."""
    if lo.mlocate('./img/buttons/undock.bmp') == 0:
        logging.debug('not docked')
        return 0
    else:
        logging.debug('docked')
        return 1


def open_ship_inv():
    """Clicks on the ship's inventory button within the inventory window.
    Assumes the ship is docked and the inventory window is already open."""
    logging.debug('opening ship inventory')
    for tries in range(1, 25):
        ship_inv = lo.mlocate('./img/buttons/ship_inv.bmp', loctype='c')
        if ship_inv != 0:
            (x, y) = ship_inv
            pag.moveTo((x + (random.randint(-4, 50))),
                       (y + (random.randint(-6, 6))),
                       mouse.duration(), mouse.path())
            mouse.click()
            return 1

        elif ship_inv == 0:
            logging.error('cannot find ship inventory ' + (str(tries)))
            time.sleep(float(random.randint(500, 2000)) / 1000)

    logging.error('timed out looking for ship inventory')
    return 0


def open_specinv(invtype):
    """Opens the ship's specified special inventory
    (for storing ore, minerals, planetary products etc.)
    Assumes the ship is docked and the inventory window is already open."""
    logging.debug('opening ' + invtype + ' inventory')
    for tries in range(1, 25):
        spec_inv = lo.mlocate('./img/buttons/spec_inv_' + invtype + '.bmp',
                              loctype='c')
        if spec_inv != 0:
            (x, y) = spec_inv
            pag.moveTo((x + (random.randint(-4, 50))),
                       (y + (random.randint(-3, 3))),
                       mouse.duration(), mouse.path())
            mouse.click()
            return 1

        if spec_inv == 0:
            logging.error('cannot find ' + invtype + ' inventory ' +
                          (str(tries)))
            time.sleep(float(random.randint(500, 2000)) / 1000)

    logging.error('timed out looking for ' + invtype + ' inventory')
    return 0


def open_station_inv():
    """Clicks on the station inventory button within the main inventory window.
    Assumes the ship is docked and the inventory window is already open."""
    logging.debug('opening station inventory')
    for tries in range(1, 25):
        station_inv = lo.mlocate('./img/buttons/station_inv.bmp', loctype='c')

        if station_inv != 0:
            (x, y) = station_inv
            pag.moveTo((x + (random.randint(-6, 50))),
                       (y + (random.randint(-6, 6))),
                       mouse.duration(), mouse.path())
            mouse.click()
            return 1

        if station_inv == 0:
            logging.error('cannot find station inventory icon ' + (str(tries)))
            time.sleep(float(random.randint(500, 2000)) / 1000)

    logging.error('timed out looking for station inventory')
    return 0


def focus_inv_window():
    """Clicks somewhere inside the station inventory window to focus it.
    Looks for the sorting buttons in top right corner
    of the inventory window and positions the mouse cursor relative to those
    buttons to click an inavtive area within the inventory window."""
    tries = 0
    window = lo.mlocate('./img/buttons/station_sorting.bmp', loctype='c')

    while window == 0 and tries <= 25:
        logging.error('cannot find sorting icon ' + (str(tries)))
        tries += 1
        time.sleep(float(random.randint(500, 2000)) / 1000)
        window = lo.mlocate('./img/buttons/station_sorting.bmp', loctype='c')

    if window != 0 and tries <= 25:
        (x, y) = window
        pag.moveTo((x - (random.randint(0, 250))),
                   (y + (random.randint(60, 300))),
                   mouse.duration(), mouse.path())
        mouse.click()
        return 1
    elif tries > 25:
        logging.error('timed out looking for sorting buttons')
        return 0


def look_for_specinv(invtype):
    """Looks for different kinds of special inventory icons on your ship."""
    if lo.mlocate('./img/buttons/spec_inv_' + invtype + '.bmp') != 0:
        logging.debug('found ' + (str(invtype)) + ' inventory')
        return 1
    else:
        return 0


def specinv_warning():
    """Look for a popup indicating the selected inventory items aren't
    compatible with the ship's special inventory. This warning is partially
    transparent so confidence rating must be slightly lower than normal."""
    if lo.mlocate('./img/popups/spec_inv.bmp', conf=0.8) != 0:
        logging.debug('detected special inventory warning')
        return 1
    else:
        logging.debug('no special inventory warning')
        return 0


def set_quant_warning():
    """Check if a 'set quantity' window appears, indicating there isn't enough
    space in the ship's inventory for a full item stack."""

    if lo.mlocate('./img/popups/set_quant.bmp', conf=0.85) != 0:
        logging.debug('detected set quantity warning')
        time.sleep(float(random.randint(100, 800)) / 1000)
        pag.keyDown('enter')
        time.sleep(float(random.randint(5, 100)) / 1000)
        pag.keyUp('enter')
        return 1
    else:
        logging.debug('no set quantity warning')
        return 0


def not_enough_space_warning():
    """Checks if a 'not enough space' warning appears, indicating the item
    stacks selected will not fit into the ship's inventory, or inventory is
    already full."""
    if lo.mlocate('./img/warnings/not_enough_space.bmp') != 0:
        logging.debug('detected not enough space warning')
        time.sleep(float(random.randint(100, 800)) / 1000)
        pag.keyDown('enter')
        time.sleep(float(random.randint(5, 100)) / 1000)
        pag.keyUp('enter')
        return 1
    else:
        logging.debug('no not enough space warning')
        return 0


def wait_for_undock():
    """Undock from the station with the default hotkey. The undock_loop has been
    completed once the script sees the cyan ship icon in the top left corner
    of the client window, indicating a session change has just ocurred."""
    logging.info('undocking')
    pag.keyDown('ctrl')
    time.sleep(float(random.randint(100, 800)) / 1000)
    key.keypress('u')
    time.sleep(float(random.randint(100, 800)) / 1000)
    pag.keyUp('ctrl')

    # Wait for the 'undock' button to change to 'undocking', indicating the
    # undock action has been confirmed.
    tries = 0

    while lo.mlocate('./img/buttons/undocking.bmp', conf=0.8, loctype='o') \
            == 0 and tries <= 250:
        tries += 1
        logging.debug('waiting for session change to begin ' + (str(tries)))
        time.sleep(int((random.randint(100, 200) / 1000)))

    if lo.mlocate('./img/buttons/undocking.bmp', conf=0.8, loctype='o') != 0 \
            and tries <= 250:
        logging.debug('session change underway ' + (str(tries)))

        # Now wait for the undock to complete by looking for the session
        # change indicator.
        tries = 0

        while lo.mlocate('./img/indicators/session_change_undocked.bmp',
                         conf=0.55) == 0 and tries <= 100:
            tries += 1
            time.sleep(int((random.randint(500, 2000) / 1000)))
            logging.debug('waiting for session change to complete ' +
                          (str(tries)))

        if lo.mlocate('./img/indicators/session_change_undocked.bmp',
                      conf=0.55) != 0 and tries <= 100:
            logging.debug('undock completed ' + (str(tries)))
            return 1

        # If script times out waiting for the session change icon, simply
        # look for the undock button instead since ship has likely completed
        # an undock, but at this point the session change icon is probably
        # gone.
        elif lo.mlocate('./img/indicators/session_change_undocked.bmp',
                        conf=0.55) == 0 and tries > 100:
            if is_docked() == 1:
                logging.error('cannot undock')
                sys.exit()
            elif is_docked() == 0:
                logging.warning('undock tentatively completed')
                return 1
    elif lo.mlocate('./img/buttons/undocking.bmp', conf=0.9) == 0 and \
            tries > 25:
        logging.error('timed out waiting for session change')
        sys.exit()


def drag_to_ship_inv():
    """Click and drag the first item stack from station's inventory to ship's
    inventory. This function assumed the relevant window is already open."""
    logging.debug('moving item stack to ship inventory')

    station_inv = lo.mlocate('./img/indicators/station_inv_name.bmp',
                             loctype='c')
    if station_inv == 0:
        logging.critical("can't find name column")
        traceback.print_exc()
        traceback.print_stack()
        sys.exit()

    else:
        tries = 0
        ship_inv = lo.mlocate('./img/buttons/ship_inv.bmp', loctype='c')
        while ship_inv == 0 and tries <= 25:
            tries += 1
            logging.critical("can't find ship inventory")
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            ship_inv = lo.mlocate('./img/buttons/ship_inv.bmp', loctype='c')

        if ship_inv != 0 and tries <= 25:
            (x, y) = station_inv
            (sx, sy) = ship_inv
            pag.moveTo((x + (random.randint(-5, 250))),
                       (y + (random.randint(10, 25))),
                       mouse.duration(), mouse.path())
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.mouseDown()
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.moveTo((sx + (random.randint(-5, 60))),
                       (sy + (random.randint(-8, 8))),
                       mouse.duration(), mouse.path())
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.mouseUp()
            return


def drag_to_ship_specinv(invtype):
    """Drag item stack to ship's special inventory."""
    logging.debug('moving item stack to special inventory')

    station_inv = lo.mlocate('./img/indicators/station_inv_name.bmp',
                             loctype='c')
    if station_inv != 0:
        tries = 0
        spec_inv = lo.mlocate('./img/buttons/spec_inv_' + invtype + '.bmp',
                              loctype='c')
        while spec_inv == 0 and tries <= 25:
            tries += 1
            logging.critical("can't find ship inventory")
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            spec_inv = lo.mlocate('./img/buttons/spec_inv_' + invtype + '.bmp',
                                  loctype='c')

        if spec_inv != 0 and tries <= 25:
            (x, y) = station_inv
            (sx, sy) = spec_inv
            pag.moveTo((x + (random.randint(-5, 250))),
                       (y + (random.randint(10, 25))),
                       mouse.duration(), mouse.path())
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.mouseDown()
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.moveTo((sx + (random.randint(-15, 40))),
                       (sy + (random.randint(-3, 3))),
                       mouse.duration(), mouse.path())
            time.sleep(float(random.randint(0, 1000)) / 1000)
            pag.mouseUp()
            return
    else:
        logging.critical("can't find name column")
        traceback.print_exc()
        traceback.print_stack()
        sys.exit()


def load_ship_bulk():
    """Load ship by selecting all item stacks and moving all stacks at once."""
    logging.debug('beginning bulk loading procedure')

    if lo.mlocate('./img/indicators/station_inv_0_items.bmp', conf=0.9) == 1:
        return 0

    else:
        focus_inv_window()
        key.hotkey('ctrl', 'a')
        drag_to_ship_inv()

        time.sleep(float(random.randint(1500, 3000)) / 1000)
        nospace = not_enough_space_warning()
        setquant = set_quant_warning()

        if nospace == 0 and setquant == 0:
            logging.debug('no warnings')
            return 2

        # If there isn't enough space in the main ship inventory,
        # check if it has a special inventory. Iterate through a
        # list of possible special inventory types.
        specinv_list = ['ore', 'fleet']
        if nospace == 1:
            for invtype in specinv_list:
                if look_for_specinv(invtype) == 1:
                    focus_inv_window()
                    key.hotkey('ctrl', 'a')
                    drag_to_ship_specinv(invtype)

                    time.sleep(float(random.randint(1500, 3000)) / 1000)
                    specinvwarning = specinv_warning()
                    nospace = not_enough_space_warning()
                    setquant = set_quant_warning()

                    # If no warnings appear, look for more item stacks,
                    # just to be sure the station is empty.
                    if specinvwarning == 0 and setquant == 0 and nospace == 0:
                        if lo.mlocate(
                                './img/indicators/station_inv_0_items.bmp',
                                conf=0.9) == 0:
                            logging.debug('more items remaining')
                            return 0
                        else:
                            logging.debug('station empty')
                            return 2

                    elif specinvwarning == 0 and setquant == 1 and nospace \
                            == 0:
                        logging.debug('cannot load in bulk')
                        return 1

                    else:
                        return 0
                else:
                    return 0
        else:
            return 0


def load_ship_individual():
    """Load ship one item stack at a time."""
    logging.debug('beginning individual loading procedure')
    open_station_inv()
    noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp', conf=0.9)

    while noitems == 0:
        focus_inv_window()
        drag_to_ship_inv()

        time.sleep(float(random.randint(1000, 3000)) / 1000)
        nospace = not_enough_space_warning()
        setquant = set_quant_warning()
        print(nospace, setquant)

        if nospace == 0 and setquant == 0:
            drag_to_ship_inv()

            time.sleep(float(random.randint(1500, 3000)) / 1000)
            nospace = not_enough_space_warning()
            setquant = set_quant_warning()
            noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp',
                                 conf=0.9)

        elif nospace == 0 and setquant == 1:
            return 1

        # If a warning appears but item stacks are still present, check if ship
        # has a special inventory.
        specinv_list = ['ore', 'fleet']
        if nospace == 1:
            for invtype in specinv_list:
                noitems = lo.mlocate(
                    './img/indicators/station_inv_0_items.bmp', conf=0.9)
                if look_for_specinv(invtype) == 1:
                    drag_to_ship_specinv(invtype)

                    time.sleep(float(random.randint(1500, 3000)) / 1000)
                    specinvwarning = specinv_warning()
                    nospace = not_enough_space_warning()
                    setquant = set_quant_warning()
                    noitems = lo.mlocate(
                        './img/indicators/station_inv_0_items.bmp', conf=0.9)

                    while specinvwarning == 0 and setquant == 0 \
                            and nospace == 0 and noitems == 0:
                        drag_to_ship_specinv(invtype)

                        time.sleep(float(random.randint(1500, 3000)) / 1000)
                        specinvwarning = specinv_warning()
                        nospace = not_enough_space_warning()
                        setquant = set_quant_warning()
                        noitems = lo.mlocate(
                            './img/indicators/station_inv_0_items.bmp',
                            conf=0.9)

                    if noitems == 1:
                        logging.debug(
                            'done loading' + (str(invtype)) + 'inventory')
                        return 2

                    elif specinvwarning == 1 or setquant == 1 or nospace == 1:
                        logging.debug('items remain')
                        return 1
                    else:
                        logging.debug('station empty')
                        return 2
                else:
                    logging.debug('items remain')
                    return 1
        else:
            logging.debug('station empty')
            return 2
    if noitems == 1:
        logging.debug('station empty')
        return 2


def load_ship():
    """Utilize both individual and bulk loading functions to load ship."""
    open_station_inv()
    noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp', conf=0.9)

    if noitems == 0:
        lsb = load_ship_bulk()
        if lsb == 2:
            logging.debug('ship loaded entire station inventory')
            return 2

        elif lsb == 1:
            logging.debug('ship is full and station inventory has more items')
            return 1

        elif lsb == 0:
            lsi = load_ship_individual()
            if lsi == 2:
                logging.debug('ship loaded entire station inventory')
                return 2

            elif lsi == 1:
                logging.debug('ship is full and station inventory has more  '
                              'items')
                return 1

    elif noitems == 1:
        return 0


def unload_ship():
    """Unloads ship inventory and deposits it in the station's inventory."""
    logging.debug('began unloading procedure')
    open_ship_inv()
    noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp', conf=0.9)

    if noitems == 0:
        time.sleep(float(random.randint(0, 2000)) / 1000)
        focus_inv_window()
        time.sleep(float(random.randint(0, 2000)) / 1000)
        key.hotkey('ctrl', 'a')
        time.sleep(float(random.randint(0, 2000)) / 1000)
        drag_items_from_ship_inv()
        time.sleep(2)
        noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp',
                             conf=0.9)

    if noitems == 1:
        logging.debug('finished unloading main inventory')

        specinv_list = ['ore', 'fleet']
        for invtype in specinv_list:
            if look_for_specinv(invtype) == 1:
                time.sleep(float(random.randint(0, 2000)) / 1000)
                open_specinv(invtype)
                noitems = lo.mlocate('./img/indicators/station_inv_0_items.bmp',
                                     conf=0.9)

                while noitems == 0:
                    time.sleep(float(random.randint(0, 2000)) / 1000)
                    focus_inv_window()
                    time.sleep(float(random.randint(0, 2000)) / 1000)
                    key.hotkey('ctrl', 'a')
                    time.sleep(float(random.randint(0, 2000)) / 1000)
                    drag_items_from_ship_inv()
                    time.sleep(float(random.randint(0, 2000)) / 1000)
                    logging.debug('finished unloading ' + (str(invtype)) +
                                  ' inventory')
                    return 1
                if noitems == 1:
                    logging.debug('finished unloading procedure')
                    return 1

            elif look_for_specinv(invtype) == 0:
                logging.debug('finished unloading procedure')
                return 1


def drag_items_from_ship_inv():
    """Clicks and drags all items from ship inventory to station inventory."""
    (x1, y1) = lo.mlocate('./img/indicators/station_inv_name.bmp', loctype='c')
    (x2, y2) = lo.mlocate('./img/buttons/station_inv.bmp', loctype='c')

    pag.moveTo((x1 + (random.randint(-5, 250))),
               (y1 + (random.randint(10, 25))),
               mouse.duration(), mouse.path())
    time.sleep(float(random.randint(0, 1000)) / 1000)
    pag.mouseDown()
    time.sleep(float(random.randint(0, 1000)) / 1000)
    pag.moveTo((x2 + (random.randint(-15, 60))),
               (y2 + (random.randint(-10, 10))),
               mouse.duration(), mouse.path())
    time.sleep(float(random.randint(0, 1000)) / 1000)
    pag.mouseUp()
    logging.debug('moved all item stacks from ship inventory')
    return
