# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import logging
import random
import sys
import time
import pyautogui as pag
from src import keyboard as key, locate as lo, mouse
from src.vars import originx, originy, windowx, windowy

sys.setrecursionlimit(9999999)

# TODO: function to sort overview by distance


def is_jammed(detect_jam, haystack=0):
    """Checks for an ecm-jamming icon within an especially narrow section of
    the overview. If a haystack image is provided, search within that
    instead."""
    if detect_jam == 1 and haystack == 0:
        ox_jam = (originx + (windowx - (int(windowx / 8))))
        olx_jam = (int(windowx / 8))
        # Custom region in lo.locate is useful to reduce the
        # search-space as this function is called frequently.
        if pag.locateOnScreen('./img/overview/jammed_overview.bmp',
                              region=(ox_jam, originy, olx_jam, windowy)) is \
                not None:
            logging.info('ship has been jammed!')
            return 1
        else:
            logging.debug('no jamming detected')
            return 0
        
    elif detect_jam == 1 and haystack != 0:
        if lo.mlocate('./img/overview/jammed_overview.bmp', haystack=haystack,
                      grayscale=True) != 0:
            logging.info('ship has been jammed!')
            return 1
        else:
            logging.debug('no jamming detected')
            return 0 
        
    elif detect_jam == 0:
        return 0


