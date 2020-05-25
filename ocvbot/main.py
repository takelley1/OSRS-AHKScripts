import sys
import logging as log
import yaml

#from PIL import ImageOps
#import tkinter
#from tkinter import ttk
#import yaml

from ocvbot import DISPLAY_WIDTH, DISPLAY_HEIGHT,\
    skilling, vision as vis

with open('./config.yaml') as config:
    config_file = yaml.safe_load(config)


def mining_lumbridge_swamp():
    """
    Script for mining copper in the Lumbridge mine in Lumbridge swamp.

    See "./needles/game-screen/lumbridge-mine/configuration/" for the
    required client configuration settings.
    """

    while True:
        miner = skilling.miner_double_drop(
            rock1=('./needles/game-screen/lumbridge-mine/'
                   'east-full.png',
                   './needles/game-screen/lumbridge-mine/'
                   'east-empty.png'),
            rock2=('./needles/game-screen/lumbridge-mine/'
                   'south-full.png',
                   './needles/game-screen/lumbridge-mine/'
                   'south-empty.png'),
            ore='./needles/items/copper-ore.png',
            drop_sapphire=config_file['drop_sapphire'],
            drop_emerald=config_file['drop_emerald'],
            drop_ruby=config_file['drop_ruby'],
            drop_diamond=config_file['drop_diamond'],
            drop_clue_geode=config_file['drop_clue_geode'])
        if miner == 0:
            log.info('Reorienting client')
            vis.orient(DISPLAY_WIDTH, DISPLAY_HEIGHT)


def mining_varrock_east():
    """
    Script for mining iron in the eastern Varrock mine.

    See "./needles/game-screen/varrock-east-mine/configuration/" for the
    required client configuration settings.
    """
    log.info('Began mining_varrock_east()')

    while True:
        miner = skilling.miner_double_drop(
            rock1=('./needles/game-screen/varrock-east-mine/'
                   'north-full2.png',
                   './needles/game-screen/varrock-east-mine/'
                   'north-empty.png'),
            rock2=('./needles/game-screen/varrock-east-mine/'
                   'west-full.png',
                   './needles/game-screen/varrock-east-mine/'
                   'west-empty.png'),
            ore='./needles/items/iron-ore.png',
            drop_sapphire=config_file['drop_sapphire'],
            drop_emerald=config_file['drop_emerald'],
            drop_ruby=config_file['drop_ruby'],
            drop_diamond=config_file['drop_diamond'],
            drop_clue_geode=config_file['drop_clue_geode'])
        if miner == 0:
            log.info('Reorienting client')
            vis.orient(DISPLAY_WIDTH, DISPLAY_HEIGHT)


def cannonball_smelter():

    # Click on the bank booth.
    bank_booth = vis.Vision(needle='./bank_booth').click_image()
    if bank_booth == 1:
        #logout()
        raise RuntimeError('couldnt find bank booth')

    # Wait for the bank window to appear.
    bank_window = vis.Vision(needle='./bank_window').wait_for_image()
    if bank_window == 1:
        #logout()
        raise RuntimeError ('timed out waiting for bank booth to open')

    # Withdrawl the steel bars.
    #   Right click icon of steel bars.
    right_click_steel = vis.Vision(needle='./steel_bar_in_bank').\
                                     click_image(button='right')
    if right_click_steel == 1:
        sys.exit(1)

    #   Select withdrawl option in right-click ocvbot-menu.
    withdrawl_steel = vis.Vision(needle='./windrawl_all').click_image()
    if withdrawl_steel == 1:
        sys.exit(1)

