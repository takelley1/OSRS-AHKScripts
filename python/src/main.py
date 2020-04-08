# encoding: utf-8
import logging
import random
import sys
import time
import traceback

import yaml
from PIL import ImageOps

import pyautogui as pag
import tkinter
from tkinter import ttk

#from src import bookmarks as bkmk, docked as doc, drones, locate as lo, \
    #mining as mng, navigation as nav, overview as o
#from src.vars import originx, originy, system_mining, windowx, windowy

# TODO: add support for mining drones.

# TODO: add ability to save default settings config using an ini file

# TODO: for mining script, add a user-defined sleep variable that waits for a
#  short duration between the ship locking a target and the ship activating
#  its mining lasers. This is to prevent the ship from constantly attempting
#  to activate its lasers on a target that has been locked but is not yet in
#  range, which can look suspicious.

sys.setrecursionlimit(9999999)
playerfound = 0

# These variables are for the mining script only -------------------------------
# Total number of saved bookmark locations. This variable is set by the user.
total_sites = 10
unsuitable_site = 0
# Number of 'runs' completed by the mining script. This will always start
# at 1
runs_var = 1
# ------------------------------------------------------------------------------

log.basicConfig(format='(%(asctime)s) %(funcName)s - %(''message)s',
                level=log.DEBUG)

# MAIN SCRIPTS #################################################################
'''
def cannonball_smelter():
orient player -- orient_player()
if bank is closed -- m_locate(needle=minimap_at_bank)

def cannonball_smelter():
    pass
    return
    bank_booth = lo.click_image('./bank_booth')
    if bank_booth == 1:
        print('error, couldnt find bank booth')

    bank_window = lo.wait_for_image('./bank_window')
    if bank_window == 1:
        print('timed out waiting for bank booth to open')

    right_click_steel = lo.click_image('./steel_bar_in_bank', button='right')
    if right_click_steel == 1:
        sys.exit(1)
    withdrawl = lo.click_image('./windrawl_all')
    if withdrawl == 1:
        sys.exit(1)

    steel_bars_in_inventory = lo.wait_for_image('./steel_bar_in_inv')
    if steel_bars_in_inventory == 1:
        print('timed out waiting for steel bars to show up in inv')

    lo.click_image('./minimap_furnace_from_bank')
    lo.wait_for_image('./minimap_at_furnace')
    lo.click_image('furnace')
    lo.wait_for_image('smelting_menu')
    key.keypress('space')

    ### wait for smelting to finish
    for i in range(1, 1000)
        lo.m_locate('./inv_empty')
        lo.m_locate('./login_screen')

        if lo.m_locate('./inv_empty') = 0:
            lo.click_image('./minimap_bank_from_furnace')
            lo.wait_forImage('./minimap_at_bank')
            lo.click_image('./bank_teller')
            lo.wait_for_image('./bank_window')
            lo.click_image('./steel_bars_in_inv',button='right')
            lo.click_image('./deposit_all')
            lo.wait_for_image('./empty_inventory')
    return
    ###

    click on bank
    wait for bank window to open -- m_locate(neelde=bank_window)
if bank is open, continue
look for steel bar -- m_locate(needle=steel_bar, haystack=bank_window)
right click steel bar -- click(button=right)
     click 'withdrawal all' -- m_locate(needle=withdrawal_all), click
     check for warnings -- m_locate(needle=warnings)
 wait for steel bar to appear in inventory -- m_locate(needle=steel_bar, haystack=inventory)
 click on minimap objective -- m_locate(needle=minimap_furance_from_bank, 
 haystack=minimap)
 wait for palyer to reach objective -- m_locate(needle=minimap_at_furnace, 
 haystack=minimap)
 click on furnace -- m_locate(needle=furnace)
 use hotkeys to select correct options for smelting steel bars -- hotkey(1,2,3)
 while bars are smelting, run checks
     random chat messages -- random_chat()
     check for steel bars depleted -- m_locate(needle=steel_bar, haystack=inv)
     check for warning messages -- m_locate(needle=warning_message)
     check for logout -- m_locate(needle=login_page)
 when empty, click on bank objective -- m_locate(
 needle=minimap_bank_from_furnace,
 haystack=minimap)
 wait to reach bank -- m_locate(needle=at_bank)
 when at bank, re-orient player
 click on bank -- 
 wait for bank window to open
 right click steel bars in inv
     click 'deposit all'
     check for warnings
 wait for steel bars to deposit
 restart script
 return    
'''

