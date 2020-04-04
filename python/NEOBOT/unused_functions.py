'''
##### old functions #####

def detect_asteroids():
    # Switch overview to 'mining' tab, check for asteroids, then switch back to
    # the 'general' tab. Prioritize larger asteroids by searching for them
    # first.
    # mining_overview_tab = pag.locateCenterOnScreen(
    # './img/mining_overview_tab.bmp',
    # confidence=0.90,
    # region=(originx, originy, screenwidth, screenheight))
    # general_overview_tab = pag.locateCenterOnScreen(
    # './img/general_overview_tab.bmp', confidence=0.90,
    # region=(originx, originy, screenwidth, screenheight))
    global asteroid_s
    global asteroid_m
    global asteroid_l

    asteroid_m = pag.locateCenterOnScreen('./img/overview/asteroid_m.bmp',
                                          confidence=0.90,
                                          region=((originx + (windowx - (
                                              int(windowx / 3.8)))),
                                                  originy,
                                                  (int(windowx / 3.8)),
                                                  windowy))
    if asteroid_m is not None:
        return 1
    asteroid_l = pag.locateCenterOnScreen('./img/overview/asteroid_l.bmp',
                                          confidence=0.90,
                                          region=((originx + (windowx - (
                                              int(windowx / 3.8)))),
                                                  originy,
                                                  (int(windowx / 3.8)),
                                                  windowy))
    if asteroid_l is not None:
        return 1
    asteroid_s = pag.locateCenterOnScreen('./img/overview/asteroid_s.bmp',
                                          confidence=0.90,
                                          region=((originx + (windowx - (
                                              int(windowx / 3.8)))),
                                                  originy,
                                                  (int(windowx / 3.8)),
                                                  windowy))
    if asteroid_s is not None:
        return 1
    else:
        print('detect_asteroids -- no more asteroids found at site')
    return 0


def focus_mining_tab():
    # Switch to the default 'Mining' tab of the overview to check for
    # asteroids.
    print('focus_mining_tab -- called')
    mining_tab_selected = pag.locateCenterOnScreen(
        './img/overview/mining_overview_tab_selected.bmp',
        # Requires very high confidence because the button looks slightly
        # different when it's selected.
        confidence=0.995,
        region=(originx, originy,
                windowx, windowy))
    if mining_tab_selected is not None:
        print('focus_mining_tab -- already selected')
    else:
        mining_tab_unselected = pag.locateCenterOnScreen(
            './img/overview/mining_overview_tab.bmp',
            confidence=0.95,
            region=(originx, originy,
                    windowx, windowy))

        if mining_tab_unselected is not None:
            (x, y) = mining_tab_unselected
            pag.moveTo((x + (random.randint(-10, 10))),
                       (y + (random.randint(-7, 7))),
                       mouse.duration(), mouse.path())
            mouse.click()
            return 1
        else:
            return 0

def target_asteroid():
    # Target the closest large-sized asteroid in overview, assuming overview is
    # sorted by distance, with closest objects at the top.
    # Switch to mining tab, target asteroid, then switch back to general tab.
    global asteroid_s
    global asteroid_m
    global asteroid_l

    if asteroid_m is not None:
        (asteroid_mediumx, asteroid_mediumy) = asteroid_m
        pag.moveTo((asteroid_mediumx + (random.randint(-2, 200))),
                   (asteroid_mediumy + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click()
        keyboard.keypress('w')
        if target_available() == 0:
            time.sleep(float(random.randint(500, 1000)) / 1000)
            print('target_asteroid -- getting closer to target')
            time.sleep(float(random.randint(1000, 5000)) / 1000)
            tries = 0
            while target_available() == 0 and tries <= 30:
                time.sleep(10)
            if target_available() == 0 and tries > 30:
                print('target_asteroid -- timed out getting closer to target')
                return 0
        if target_available() == 1:
            keyboard.keypress('ctrl')
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            print('target_asteroid -- locking target')
            detect_target_lock_loop()
            return 1

    elif asteroid_l is not None:
        (asteroid_largex, asteroid_largey) = asteroid_l
        pag.moveTo((asteroid_largex + (random.randint(-2, 200))),
                   (asteroid_largey + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click()
        keyboard.keypress('w')
        if target_available() == 0:
            print('target_asteroid -- getting closer to target')
            time.sleep(float(random.randint(1000, 5000)) / 1000)
            # This while loop is required to prevent script from constantly
            # issuing 'orbit' commands.
            tries = 0
            while target_available() == 0 and tries <= 30:
                time.sleep(10)
            if target_available() == 0 and tries > 30:
                print('target_asteroid -- timed out getting closer to target')
                return 0
        if target_available() == 1:
            keyboard.keypress('ctrl')
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            print('target_asteroid -- locking target')
            detect_target_lock_loop()
            return 1

    elif asteroid_s is not None:
        (asteroid_smallx, asteroid_smally) = asteroid_s
        pag.moveTo((asteroid_smallx + (random.randint(-2, 200))),
                   (asteroid_smally + (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click()
        keyboard.keypress('w')
        if target_available() == 0:
            print('target_asteroid -- getting closer to target')
            time.sleep(float(random.randint(1000, 5000)) / 1000)
            tries = 0
            while target_available() == 0 and tries <= 30:
                time.sleep(10)
            if target_available() == 0 and tries > 30:
                print('target_asteroid -- timed out getting closer to target')
                return 0
        if target_available() == 1:
            keyboard.keypress('ctrl')
            time.sleep(float(random.randint(1000, 2000)) / 1000)
            print('target_asteroid -- locking target')
            detect_target_lock_loop()
            return 1

    else:
        print('target_asteroid -- no asteroids to target')
        return 0

##### old original miner script #####
def miner():  # mine ore from a predetermined set of asteroid fields
	print('running miner')
	dockedcheck = docked.docked_check()
	while dockedcheck == 0:  # if not docked, check cargohold capacity
		cargohold = check_cargohold()
		if cargohold == 1:  # if cargohold over 90%, dock and unload at home
		station, then rerun function
			nav.set_home()
		elif cargohold == 0:  # if cargohold less than 90%, go to first
		asteroid field
			nav.set_dest()
			navigator()

	while dockedcheck == 1:  # if docked, check if at home station
		athomecheck = nav.detect_at_home()
		if athomecheck == 1:  # if at home station, set destination waypoint
		and unload ore from ship
			unload_ship.unload_ship()
			nav.set_dest()
			docked.undock_loop()
			miner()
		elif athomecheck == 0:  # if not at home station, go to home station
		to unload ore
			print('not at home')
			nav.set_home()
			docked.undock_loop()
			miner()
		else:
			print('error with detect_at_home and at_dest_check')
			traceback.print_exc()
			traceback.print_stack()
			sys.exit()
	if dockedcheck is None:
		miner()


if docked.docked_check == 1:
	print('good')
if docked.docked_check == 0:
	print('not docked')
    value = docked.docked_check()
    print(value)
    sys.exit()


def warp_to_first_bookmark_in_system():
    # warp to lowest-numbered bookmark in the system higher than 0
    # bookmark names must be preceded with a 1-digit number higher than 0 (
    # ex: 1spot_in_system_A)
    # bookmark 0 is the home station
    bnum = 1
    global defined_bookmark_in_system
    # check if bookmark 1 is in the current system. if so, warp to it. if
    # not, increment by 1 and try again
    defined_bookmark_in_system = pag.locateCenterOnScreen(
        ('./img/dest/at_dest' + (bookmark_dict[bnum]) + '.bmp'),
        confidence=0.90,
        region=(originx, originy, windowx, windowy))
    while defined_bookmark_in_system is None:
        bnum += 1
        defined_bookmark_in_system = pag.locateCenterOnScreen(
            ('./img/dest/at_dest' + (bookmark_dict[bnum]) + '.bmp'),
            confidence=0.90,
            region=(originx, originy, windowx, windowy))
        if bnum == 9 and defined_bookmark_in_system is None:
            print(
                'warp_to_first_bookmark_in_system -- out of bookmarks in '
                'system to look for')
            return 0
    if defined_bookmark_in_system is not None:
        print('warp_to_first_bookmark_in_system -- found bookmark' + (
            bookmark_dict[bnum]))
        (bookmark_in_systemx), (
            bookmark_in_systemy) = defined_bookmark_in_system
        pag.moveTo((bookmark_in_systemx + (random.randint(-1, 200))),
                   (bookmark_in_systemy +
                    (random.randint(-3, 3))), mouse.duration(),
                   mouse.path())
        mouse.click_right()
        pag.moveRel((0 + (random.randint(10, 80))),
                    (0 + (random.randint(20, 25))),
                    mouse.duration(), mouse.path())
        mouse.click()
        time.sleep(2)
        return 1


def detect_warp_to_bookmark_in_system():
    # detect when warp to a bookmark has been completed to a bookmark by
    checking if the
    bookmark
    's right-click
    # menu still has a 'warp to' option. if the option is not present,
    ship
    has
    arrived
    at
    bookmark
    (defined_bookmark_in_systemx), (defined_bookmark_in_systemy) =
    defined_bookmark_in_system
    tries = 0
    pag.moveTo((defined_bookmark_in_systemx + (random.randint(-1, 200))),
               (defined_bookmark_in_systemy +
                (random.randint(-3, 3))),
               mouse.duration(),
               mouse.path())
    mouse.click_right()
    print('detect_warp_to_bookmark_in_system -- waiting for warp')
    at_bookmark_in_system = pag.locateCenterOnScreen(
        './img/detect_warp_to_bookmark.bmp',
        confidence=0.85,
        region=(originx, originy,
                screenwidth,
                screenheight))
    while at_bookmark_in_system is None and tries <= 50:
        time.sleep(float(random.randint(1000, 3000)) / 1000)
        focus_client()
        time.sleep(float(random.randint(5000, 10000)) / 1000)
        warp_to_bookmark_tries += 1
        pag.moveTo((defined_bookmark_in_systemx + (random.randint(-1, 200))),
                   (defined_bookmark_in_systemy +
                    (random.randint(-3, 3))),
                   mouse.duration(), mouse.path())
        mouse.click_right()
        at_bookmark_in_system = pag.locateCenterOnScreen(
            './img/detect_warp_to_bookmark.bmp',
            confidence=0.98,
            region=(originx,
                    originy,
                    halfscreenwidth,
                    screenheight))
    if at_bookmark_in_system is None and warp_to_bookmark_tries >= 50:
        emergency_terminate()
        return 0
    if at_bookmark_in_system is not None and warp_to_bookmark_tries < 50:
        print('detect_warp_to_bookmark_in_system -- warp completed')
        return 1


# OLD WARP TP BOOKMARK FUNC
(defined_bookmark_in_systemx), (defined_bookmark_in_systemy) =
defined_bookmark_in_system
tries = 0
pag.moveTo((defined_bookmark_in_systemx + (random.randint(-1, 200))),
           (defined_bookmark_in_systemy +
            (random.randint(-3, 3))),
           mouse.duration(),
           mouse.path())
mouse.click_right()
print('detect_warp_to_bookmark_in_system -- waiting for warp')
at_bookmark_in_system = pag.locateCenterOnScreen(
    './img/detect_warp_to_bookmark.bmp',
    confidence=0.85,
    region=(originx, originy,
            screenwidth,
            screenheight))
while at_bookmark_in_system is None and tries <= 50:
    time.sleep(float(random.randint(1000, 3000)) / 1000)
    focus_client()
    time.sleep(float(random.randint(5000, 10000)) / 1000)
    warp_to_bookmark_tries += 1
    pag.moveTo((defined_bookmark_in_systemx + (random.randint(-1, 200))),
               (defined_bookmark_in_systemy +
                (random.randint(-3, 3))),
               mouse.duration(), mouse.path())
    mouse.click_right()
    at_bookmark_in_system = pag.locateCenterOnScreen(
        './img/detect_warp_to_bookmark.bmp',
        confidence=0.98,
        region=(originx,
                originy,
                halfscreenwidth,
                screenheight))
if at_bookmark_in_system is None and warp_to_bookmark_tries >= 50:
    emergency_terminate()
    return 0
if at_bookmark_in_system is not None and warp_to_bookmark_tries < 50:
    print('detect_warp_to_bookmark_in_system -- warp completed')
    return 1



# no longer used
def target_out_of_range_popup():
    # Check if ship is too far from the desired object in order to get a
    # target lock on it.
    target_out_of_range = pag.locateCenterOnScreen(
        './img/popups/target_too_far.bmp',
        confidence=0.90,
        region=(originx, originy, windowx, windowy))
    while target_out_of_range is not None:
        print('target_out_of_range -- out of targeting range')
        return 1
    if target_out_of_range is None:
        print('target_out_of_range -- in targeting range')
        return 0


def detect_pcs():
    # Same as check_for_enemies function, except check for certain
    # classes of
    # human players as specified by the user. Search for most common ship
    # types first
    print('detect_pcs -- called')
    conf = 0.96
    if check_for_players_var == 1:
        if check_for_player_type_barge_and_industrial == 1:
################ No need for locateCenterOnScreen
            mining_barge_and_industrial = pag.locateOnScreen(
                './img/overview/player_ship_icons/archetype_icons'
                '/player_mining_barge_and_industrial.bmp', confidence=conf,
################ Search right quarter of screen only. This is a tuple (left,top,width,height), NOT coordinates!! ( (x1, y1), (x2, y2) )
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if mining_barge_and_industrial is not None:
                print('detect_pcs -- found mining_barge_and_industrial',
                      mining_barge_and_industrial)
                print(mining_barge_and_industrial)
                #(x, y) = mining_barge_and_industrial
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                           #.5, mouse.path())
                return 1

        if check_for_player_type_frigate_and_destroyer == 1:
            frigate_and_destroyer = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_frigate_and_destroyer.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if frigate_and_destroyer is not None:
                print('detect_pcs -- found frigate_and_destroyer',
                      frigate_and_destroyer)
                #(x, y) = frigate_and_destroyer
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                #           .5, mouse.path())
                return 1

        if check_for_player_type_capital_industrial_and_freighter == 1:
            capital_industrial_and_freighter = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_capital_industrial_and_freighter.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if capital_industrial_and_freighter is not None:
                print('detect_pcs --'
                      'found capital_industrial_and_freighter'
                      , capital_industrial_and_freighter)
                #(x, y) = capital_industrial_and_freighter
                #pag.moveTo(x, y,  # Move mouse over
                #           # icon for debugging purposes
                #           .5, mouse.path())
                return 1

        if check_for_player_type_cruiser_and_battlecruiser == 1:
            cruiser_and_battlecruiser = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_cruiser_and_battlecruiser.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if cruiser_and_battlecruiser is not None:
                print('detect_pcs -- found cruiser_and_battlecruiser',
                      cruiser_and_battlecruiser)
                #(x, y) = cruiser_and_battlecruiser
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                #           .5, mouse.path())
                return 1

        if check_for_player_type_battleship == 1:
            battleship = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_battleship.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if battleship is not None:
                print('detect_pcs -- found battleship',
                      battleship)
                #(x, y) = battleship
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                #           .5, mouse.path())
                return 1

        if check_for_player_type_rookie_ship == 1:
            rookie_ship = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_rookie_ship.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if rookie_ship is not None:
                print('detect_pcs -- found rookie_ship',
                      rookie_ship)
                #(x, y) = rookie_ship
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                #           .5, mouse.path())
                return 1

        if check_for_player_type_capsule == 1:
            capsule = pag.locateOnScreen(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_capsule.bmp',
                confidence=conf,
                region=((windowx - (int(windowx / 4))), originy,
                        (int(windowx / 4)), windowy))
            if capsule is not None:
                print('detect_pcs -- found capsule',
                      capsule)
                #(x, y) = capsule
                #pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                 #          .5, mouse.path())
                return 1

            else:
                print('detect_pcs -- all clear')
                return 0
        else:
            return 0
    else:
        return 0


# Old check for player function in which player standing was checked rather
than simply ship icons. The entire function takes around 4 seconds on a 1024x768 client.

check_for_player_type_alliancemate = 1
check_for_player_type_ally = 1
check_for_player_type_bad_standing = 1
check_for_player_type_corpmate = 1
check_for_player_type_criminal = 1
check_for_player_type_engagement = 1
check_for_player_type_excellent_standing = 1
check_for_player_type_fleetmate = 1
check_for_player_type_good_standing = 1
check_for_player_type_has_bounty = 1
check_for_player_type_has_killright = 1
check_for_player_type_militia_ally = 1
check_for_player_type_neg5_sec = 1
check_for_player_type_neutral_standing = 1
check_for_player_type_suspect = 1
check_for_player_type_terrible_standing = 1
check_for_player_type_war_target = 1
check_for_player_type_war_target_militia = 1
check_for_player_type_zero_sec = 1

def detect_pcs():
    # Same as check_for_enemies function, except check for certain
    # classes of
    # human players as specified by the user.
    print('detect_pcs -- called')
    conf = 0.96

    if check_for_player_type_alliancemate == 1:
        alliancemate = pag.locateCenterOnScreen(
            './img/overview/player_type_alliancemate.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if alliancemate is not None:
            print('detect_pcs -- found alliancemate', alliancemate)
            return 1

    if check_for_player_type_ally == 1:
        ally = pag.locateCenterOnScreen(
            './img/overview/player_type_ally.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if ally is not None:
            print('detect_pcs -- found ally')
            return 1

    if check_for_player_type_bad_standing == 1:
        bad_standing = pag.locateCenterOnScreen(
            './img/overview/player_type_bad_standing.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if bad_standing is not None:
            print('detect_pcs -- found player with bad standing')
            return 1

    if check_for_player_type_corpmate == 1:
        corpmate = pag.locateCenterOnScreen(
            './img/overview/player_type_corpmate.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if corpmate is not None:
            print('detect_pcs -- found corpmate')
            return 1

    if check_for_player_type_criminal == 1:
        criminal = pag.locateCenterOnScreen(
            './img/overview/player_type_criminal.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if criminal is not None:
            print('detect_pcs -- found criminal')
            return 1

    if check_for_player_type_engagement == 1:
        engagement = pag.locateCenterOnScreen(
            './img/overview/player_type_engagement.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if engagement is not None:
            print('detect_pcs -- found player with limited engagement')
            return 1

    if check_for_player_type_excellent_standing == 1:
        excellent_standing = pag.locateCenterOnScreen(
            './img/overview/player_type_excellent_standing.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if excellent_standing is not None:
            print('detect_pcs -- found player with excellent standing')
            return 1

    if check_for_player_type_fleetmate == 1:
        fleetmate = pag.locateCenterOnScreen(
            './img/overview/player_type_fleetmate.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if fleetmate is not None:
            print('detect_pcs -- found fleetmate')
            return 1

    if check_for_player_type_good_standing == 1:
        good_standing = pag.locateCenterOnScreen(
            './img/overview/player_type_good_standing.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if good_standing is not None:
            print('detect_pcs -- found player with good standing')
            return 1

    if check_for_player_type_has_bounty == 1:
        has_bounty = pag.locateCenterOnScreen(
            './img/overview/player_type_has_bounty.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if has_bounty is not None:
            print('detect_pcs -- found player with a bounty')
            return 1

    if check_for_player_type_has_killright == 1:
        has_killright = pag.locateCenterOnScreen(
            './img/overview/player_type_has_killright.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if has_killright is not None:
            print('detect_pcs -- found player with a killright')
            return 1

    if check_for_player_type_militia_ally == 1:
        militia_ally = pag.locateCenterOnScreen(
            './img/overview/player_type_militia_ally.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if militia_ally is not None:
            print('detect_pcs -- found militia ally')
            return 1

    if check_for_player_type_neg5_sec == 1:
        neg5_sec = pag.locateCenterOnScreen(
            './img/overview/player_type_neg5_sec.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if neg5_sec is not None:
            print('detect_pcs -- found player with under -5 security')
            return 1

    if check_for_player_type_neutral_standing == 1:
        neutral_standing = pag.locateCenterOnScreen(
            './img/overview/player_type_neutral_standing.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if neutral_standing is not None:
            print('detect_pcs -- found player with neutral standing')
            return 1

    if check_for_player_type_suspect == 1:
        suspect = pag.locateCenterOnScreen(
            './img/overview/player_type_suspect.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if suspect is not None:
            print('detect_pcs -- found suspect')
            return 1

    if check_for_player_type_terrible_standing == 1:
        terrible_standing = pag.locateCenterOnScreen(
            './img/overview/player_type_terrible_standing.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if terrible_standing is not None:
            print('detect_pcs -- found player with terrible '
                  'standing', terrible_standing)
            return 1

    if check_for_player_type_war_target == 1:
        war_target = pag.locateCenterOnScreen(
            './img/overview/player_type_war_target.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if war_target is not None:
            print('detect_pcs -- found war target')
            return 1

    if check_for_player_type_war_target_militia == 1:
        war_target_militia = pag.locateCenterOnScreen(
            './img/overview/player_type_war_target_militia.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if war_target_militia is not None:
            print('detect_pcs -- found militia war target')
            return 1

    if check_for_player_type_zero_sec == 1:
        zero_sec = pag.locateCenterOnScreen(
            './img/overview/player_type_zero_sec.bmp',
            confidence=conf,
            region=(originx, originy,
                    windowx, windowy))
        if zero_sec is not None:
            print('detect_pcs -- found player with under 0 security')
            return 1

    else:
        print('detect_pcs -- found no players')
        return 0

def check_for_enemies():
    # Check entire window for red ship hud icons, indicating hostile npcs.
    # Only avoid the hostile ship classes specified by the user in the
    # global variables above. Script will try looking for these icons on the
    # default 'general' overview tab. Script will keep the 'general' overview
    # tab visible by default until switching tabs in required to locate another
    # asteroid.
    print('check_for_enemies -- called')
    if check_for_enemy_frigates == 1:
        enemy_frigate = pag.locateCenterOnScreen(
            './img/overview/enemy_frigate.bmp',
            confidence=0.92,  # High confidence required because script will
            #  not match icon consistently on the grid. Must match on
            # overview only.
            region=(originx, originy, windowx, windowy))
        if enemy_frigate is not None:
            (enemy_frigatex, enemy_frigatey) = enemy_frigate
            print('check_for_enemies -- found hostile npc frigate at',
                  enemy_frigatex, enemy_frigatey)
            pag.moveTo(enemy_frigatex, enemy_frigatey,  # Move mouse over
                       # enemy frigate so it can be identified
                       .5, mouse.path())
            return 1

        # elif check_for_enemy_destroyers == 1:
        #	enemy_destroyer = pag.locateCenterOnScreen(
        #	'./img/overview/enemy_destroyer.bmp',
        #	confidence=0.90,
        #												region=(originx, originy,
        #												screenwidth,
        #												screenheight))
        #	if enemy_destroyer is not None:
        #		return 1
        # elif check_for_enemy_cruisers == 1:
        #	enemy_cruiser = pag.locateCenterOnScreen('./img/overview/enemy_cruiser.bmp',
        #	confidence=0.90,
        #											region=(originx, originy,
        #											screenwidth,
        #											screenheight))
        #	if enemy_cruiser is not None:
        #		return 1
        # elif check_for_enemy_battlecruisers == 1:
        #	enemy_battlecruiser = pag.locateCenterOnScreen(
        #	'./img/overview/enemy_battlecruiser.bmp', confidence=0.90,
        #													region=(originx,
        #													originy,
        #													screenwidth,
        #													screenheight))
        #	if enemy_battlecruiser is not None:
        #		return 1
        # elif check_for_enemy_battleships == 1:
        #	enemy_battleship = pag.locateCenterOnScreen(
        #	'./img/overview/enemy_battleship.bmp',
        #	confidence=0.90,
        #												region=(originx, originy,
        #												screenwidth,
        #												screenheight))
        #	if enemy_battleship is not None:
        #		return 1
        else:
            print('check_for_enemy_ships -- all clear')
            return 0

# ALTERNATIVE CHECK FOR PLAYERS WITH ONLY ONE SCREENSHOT
def detect_pcs():
    print('detect_pcs -- called')
    conf = 0.96
    if check_for_players_var == 1:

        # take a single screenshot of the rightmost quarter of the screen to capture the overview. do this at the beginning of the
        # function only once, rather than each time a ship icon is searched for
        overview = pag.screenshot(region=((windowx - (int(windowx / 4))), originy,
            (int(windowx / 4)), windowy))

        if check_for_player_type_barge_and_industrial == 1:

            # look for ship icon on the screenshot that was taken. keep the screenshot in memory so you don't have to wait for it to
            # write to disk
            mining_barge_and_industrial = pag.locate(
                './img/overview/player_ship_icons'
                '/archetype_icons/player_mining_barge_and_industrial.bmp', overview,
                confidence=conf,

            if mining_barge_and_industrial is not None:
                print('detect_pcs -- found mining_barge_and_industrial')
                (x, y) = mining_barge_and_industrial
                pag.moveTo(x, y,  # Move mouse over
                           # icon for debugging purposes
                           .5, mouse.path())
                return 1
        # continue to check for other player ship icons using the same overview
        screenshot from the beginning of the function
'''