'''
    #   Wait for the items to appear in the player's inventory.
    steel_bars_in_inventory = vis.Vision(needle='./steel_bar_in_inv')\
        .wait_for_image(xmin=inv_xmin, xmax=inv_xmax, ymin=inv_ymin, ymax=inv_ymax)
    if steel_bars_in_inventory == 1:
        print('timed out waiting for steel bars to show up in inv')

    # Move to the furnace room from the bank.
     vis.click_image('./minimap_furnace_from_bank')
     vis.wait_for_image('./minimap_at_furnace')
     vis.click_image('furnace')
     vis.wait_for_image('smelting_menu')
     vis.keypress('space')

    ### wait for smelting to finish
    for i in range(1, 1000)
        lo.mlocate('./inv_empty')
        lo.mlocate('./login_screen')

        if lo.mlocate('./inv_empty') = 0:
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
    wait for bank window to open -- mlocate(neelde=bank_window)
if bank is open, continue
look for steel bar -- mlocate(needle=steel_bar, haystack=bank_window)
right click steel bar -- click(button=right)
     click 'withdrawal all' -- mlocate(needle=withdrawal_all), click
     check for warnings -- mlocate(needle=warnings)
 wait for steel bar to appear in inventory -- mlocate(needle=steel_bar, haystack=inventory)
 click on minimap objective -- mlocate(needle=minimap_furance_from_bank, 
 haystack=minimap)
 wait for palyer to reach objective -- mlocate(needle=minimap_at_furnace, 
 haystack=minimap)
 click on furnace -- mlocate(needle=furnace)
 use hotkeys to select correct options for smelting steel bars -- hotkey(1,2,3)
 while bars are smelting, run checks
     random chat messages -- random_chat()
     check for steel bars depleted -- mlocate(needle=steel_bar, haystack=inv)
     check for warning messages -- mlocate(needle=warning_message)
     check for logout -- mlocate(needle=login_page)
 when empty, click on bank objective -- mlocate(
 needle=minimap_bank_from_furnace,
 haystack=minimap)
 wait to reach bank -- mlocate(needle=at_bank)
 when at bank, re-test_orient player
 click on bank -- 
 wait for bank window to open
 right click steel bars in inv
     click 'deposit all'
     check for warnings
 wait for steel bars to deposit
 restart script
 return    
'''

# GUI ##########################################################################
#gui = tkinter.Tk()

# Load config file. ------------------------------------------------------------

#with open('./config.yaml') as f:
    #config = yaml.safe_load(f)

# Set default setting values from config file. ---------------------------------

#detect_pcs_gui = tkinter.IntVar()
#detect_pcs_gui.set(config['check_for_players'])

#pc_indy_gui = tkinter.IntVar()
#pc_indy_gui.set(config['check_for_player_industrials'])

#pc_barge_gui = tkinter.IntVar()
#pc_barge_gui.set(config['check_for_player_mining_barges'])

#pc_frig_dest_gui = tkinter.IntVar()
#pc_frig_dest_gui.set(config['check_for_player_frigates_and_destroyers'])

#pc_capindy_freighter_gui = tkinter.IntVar()
#pc_capindy_freighter_gui.set(
    #config['check_for_player_capital_industrials_and_freighters'])

#pc_cruiser_bc_gui = tkinter.IntVar()
#pc_cruiser_bc_gui.set(config['check_for_player_cruisers_and_battlecruisers'])

#pc_bs_gui = tkinter.IntVar()
#pc_bs_gui.set(config['check_for_player_battleships'])

#pc_rookie_gui = tkinter.IntVar()
#pc_rookie_gui.set(config['check_for_player_rookie_ships'])

#pc_pod_gui = tkinter.IntVar()
#pc_pod_gui.set(config['check_for_player_capsules'])

#detect_npcs_gui = tkinter.IntVar()
#detect_npcs_gui.set(config['check_for_rats'])

#npc_frig_dest_gui = tkinter.IntVar()
#npc_frig_dest_gui.set(config['check_for_rat_frigates_and_destroyers'])

#npc_cruiser_bc_gui = tkinter.IntVar()
#npc_cruiser_bc_gui.set(config['check_for_rat_cruisers_and_battlecruisers'])

#npc_bs_gui = tkinter.IntVar()
#npc_bs_gui.set(config['check_for_rat_battleships'])

#detect_jam_gui = tkinter.IntVar()
#detect_jam_gui.set(config['check_for_ECM_jamming'])

# blank text for spacing -------------------------------------------------------
#t = tkinter.Label(text="")
#t.grid(column=0, row=0, columnspan=2, sticky='W', padx=0, pady=0)

#t = tkinter.Label(text="")
#t.grid(column=0, row=3, columnspan=2, sticky='W', padx=0, pady=0)