def miner():

    """An automatic mining script."""

    # Ores to mine, in order of priority.
    o1 = './img/overview/ore_types/plagioclase.bmp'
    o2 = './img/overview/ore_types/pyroxeres.bmp'
    o3 = './img/overview/ore_types/veldspar.bmp'
    o4 = './img/overview/ore_types/scordite.bmp'
    o5 = 0

    global playerfound, unsuitable_site, runs_var, pc_list, npc_list

    timer_var = 0
    # Build the lists of ship icons to check for based on the user-specified
    # checkboxes in the GUI.
    (npc_list, pc_list) = o.build_ship_list(detect_npcs, npc_frig_dest,
                                            npc_cruiser_bc, detect_pcs, pc_indy,
                                            pc_barge, pc_frig_dest,
                                            pc_cruiser_bc, pc_bs,
                                            pc_capindy_freighter, pc_rookie,
                                            pc_pod)
    logging.info('beginning run ' + (str(runs_var)))
    
    while doc.is_docked() == 0 and unsuitable_site <= total_sites:
        # Check if ship has any drones in space.
        if lo.mlocate('./img/indicators/drones/0_drone_in_bay.bmp',
                      conf=0.99) == 1:
            o.focus_client()
            drones.recall_drones(drone_num)
        if bkmk.iterate_through_bookmarks_rand(total_sites) == 1:
            # Once arrived at site, check for hostile npcs and human players.
            # If either exist, warp to another site.
            # If no hostiles npcs or players are present, check for asteroids.
            # If no asteroids exist,  warp to another site.
            if o.select_overview_tab('general') == 1:
                if o.look_for_ship(npc_list, pc_list) == 1:
                    unsuitable_site += 1
                    miner()
            o.select_overview_tab('mining')
            target = o.look_for_targets(o1, o2, o3, o4, o5)
            while target != 0:
                unsuitable_site = 0
                drones.launch_drones(drone_num)
                if o.initiate_target_lock(target) == 0:
                    miner()
                time.sleep(float(random.randint(5000, 15000)) / 1000)
                mng.activate_miners(module_num)
                # If ship inventory isn't full, continue to mine ore and wait
                # for popups or errors.
                # Switch back to the general tab for easier ship detection
                o.select_overview_tab('general')
                client = pag.screenshot(region=(
                    originx, originy, windowx, windowy))
                ship_full = lo.mlocate('./img/popups/ship_inv_full.bmp',
                                       haystack=client, conf=0.9)

                # main mining loop # -------------------------------------------
                while ship_full == 0:
                    time.sleep(1)
                    logging.debug('loop START -----')
                    # overview = pag.screenshot(region=(
                    #    (originx + (windowx - (int(windowx / 3.8)))),
                    #    originy, (int(windowx / 3.8)), windowy))
                    client = pag.screenshot(region=(
                        originx, originy, windowx, windowy))
                    overview = ImageOps.crop(client, (755, 0, 0, 0))

                    ship_full = lo.mlocate('./img/popups/ship_inv_full.bmp',
                                           haystack=client, conf=0.9)
                    timer_var += 1
                    
                    if lo.mlocate('./img/popups/asteroid_depleted.bmp',
                                  haystack=client, conf=0.9) == 1:
                        # Sleep to wait for all mining modules to disable
                        # themselves automatically
                        logging.info('waiting for modules to deactivate')
                        time.sleep(float(random.randint(10000, 15000)) / 1000)
                        o.select_overview_tab('mining')
                        target = o.look_for_targets(o1, o2, o3, o4, o5)
                        if target == 0:
                            miner()
                        elif target != 0:
                            if o.initiate_target_lock(target) == 0:
                                miner()
                            # This sleep is experimental, and prevents the
                            # script from attempting to mine an asteroid that
                            # is too far away.
                            time.sleep(
                                float(random.randint(5000, 15000)) / 1000)
                            mng.activate_miners(module_num)
                            ship_full = lo.mlocate(
                                './img/popups/ship_inv_full.bmp',
                                haystack=client, conf=0.9)
                            continue

                    if mng.time_at_site(timer_var) == 1 or lo.mlocate(
                            './img/indicators/no_object_selected.bmp',
                            haystack=client, conf=0.9) == 1:
                        drones.recall_drones(drone_num)
                        miner()

                    if o.look_for_ship(npc_list, pc_list, haystack=overview) \
                            == 1 \
                            or o.is_jammed(detect_jam, haystack=overview) == 1:
                        drones.recall_drones(drone_num)
                        miner()
                    logging.info('loop END -----')
                # end of main mining loop --------------------------------------

                if ship_full == 1:
                    # Once inventory is full, dock at home station and unload.
                    drones.recall_drones(drone_num)
                    logging.info('finishing up run ' + (str(runs_var)))
                    if system_mining == 0:
                        if bkmk.set_home() == 1:
                            if navigator() == 1:
                                doc.unload_ship()
                                doc.wait_for_undock()
                                playerfound = 0
                                time.sleep(3)
                                runs_var += 1
                                miner()
                    # If ship is mining in the same system it will dock in,
                    # a different set of functions is required.
                    elif system_mining == 1:
                        bkmk.dock_at_local_bookmark()
                        doc.unload_ship()
                        doc.wait_for_undock()
                        playerfound = 0
                        time.sleep(3)
                        runs_var += 1
                        miner()

            if target == 0:
                unsuitable_site += 1
                logging.debug('unsuitable_site is' + (str(unsuitable_site)))
                logging.debug('no targets, restarting')
                miner()

        elif bkmk.iterate_through_bookmarks_rand(total_sites) == 0:
            nav.emergency_terminate()
            sys.exit(0)
            
    if doc.is_docked() == 1 and unsuitable_site <= total_sites:
        o.focus_client()
        doc.wait_for_undock()
        miner()
        
    if doc.is_docked() == 1 and unsuitable_site > total_sites:
        logging.debug('unsuitable site limit reached')
        sys.exit()
        
    if doc.is_docked() == 0 and unsuitable_site > total_sites:
        logging.debug('unsuitable site limit reached')
        nav.emergency_terminate()
        nav.emergency_logout()
        sys.exit()


