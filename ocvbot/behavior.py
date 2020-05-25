import logging as log
import random as rand
import time

import pyautogui as pag

from ocvbot import input, misc

# TODO

"""
def chat(context)
  if context == 'smelting'
    type 'option 1'
    type 'option 2'
  
  elif context == 'blablabla'
  
def move_camera_rand(chance=3,down_min=200,down_max=2000)
    down_arrow_roll = rand.randint(1, chance)
    if down_arrow_roll == chance:
       input.keyDown('Down')
       time.sleep(float(rand.randint(down_min, down_max)))
       input.keyUp('Down')
    left
    right arrow roll
 
def check_experience(skill)

def open_menu_rand()

def open_menu(ocvbot-menu)
if ocvbot-menu == 'prayers'
    menu_open = vsion.click_image(needle='./prayers')
    if menu_open == 0:
        menu_open = vision.wait_for_image(needle='prayer_x')
        if menu_open == 0:
            return 0
        else:
            return 1
else:
    return 1
elif ocvbot-menu == 'inventory'
elif ocvbot-menu == 'magic'
elif ocvbot-menu == 'equipment'
elif ocvbot-menu == 'logout'

def logout()
    open_menu(logout)

def switch_worlds()
"""


def login(username_file='username.txt', password_file='password.txt',
          cred_sleep_min=800, cred_sleep_max=5000,
          login_sleep_min=5000, login_sleep_max=15000,
          postlogin_sleep_min=5000, postlogin_sleep_max=10000):
    """
    Logs in in using credentials specified in two files.

    Args:
        username_file (file): The filepath of the file containing the
                              user's username. Filepath is relative to
                              the directory this file is in, default is
                              a file simply called "username".
        password_file (file): The filepath of the file containing the
                              user's password. Filepath is relative to
                              the directory this file is in, default is
                              a file simply called "password".
        cred_sleep_min (int): The minimum number of miliseconds to wait
                              between actions while entering account
                              credentials, default is 800.
        cred_sleep_max (int): The maximum number of miliseconds to wait
                              between actions while entering account
                              credentials, default is 5000.
        login_sleep_min (int): The minimum number of miliseconds to wait
                               after hitting "Enter" to login, default
                               is 5000.
        login_sleep_max (int): The maximum number of miliseconds to wait
                               after hitting "Enter" to login, default
                               is 15000.
        postlogin_sleep_min (int): The minimum number of miliseconds to
                                   wait after clicking the "Click here
                                   to play" button, default is 5000.
        postlogin_sleep_max (int): The maximum number of miliseconds to
                                   wait after clicking the "Click here
                                   to play" button, default is 10000.

    Raises:
        Raises a runtime error if the login menu cannot be found, the
        postlogin screen cannot be found, or the logged-in client cannot
        be found.

    Returns:
        Always returns 0.
    """

    from ocvbot.vision import vdisplay
    logged_out = vdisplay.click_image(needle='./needles/login-menu/'
                                             'orient-logged-out.png')
    if logged_out == 1:
        raise RuntimeError("Cannot find client!")
    else:
        # Enter credentials.
        misc.sleep_rand(cred_sleep_min, cred_sleep_max)
        input.keypress('enter')
        misc.sleep_rand(cred_sleep_min, cred_sleep_max)
        pag.typewrite(open(username_file, 'r').read())
        misc.sleep_rand(cred_sleep_min, cred_sleep_max)
        pag.typewrite(open(password_file, 'r').read())
        misc.sleep_rand(cred_sleep_min, cred_sleep_max)
        input.keypress('enter')
        misc.sleep_rand(login_sleep_min, login_sleep_max)

        # Click the 'click here to play' button in the postlogin menu.
        postlogin = vdisplay.click_image(needle='./needles/'
                                         'login-menu/orient-postlogin.png',
                                         conf=0.8,
                                         loop_num=50,
                                         loop_sleep_min=1000,
                                         loop_sleep_max=2000)
        if postlogin != 1:
            misc.sleep_rand(postlogin_sleep_min, postlogin_sleep_max)
            # Wait for the orient.png to appear in the client window.
            logged_in = vdisplay.wait_for_image(needle='./needles/minimap/'
                                                'orient.png',
                                                loop_num=50,
                                                loop_sleep_min=1000,
                                                loop_sleep_max=2000)
            if logged_in != 1:
                # Make sure client camera is oriented correctly after
                #   logging in.
                pag.keyDown('Up')
                misc.sleep_rand(3000, 7000)
                pag.keyUp('Up')
                return 0
            else:
                raise RuntimeError("Cannot login!")

        else:
            raise RuntimeError("Cannot find postlogin screen!")