# populate gui with settings ---------------------------------------------------
#combo_modules = ttk.Combobox(values=[1, 2, 3, 4])
# Subtract 1 since counting starts at 0.
#combo_modules.current((config['number_of_mining_lasers'] - 1))
#combo_modules.grid(column=1, row=4, columnspan=1, sticky='W')
#combo_modules.config(width='4', height='10')
#label_mininglasers = tkinter.Label(text="mining lasers")
#label_mininglasers.grid(column=0, row=4, columnspan=1, sticky='W', padx=20)

#combo_drones = ttk.Combobox(values=[0, 1, 2, 3, 4, 5])
#combo_drones.current(config['number_of_drones'])
#combo_drones.grid(column=1, row=5, columnspan=1, sticky='W')
#combo_drones.config(width='4', height='10')
#label_drones = tkinter.Label(text="drones")
#label_drones.grid(column=0, row=5, columnspan=1, sticky='W', padx=20, pady=5)

#detect_pcs = tkinter.Checkbutton(text='pc check', variable=detect_pcs_gui)
#detect_pcs.grid(column=0, row=6, columnspan=1, sticky='W')

#pc_indy = tkinter.Checkbutton(text='pc indy check', variable=pc_indy_gui)
#pc_indy.grid(column=1, row=6, columnspan=1, sticky='W')

#pc_barge = tkinter.Checkbutton(text='pc barge check', variable=pc_barge_gui)
#pc_barge.grid(column=0, row=7, columnspan=1, sticky='W')

#pc_frig_dest = tkinter.Checkbutton(text='pc frig/dest check',
                                   #variable=pc_frig_dest_gui)
#pc_frig_dest.grid(column=1, row=7, columnspan=1, sticky='W')

#pc_capindy_freighter = tkinter.Checkbutton(text='pc capindy/freighter check',
                                           #variable=pc_capindy_freighter_gui)
#pc_capindy_freighter.grid(column=0, row=8, columnspan=1, sticky='W')

#pc_cruiser_bc = tkinter.Checkbutton(text='pc cruiser/bc check',
                                    #variable=pc_cruiser_bc_gui)
#pc_cruiser_bc.grid(column=1, row=8, columnspan=1, sticky='W')

#pc_bs = tkinter.Checkbutton(text='pc bs check', variable=pc_bs_gui)
#pc_bs.grid(column=0, row=9, columnspan=1, sticky='W')

#pc_rookie = tkinter.Checkbutton(text='pc rookie check', variable=pc_rookie_gui)
#pc_rookie.grid(column=1, row=9, columnspan=1, sticky='W')

#pc_pod = tkinter.Checkbutton(text='pc pod check', variable=pc_pod_gui)
#pc_pod.grid(column=0, row=10, columnspan=1, sticky='W')

#t = tkinter.Label(text="")
#t.grid(column=0, row=11, columnspan=2, sticky='W', padx=0, pady=0)

#detect_npcs = tkinter.Checkbutton(text='npc check', variable=detect_npcs_gui)
#detect_npcs.grid(column=0, row=12, columnspan=1, sticky='W')

#npc_frig_dest = tkinter.Checkbutton(text='npc frig/dest check',
                                    #variable=npc_frig_dest_gui)
#npc_frig_dest.grid(column=1, row=12, columnspan=1, sticky='W')

#npc_cruiser_bc = tkinter.Checkbutton(text='npc cruiser/bc check',
                                     #variable=npc_cruiser_bc_gui)
#npc_cruiser_bc.grid(column=0, row=13, columnspan=1, sticky='W')

#npc_bs = tkinter.Checkbutton(text='npc bs check BROKEN',
                             #variable=npc_bs_gui)
#npc_bs.grid(column=1, row=13, columnspan=1, sticky='W')

#t = tkinter.Label(text="")
#t.grid(column=0, row=14, columnspan=2, sticky='W', padx=0, pady=0)

#detect_jam = tkinter.Checkbutton(text='ecm jamming check',
                                 #variable=detect_jam_gui)
#detect_jam.grid(column=0, row=15, columnspan=1, sticky='W')