def navigator():
    """A standard warp-to-zero autopilot script. Warp to the destination, then
    terminate."""
    logging.debug('running navigator')
    nav.has_route()
    dockedcheck = doc.is_docked()

    while dockedcheck == 0:
        o.focus_overview()
        selectwaypoint = nav.warp_to_waypoint()
        while selectwaypoint == 1:  # Value of 1 indicates stargate waypoint.
            time.sleep(5)  # Wait for jump to begin.
            detectjump = nav.wait_for_jump()
            if detectjump == 1:
                selectwaypoint = nav.warp_to_waypoint()
            else:
                logging.critical('error detecting jump')
                nav.emergency_terminate()
                traceback.print_exc()
                traceback.print_stack()
                sys.exit()

        while selectwaypoint == 2:  # Value of 2 indicates a station waypoint.
            time.sleep(5)
            detectdock = nav.wait_for_dock()
            if detectdock == 1:
                logging.info('arrived at destination')
                return 1
        else:
            logging.warning('likely at destination')
            return 1

    while dockedcheck == 1:
        doc.wait_for_undock()
        time.sleep(5)
        navigator()


def collector():
    """Haul all items from a predetermined list of stations to a single 'home'
    station, as specified by the user. The home station is identified by a
    station bookmark beginning with '000', while the remote stations are any
    station bookmark beginning with the numbers 1-9. This means up to 10
    remote stations are supported."""
    logging.debug('running collector')
    dockedcheck = doc.is_docked()
    while dockedcheck == 0:
        selectwaypoint = nav.warp_to_waypoint()

        while selectwaypoint == 1:
            time.sleep(3)  # Wait for warp to start.
            detectjump = nav.wait_for_jump()
            if detectjump == 1:
                selectwaypoint = nav.warp_to_waypoint()
        while selectwaypoint == 2:
            time.sleep(3)
            detectdock = nav.wait_for_dock()
            if detectdock == 1:
                collector()
        else:
            logging.critical('error with at_dest_check_var and '
                             'at_home_check_var')
            traceback.print_exc()
            traceback.print_stack()
            sys.exit()

    while dockedcheck == 1:
        athomecheck = bkmk.is_home()
        # If docked at home station, set a destination waypoint to a remote
        # station and unload cargo from ship into home station inventory.
        if athomecheck == 1:
            doc.unload_ship()
            bkmk.set_dest()
            doc.wait_for_undock()
            collector()
        elif athomecheck == 0:
            logging.debug('not at home')
            loadship = doc.load_ship()
            logging.debug('loadship is ' + (str(loadship)))

            if loadship == 2 or loadship == 0 or loadship is None:
                atdestnum = bkmk.detect_bookmark_location()
                if atdestnum == -1:
                    doc.wait_for_undock()
                    collector()
                else:
                    bkmk.set_dest()
                    bkmk.blacklist_station()
                    doc.wait_for_undock()
                    collector()
            elif loadship == 1:  # Value of 1 indicates ship is full.
                bkmk.set_home()
                doc.wait_for_undock()
                collector()

        else:
            logging.critical('error with detect_at_home and at_dest_check')
            traceback.print_exc()
            traceback.print_stack()
            sys.exit()
    if dockedcheck is None:
        collector()