def wait_rand(chance, second_chance=10,
              wait_min=10000, wait_max=60000):
    """
    Roll for a chance to do nothing for the specified period of time.

    Args:
        chance (int): The number that must be rolled for the wait to be
                      called. For example, if change is 25, then there
                      is a 1 in 25 chance for the roll to pass.
        second_chance (int): The number that must be rolled for an
                             additional wait to be called if the first
                             roll passes, default is 10. By default,
                             this means that 10% of waits that pass the
                             first roll wait for an additional period of
                             time.
        wait_min (int): The minimum number of miliseconds to wait if the
                        roll passes, default is 10000.
        wait_max (int): The maximum number of miliseconds to wait if the
                        roll passes, default is 60000.

    Returns:
        Always returns 0.
    """

    wait_roll = rand.randint(1, chance)
    if wait_roll == chance:
        log.info('Random wait called.')
        sleeptime = misc.rand_seconds(wait_min, wait_max)
        log.info('Sleeping for ' + str(round(sleeptime)) + ' seconds.')
        time.sleep(sleeptime)

        # Perform an additional wait roll so that (1/second_chance)
        #   waits are extra long.
        wait_roll = rand.randint(1, second_chance)
        if wait_roll == 10:
            log.info('Additional random wait called.')
            sleeptime = misc.rand_seconds(wait_min, wait_max)
            log.info('Sleeping for ' + str(round(sleeptime)) + ' seconds.')
            time.sleep(sleeptime)
    return 0


def logout():
    """
    If the client is logged in, logs out.
    """
    from ocvbot.vision import vclient
    # First, make sure the client is logged in.
    logged_in = vclient.wait_for_image(needle='./needles/minimap/'
                                               'orient.png',
                                       loop_num=50,
                                       loop_sleep_min=1000,
                                       loop_sleep_max=3000)
    if logged_in != 1:
        logout_menu = vclient.click_image(needle='./needles/game-menu/'
                                                 'logout.png')
        if logout_menu != 1:
            logout_button
    return


def logout_rand(chance, wait_min=5, wait_max=120):
    """
    Random chance to logout of the client and wait. Units are in minutes.

    Args:
        chance (int): See wait_rand()'s docstring.
        wait_min (int): The minimum number of minutes to wait if the
                        roll passes, default is 5.
        wait_max (int): The maximum number of minutes to wait if the
                        roll passes, default is 120.

    Returns:
        Always returns 0.
    """

    # Convert to miliseconds.
    wait_min *= 60000
    wait_max *= 60000

    logout_roll = rand.randint(1, chance)
    if logout_roll == chance:
        log.info('Random logout called.')
        # TODO: add logout()
        #logout()

        sleeptime = misc.rand_seconds(wait_min, wait_max)
        # Convert to minutes for logging
        sleeptime_minutes = sleeptime / 60000
        log.info('Sleeping for ' + str(sleeptime_minutes) + 'minutes.')
        time.sleep(sleeptime)
    return 0


def drop_item(item, wait_chance=50, wait_min=5000, wait_max=20000):
    """
    Drops all instances of the provided item from the inventory.
    Shift+Click to drop item MUST be enabled.

    Args:
       item (file): Filepath to an image of the item to drop, as it
                    appears in the player's inventory.
       wait_chance (int): Chance to wait randomly while dropping item,
                          see wait_rand()'s docstring for more info,
                          default is 50.
       wait_min (int): Minimum number of miliseconds to wait if
                       a wait is triggered, default is 5000.
       wait_max (int): Maximum number of miliseconds to wait if
                       a wait is triggered, default is 20000.
    """

    from ocvbot.vision import vinv, vinv_right_half, vinv_left_half, vclient

    # Make sure the inventory tab is selected in the main menu.
    log.info('Making sure inventory is selected')
    inv_selected = vclient.wait_for_image(needle='./needles/main-menu/'
                                                 'inventory-selected.png')
    if inv_selected == 1:
        input.keypress('Escape')

    inv_full = vinv.wait_for_image(loop_num=1, needle=item)

    if inv_full != 1:
        log.info('Dropping ' + str(item) + '.')

    tries = 0
    while inv_full != 1 and tries <= 40:

        tries += 1
        pag.keyDown('shift')
        # Alternate between searching for the item in left half and the
        #   right half of the player's inventory. This helps reduce the
        #   chances the bot will click on the same icon twice.
        vinv_right_half.click_image(loop_num=1,
                                    click_sleep_befmin=10,
                                    click_sleep_befmax=50,
                                    click_sleep_afmin=50,
                                    click_sleep_afmax=300,
                                    move_durmin=50,
                                    move_durmax=800,
                                    needle=item)
        vinv_left_half.click_image(loop_num=1,
                                   click_sleep_befmin=10,
                                   click_sleep_befmax=50,
                                   click_sleep_afmin=50,
                                   click_sleep_afmax=300,
                                   move_durmin=50,
                                   move_durmax=800,
                                   needle=item)

        # Search the entire inventory to make sure the item is/isn't
        #   there.
        inv_full = vinv.wait_for_image(loop_num=1, needle=item)

        # Chance to briefly wait while dropping items.
        wait_rand(chance=wait_chance, wait_min=wait_min, wait_max=wait_max)

        pag.keyUp('shift')
        if inv_full == 1:
            return 0

    if inv_full == 1:
        log.info('Could not find ' + str(item) + '.')
        return 1
    elif tries > 50:
        log.error('Tried dropping item too many times!')
        return 1
    else:
        return 0