#t = tkinter.Label(text="")
#t.grid(column=0, row=16, columnspan=2, sticky='W', padx=0, pady=0)
#t = tkinter.Label(text="")
#t.grid(column=0, row=18, columnspan=2, sticky='W', padx=0, pady=0)


#def start(event):
    #"""Starts the ocvbot miner_double_drop() script."""
    #global drone_num, module_num, detect_jam

    #global detect_pcs, pc_indy, pc_barge, pc_frig_dest, \
        #pc_capindy_freighter, pc_cruiser_bc, pc_bs, pc_rookie, pc_pod

    #global detect_npcs, npc_frig_dest, npc_cruiser_bc, npc_bs

    # Set the gui variables to reflect the current gui configuration when the
    # user clicks the start button.
    #module_num = (int(combo_modules.get()))
    #drone_num = (int(combo_drones.get()))
    #log.debug((str(module_num)) + ' modules')
    #log.debug((str(drone_num)) + ' drones')

    #detect_pcs = (int(detect_pcs_gui.get()))
    #log.debug('detect pcs is ' + (str(detect_pcs)))

    #pc_indy = (int(pc_indy_gui.get()))
    #log.debug('detect pc indy is ' + (str(pc_indy)))

    #pc_barge = (int(pc_barge_gui.get()))
    #log.debug('detect pc barge is ' + (str(pc_barge)))

    #pc_frig_dest = (int(pc_frig_dest_gui.get()))
    #log.debug('detect pc frig/dest is ' + (str(pc_frig_dest)))

    #pc_capindy_freighter = (int(pc_capindy_freighter_gui.get()))
    #log.debug('detect pc capital indy/freighter is ' + (str(
        #pc_capindy_freighter)))

    #pc_cruiser_bc = (int(pc_cruiser_bc_gui.get()))
    #log.debug('detect pc cruiser/bc is ' + (str(pc_cruiser_bc)))

    #pc_bs = (int(pc_bs_gui.get()))
    #log.debug('detect pc bs is ' + (str(pc_bs)))

    #pc_rookie = (int(pc_rookie_gui.get()))
    #log.debug('detect pc rookie is ' + (str(pc_rookie)))

    #pc_pod = (int(pc_pod_gui.get()))
    #log.debug('detect pc pod is ' + (str(pc_pod)))

    #detect_npcs = (int(detect_npcs_gui.get()))
    #log.debug('detect npcs is ' + (str(detect_npcs)))

    #npc_frig_dest = (int(npc_frig_dest_gui.get()))
    #log.debug('detect npc frig/dest is ' + (str(npc_frig_dest)))

    #npc_cruiser_bc = (int(npc_cruiser_bc_gui.get()))
    #log.debug('detect npc cruiser/bc is ' + (str(npc_cruiser_bc)))

    #npc_bs = (int(npc_bs_gui.get()))
    #log.debug('detect npc bs is ' + (str(npc_bs)))

    #detect_jam = (int(detect_jam_gui.get()))
    #log.debug('detect ecm jamming is ' + (str(detect_jam)))

    #mining_lumbridge_swamp()
    #return
#

def start_cannonball_smelter(event):
    """Starts the navigator() script."""
    cannonball_smelter()
    return


#def start_collector(event):
    #"""Starts the collector() script."""
    #collector()
    #return


#start_button = tkinter.Button(text="Start Lumbridge miner")
#start_button.grid(column=0, row=1, columnspan=2)
#start_button.bind("<ButtonRelease-1>", start)
#start_button.config(width='20', height='1', padx=5, pady=0)

#cannonball_smelter_button = tkinter.Button(text="Start Cannonball Smelter")
#cannonball_smelter_button.grid(column=0, row=2, columnspan=2)
#cannonball_smelter_button.bind("<ButtonRelease-1>", start_cannonball_smelter)
#cannonball_smelter_button.config(width='20', height='1', padx=10, pady=0)

#collectorbutton = tkinter.Button(text="start collector")
#collectorbutton.grid(column=1, row=17, columnspan=1)
#collectorbutton.bind("<ButtonRelease-1>", start_collector)
#collectorbutton.config(width='12', height='1', padx=10, pady=0)
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

#gui.title('PyScape v0.01')
#gui.mainloop()

vis.init_vision()
mining_lumbridge_swamp()