print("originx =", originx)
print("originy =", originy)
print("windowx =", windowx)
print("windowy =", windowy)

# GUI ##########################################################################
gui = tkinter.Tk()

# Load config file. ------------------------------------------------------------

with open('./config.yaml') as f:
    config = yaml.safe_load(f)

# Set default setting values from config file. ---------------------------------

detect_pcs_gui = tkinter.IntVar()
detect_pcs_gui.set(config['check_for_players'])

pc_indy_gui = tkinter.IntVar()
pc_indy_gui.set(config['check_for_player_industrials'])

pc_barge_gui = tkinter.IntVar()
pc_barge_gui.set(config['check_for_player_mining_barges'])

pc_frig_dest_gui = tkinter.IntVar()
pc_frig_dest_gui.set(config['check_for_player_frigates_and_destroyers'])

pc_capindy_freighter_gui = tkinter.IntVar()
pc_capindy_freighter_gui.set(
    config['check_for_player_capital_industrials_and_freighters'])

pc_cruiser_bc_gui = tkinter.IntVar()
pc_cruiser_bc_gui.set(config['check_for_player_cruisers_and_battlecruisers'])

pc_bs_gui = tkinter.IntVar()
pc_bs_gui.set(config['check_for_player_battleships'])

pc_rookie_gui = tkinter.IntVar()
pc_rookie_gui.set(config['check_for_player_rookie_ships'])

pc_pod_gui = tkinter.IntVar()
pc_pod_gui.set(config['check_for_player_capsules'])

detect_npcs_gui = tkinter.IntVar()
detect_npcs_gui.set(config['check_for_rats'])

npc_frig_dest_gui = tkinter.IntVar()
npc_frig_dest_gui.set(config['check_for_rat_frigates_and_destroyers'])

npc_cruiser_bc_gui = tkinter.IntVar()
npc_cruiser_bc_gui.set(config['check_for_rat_cruisers_and_battlecruisers'])

npc_bs_gui = tkinter.IntVar()
npc_bs_gui.set(config['check_for_rat_battleships'])

detect_jam_gui = tkinter.IntVar()
detect_jam_gui.set(config['check_for_ECM_jamming'])

# blank text for spacing -------------------------------------------------------
t = tkinter.Label(text="")
t.grid(column=0, row=0, columnspan=2, sticky='W', padx=0, pady=0)

t = tkinter.Label(text="")
t.grid(column=0, row=3, columnspan=2, sticky='W', padx=0, pady=0)

# populate gui with settings ---------------------------------------------------
combo_modules = ttk.Combobox(values=[1, 2, 3, 4])
# Subtract 1 since counting starts at 0.
combo_modules.current((config['number_of_mining_lasers'] - 1))
combo_modules.grid(column=1, row=4, columnspan=1, sticky='W')
combo_modules.config(width='4', height='10')
label_mininglasers = tkinter.Label(text="mining lasers")
label_mininglasers.grid(column=0, row=4, columnspan=1, sticky='W', padx=20)