def build_ship_list(detect_npcs_var, npc_frig_dest, npc_cruiser_bc,
                    detect_pcs_var, pc_indy, pc_barge, pc_frig_dest,
                    pc_cruiser_bc, pc_bs, pc_capindy_freighter, pc_rookie,
                    pc_pod):
    """Builds a list of npc ship icons and a list of player ship icons,
    through which the 'look_for_ship' function can iterate and
    check if any of those icons are present in the overview."""
    npc_list = []
    if detect_npcs_var == 1:
        if npc_frig_dest == 1:
            npc_list.append(
                './img/overview/npc_ship_icons/npc_hostile_frigate.bmp')
        if npc_cruiser_bc == 1:
            npc_list.append(
                './img/overview/npc_ship_icons/npc_hostile_cruiser.bmp')
    pc_list = []
    if detect_pcs_var == 1:
        # logging.debug('detect pcs is' + (str(detect_pcs_var)))
        # logging.debug('pc bs is' + (str(pc_bs)))
        # logging.debug('pc list is' + (str(pc_list)))
        if pc_indy == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_industrial.bmp')
        if pc_barge == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_mining_barge.bmp')
        if pc_frig_dest == 1:
            pc_list.append(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_frigate_and_destroyer.bmp')
        if pc_cruiser_bc == 1:
            pc_list.append(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_cruiser_and_battlecruiser.bmp')
        if pc_bs == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_battleship.bmp')
        if pc_capindy_freighter == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_capital_industrial_and_freighter.bmp')
        if pc_rookie == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_rookie_ship.bmp')
        if pc_pod == 1:
            pc_list.append(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_capsule.bmp')
    return npc_list, pc_list


def look_for_ship(npc_list, pc_list, haystack=0):
    """Checks if any of the ship icons in the given lists are currently
    present on the overview. If a haystack image is provided, searches
    within that instead."""
    
    # Search within the rightmost quarter of the client by default.
    # Script assumes overview is on the right half of the screen.
    # This is about twice as fast as searching a 1024x768 client window.

    if haystack == 0:
        # If no haystack image is given, take and use a screenshot of the
        # overview.
        if len(npc_list) != 0 or len(pc_list) != 0:
            overview = pag.screenshot(
                region=((originx + (windowx - (int(windowx / 3.8)))),
                        originy, (int(windowx / 3.8)), windowy))

            # Only search for icons if the list has at least 1 item
            if len(npc_list) != 0:
                conf = 0.98
                for npc in npc_list:
                    npc_found = lo.mlocate(npc, haystack=overview, conf=conf)
                    if npc_found != 0:
                        logging.debug(
                            'found ' + (str(npc)) + ' at ' + (str(npc_found)))
                        # Break up the tuple so mouse can point at icon for
                        # debugging.
                        # (x, y, t, w) = hostile_npc_found
                        # Coordinates must compensate for the altered
                        # coordinate-space
                        # of the screenshot.
                        # pag.moveTo((x + (originx +
                        # (windowx - (int(windowx / 2))))),
                        #           (y + originy),
                        #           0, mouse.path())
                        return 1
                logging.debug('passed npc check')

            if len(pc_list) != 0:
                conf = 0.95
                for pc in pc_list:
                    pc_found = lo.mlocate(pc, haystack=overview, conf=conf)
                    if pc_found != 0:
                        logging.debug(
                            'found ' + (str(pc)) + ' at ' + (str(pc_found)))
                        return 1
                logging.debug('passed pc check')
                return 0
        elif len(npc_list) == 0 and len(pc_list) == 0:
            return 0
        
    elif haystack != 0:
        if len(npc_list) != 0:
            conf = 0.98
            for npc in npc_list:
                npc_found = lo.mlocate(npc, haystack=haystack, conf=conf)
                if npc_found != 0:
                    logging.debug(
                        'found ' + (str(npc)) + ' at ' + (str(npc_found)))
                    logging.info('unwanted npc detected')
                    return 1
            logging.debug('passed npc check')

        if len(pc_list) != 0:
            conf = 0.95
            for pc in pc_list:
                pc_found = lo.mlocate(pc, haystack=haystack, conf=conf)
                if pc_found != 0:
                    logging.debug(
                        'found ' + (str(pc)) + ' at ' + (str(pc_found)))
                    logging.info('unwanted player detected')
                    return 1
            logging.debug('passed pc check')
            return 0
        elif len(npc_list) == 0 and len(pc_list) == 0:
            return 0


def focus_client():
    """Clicks on a blank area in the left half of the client window,
    assuming user has properly configured the UI."""
    logging.debug('focusing client')
    pag.moveTo((originx + (random.randint(50, 300))),
               (originy + (random.randint(300, 500))),
               mouse.duration(), mouse.path())

    mouse.click()
    return 1


def focus_overview():
    """Clicks somewhere on the lower half of the overview
    (assuming it's on the rightmost quarter of the client window)
    to focus the client. If ship is docked, this click whill occur
    somewhere in the station services window below all the buttons."""
    logging.debug('focusing overview')

    x = (originx + (windowx - (int(windowx / 4.5))))
    y = originy
    randx = (random.randint(0, (int(windowx / 4.5) - 30)))
    randy = (random.randint((int(windowx / 2)), (windowy - 10)))
    pag.moveTo((x + randx), (y + randy), mouse.duration(), mouse.path())

    mouse.click()
    return 1


def select_overview_tab(tab):
    """Switches to the specified overview tab. If the specified tab is already
    selected, this function does nothing. Assumes the default overview
    configuration."""
    logging.debug('focusing ' + (str(tab)) + ' tab')

    # Requires very high confidence since the overview tab buttons look only
    # slightly different when selected.
    selected = lo.mlocate('./img/overview/' + (str(tab)) +
                          '_overview_tab_selected.bmp', conf=0.998,
                          grayscale=True)

    if selected != 0:
        logging.debug('tab ' + (str(tab)) + ' already selected')
        return 1

    elif selected == 0:
        unselected = lo.mlocate('./img/overview/' + (str(tab)) +
                                '_overview_tab.bmp', loctype='co',
                                grayscale=True)

        if unselected != 0:
            (x, y) = unselected
            pag.moveTo((x + (random.randint(-12, 12))),
                       (y + (random.randint(-6, 6))),
                       mouse.duration(), mouse.path())
            mouse.click()
            return 1
        elif unselected == 0:
            logging.error('unable to find overview tabs')
            return 0


def look_for_targets(target1, target2, target3, target4, target5):
    """Searches the overview for any of the provided targets. If one is found,
    returns its location to the calling function. The parameters passed to
    this function must be filepaths to the images of the targets to look
    for."""
    overview = pag.screenshot(
        region=((originx + (windowx - (int(windowx / 3.8)))),
                originy, (int(windowx / 3.8)), windowy))

    target_list = []
    # Populate the target_list with only the targets that the user wishes to
    # check for, as specified function's parameters. For
    # mining, these targets would be filepaths to images of of ore names.
    if target1 != 0:
        target_list.append(target1)
    if target2 != 0:
        target_list.append(target2)
    if target3 != 0:
        target_list.append(target3)
    if target4 != 0:
        target_list.append(target4)
    if target5 != 0:
        target_list.append(target5)

    for t in target_list:
        target = lo.mlocate(t, haystack=overview, conf=0.85)
        if target is not None:
            logging.debug('found ' + (str(t)) + ' at ' + (str(target)))
            # (x, y, l, w) = target
            # Move mouse over target for debugging.
            # pag.moveTo((x + (originx + (windowx - (int(windowx / 3.8))))),
            #           (y + originy),
            #           1, mouse.path())
            return target
        elif target == 0:
            logging.debug('target ' + (str(t)) + ' not found')

    logging.info('no targets found')
    return 0


def is_target_lockable():
    """Looks for a highlighted 'target this object' icon in the 'selected
    item' window, indicating the selected target is close enough in order to
    achieve a lock."""
    # High confidence required since greyed-out target lock icon looks
    # so similar to enabled icon.
    if lo.mlocate('./img/indicators/target_lock_available.bmp',
                  conf=0.9999) != 0:
        logging.debug('within targeting range')
        return 1
    elif lo.mlocate('./img/indicators/target_lock_available.bmp',
                    conf=0.9999) == 0:
        logging.debug('outside targeting range')
        return 0


def wait_for_target_lock():
    """Waits until a target has been locked by looking for
    the 'unlock target' icon in the 'selected item' window. While waiting for a
    target lock, switches to the 'general' overview tab and checks for
    jamming."""
    select_overview_tab('general')

    for tries in range(1, 50):
        target_locked = lo.mlocate('./img/indicators/target_lock_attained.bmp')
        
        if target_locked == 1 and is_jammed(1) == 0:
            logging.debug('target locked')
            return 1
        
        elif target_locked == 0 and is_jammed(1) == 0:
            logging.debug('waiting for target lock ' + (str(tries)))
            time.sleep(float(random.randint(1, 5)) / 10)
    
        elif is_jammed(1) == 1:
            logging.warning('ship jammed while locking target')
            return 0

    logging.warning('timed out waiting for target lock')
    return 0


def initiate_target_lock(target):
    """Selects topmost user-defined target on the overview. Approaches the
    selected target and attempts to lock the target once ship is close
    enough. Tries multiple times to lock the target before giving up. Checks
    for jamming attempts while approaching the target."""
    if target != 0:
        # Break apart tuple into coordinates.
        (x, y, l, w) = target
        # Adjust coordinates for screen.
        x = (x + (originx + (windowx - (int(windowx / 3.8)))))
        y = (y + originy)
        pag.moveTo((x + (random.randint(-100, 20))),
                   (y + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click()
        # Press 'keep at range' hotkey. This is used instead
        # 'orbit' because if another mining ship depletes the asteroid,
        # your ship will continue flying forever in a straight line.
        key.keypress('e')
        # Change to the general tab to detect jamming.
        select_overview_tab('general')
        
        # Try 5 times to get a target lock.
        for tries in range(1, 6):
            # Limit how long the ship spends approaching its target before
            # giving up
            for approachtime in range(1, 50):
            
                # Once target is in range, attempt to lock it.
                if is_target_lockable() == 1 and is_jammed(1) == 0:
                    logging.debug('try #' + (str(tries)) + ' to lock target')
                    lock_icon = lo.mlocate(
                        './img/indicators/target_lock_available.bmp',
                        loctype='c', grayscale=True)
                    (x, y) = lock_icon
                    pag.moveTo((x + (random.randint(-10, 10))),
                               (y + (random.randint(-10, 10))),
                               mouse.duration(), mouse.path())
                    mouse.click()
                    mouse.move_to_neutral()
                    target_locked = wait_for_target_lock()
                    if target_locked == 1:
                        return 1
                    elif target_locked == 0:
                        # if wait_for_target_lock() times out, continue the
                        # outer 'for' loop and try locking
                        # target again
                        break
                        
                elif is_target_lockable() == 0 and is_jammed(1) == 0:
                    logging.debug(
                        'target not yet within range ' + (str(approachtime)))
                    time.sleep(float(random.randint(10, 20)) / 10)

                elif is_jammed(1) == 1:
                    logging.warning('jammed while approaching target')
                    return 0

            logging.warning('timed out waiting for target to get within range!')
            return 0

        logging.warning('lock target failed')
        return 0
    
    else:
        logging.info('no targets available')
        return 0