combo_drones = ttk.Combobox(values=[0, 1, 2, 3, 4, 5])
combo_drones.current(config['number_of_drones'])
combo_drones.grid(column=1, row=5, columnspan=1, sticky='W')
combo_drones.config(width='4', height='10')
label_drones = tkinter.Label(text="drones")
label_drones.grid(column=0, row=5, columnspan=1, sticky='W', padx=20, pady=5)

detect_pcs = tkinter.Checkbutton(text='pc check', variable=detect_pcs_gui)
detect_pcs.grid(column=0, row=6, columnspan=1, sticky='W')

pc_indy = tkinter.Checkbutton(text='pc indy check', variable=pc_indy_gui)
pc_indy.grid(column=1, row=6, columnspan=1, sticky='W')

pc_barge = tkinter.Checkbutton(text='pc barge check', variable=pc_barge_gui)
pc_barge.grid(column=0, row=7, columnspan=1, sticky='W')

pc_frig_dest = tkinter.Checkbutton(text='pc frig/dest check',
                                   variable=pc_frig_dest_gui)
pc_frig_dest.grid(column=1, row=7, columnspan=1, sticky='W')

pc_capindy_freighter = tkinter.Checkbutton(text='pc capindy/freighter check',
                                           variable=pc_capindy_freighter_gui)
pc_capindy_freighter.grid(column=0, row=8, columnspan=1, sticky='W')

pc_cruiser_bc = tkinter.Checkbutton(text='pc cruiser/bc check',
                                    variable=pc_cruiser_bc_gui)
pc_cruiser_bc.grid(column=1, row=8, columnspan=1, sticky='W')

pc_bs = tkinter.Checkbutton(text='pc bs check', variable=pc_bs_gui)
pc_bs.grid(column=0, row=9, columnspan=1, sticky='W')

pc_rookie = tkinter.Checkbutton(text='pc rookie check', variable=pc_rookie_gui)
pc_rookie.grid(column=1, row=9, columnspan=1, sticky='W')

pc_pod = tkinter.Checkbutton(text='pc pod check', variable=pc_pod_gui)
pc_pod.grid(column=0, row=10, columnspan=1, sticky='W')

t = tkinter.Label(text="")
t.grid(column=0, row=11, columnspan=2, sticky='W', padx=0, pady=0)

detect_npcs = tkinter.Checkbutton(text='npc check', variable=detect_npcs_gui)
detect_npcs.grid(column=0, row=12, columnspan=1, sticky='W')

npc_frig_dest = tkinter.Checkbutton(text='npc frig/dest check',
                                    variable=npc_frig_dest_gui)
npc_frig_dest.grid(column=1, row=12, columnspan=1, sticky='W')

npc_cruiser_bc = tkinter.Checkbutton(text='npc cruiser/bc check',
                                     variable=npc_cruiser_bc_gui)
npc_cruiser_bc.grid(column=0, row=13, columnspan=1, sticky='W')

npc_bs = tkinter.Checkbutton(text='npc bs check BROKEN',
                             variable=npc_bs_gui)
npc_bs.grid(column=1, row=13, columnspan=1, sticky='W')

t = tkinter.Label(text="")
t.grid(column=0, row=14, columnspan=2, sticky='W', padx=0, pady=0)

detect_jam = tkinter.Checkbutton(text='ecm jamming check',
                                 variable=detect_jam_gui)
detect_jam.grid(column=0, row=15, columnspan=1, sticky='W')

t = tkinter.Label(text="")
t.grid(column=0, row=16, columnspan=2, sticky='W', padx=0, pady=0)
t = tkinter.Label(text="")
t.grid(column=0, row=18, columnspan=2, sticky='W', padx=0, pady=0)


def start(event):
    """Starts the main miner() script."""
    global drone_num, module_num, detect_jam

    global detect_pcs, pc_indy, pc_barge, pc_frig_dest, \
        pc_capindy_freighter, pc_cruiser_bc, pc_bs, pc_rookie, pc_pod

    global detect_npcs, npc_frig_dest, npc_cruiser_bc, npc_bs

    # Set the gui variables to reflect the current gui configuration when the
    # user clicks the start button.
    module_num = (int(combo_modules.get()))
    drone_num = (int(combo_drones.get()))
    logging.debug((str(module_num)) + ' modules')
    logging.debug((str(drone_num)) + ' drones')

    detect_pcs = (int(detect_pcs_gui.get()))
    logging.debug('detect pcs is ' + (str(detect_pcs)))

    pc_indy = (int(pc_indy_gui.get()))
    logging.debug('detect pc indy is ' + (str(pc_indy)))

    pc_barge = (int(pc_barge_gui.get()))
    logging.debug('detect pc barge is ' + (str(pc_barge)))

    pc_frig_dest = (int(pc_frig_dest_gui.get()))
    logging.debug('detect pc frig/dest is ' + (str(pc_frig_dest)))

    pc_capindy_freighter = (int(pc_capindy_freighter_gui.get()))
    logging.debug('detect pc capital indy/freighter is ' + (str(
        pc_capindy_freighter)))

    pc_cruiser_bc = (int(pc_cruiser_bc_gui.get()))
    logging.debug('detect pc cruiser/bc is ' + (str(pc_cruiser_bc)))

    pc_bs = (int(pc_bs_gui.get()))
    logging.debug('detect pc bs is ' + (str(pc_bs)))

    pc_rookie = (int(pc_rookie_gui.get()))
    logging.debug('detect pc rookie is ' + (str(pc_rookie)))

    pc_pod = (int(pc_pod_gui.get()))
    logging.debug('detect pc pod is ' + (str(pc_pod)))

    detect_npcs = (int(detect_npcs_gui.get()))
    logging.debug('detect npcs is ' + (str(detect_npcs)))

    npc_frig_dest = (int(npc_frig_dest_gui.get()))
    logging.debug('detect npc frig/dest is ' + (str(npc_frig_dest)))

    npc_cruiser_bc = (int(npc_cruiser_bc_gui.get()))
    logging.debug('detect npc cruiser/bc is ' + (str(npc_cruiser_bc)))

    npc_bs = (int(npc_bs_gui.get()))
    logging.debug('detect npc bs is ' + (str(npc_bs)))

    detect_jam = (int(detect_jam_gui.get()))
    logging.debug('detect ecm jamming is ' + (str(detect_jam)))

    miner()
    return


def start_navigator(event):
    """Starts the navigator() script."""
    navigator()
    return


def start_collector(event):
    """Starts the collector() script."""
    collector()
    return


startbutton = tkinter.Button(text="start miner")
startbutton.grid(column=0, row=1, columnspan=2)
startbutton.bind("<ButtonRelease-1>", start)
startbutton.config(width='10', height='1', padx=5, pady=0)

navigatorbutton = tkinter.Button(text="start navigator")
navigatorbutton.grid(column=0, row=17, columnspan=1)
navigatorbutton.bind("<ButtonRelease-1>", start_navigator)
navigatorbutton.config(width='12', height='1', padx=10, pady=0)

collectorbutton = tkinter.Button(text="start collector")
collectorbutton.grid(column=1, row=17, columnspan=1)
collectorbutton.bind("<ButtonRelease-1>", start_collector)
collectorbutton.config(width='12', height='1', padx=10, pady=0)
'''
termbutton = tkinter.Button(text="stopper", command=stopper)
termbutton.grid(column=0, row=2, sticky='W')
termbutton.config(width='13', height='1')

stopbutton = tkinter.Button(text="runner", command=runner)
stopbutton.grid(column=1, row=1, columnspan=1, sticky='W')
stopbutton.config(width='13', height='1')

endrunbutton = tkinter.Button(text="checker", command=checker)
endrunbutton.grid(column=1, row=2, columnspan=1, sticky='W')
endrunbutton.config(width='13', height='1')
'''

gui.title('NEOMINER v0.1')
gui.mainloop()
'''
# unit tests
while mining.inv_full_popup() == 0:
    if mining.asteroid_depleted_popup() == 1:
        if mining.detect_asteroids() == 0:
            # nav.blacklist_local_bookmark()
            miner()
        elif mining.detect_asteroids() == 1:
            mining.target_asteroid()
            mining.activate_miner()
            mining.inv_full_popup()
            continue
    if threading.Thread(target=mining.detect_pcs()).start() == 1:
        mining.recall_drones_loop()
        miner()
    if threading.Thread(target=mining.detect_pcs()).start() == 1:
        mining.recall_drones_loop()
        miner()
    time.sleep(2)
'''
