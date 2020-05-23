import logging as log
import random as rand

import pyautogui as pag

from ocvbot.vision import vinv, vinv_bottom, vdisplay
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

"""


def login(username_file='username', password_file='password'):
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

    Raises:
        Raises a runtime error if the login screen cannot be found.

    Returns:
        Always returns 0.
    """

    logged_out = vdisplay.click_image(needle='./needles/orient-logged-out.png')
    if logged_out == 1:
        raise RuntimeError("Cannot find client!")
    else:
        misc.sleep_rand(200, 3000)
        input.keypress('enter')
        misc.sleep_rand(200, 3000)
        pag.typewrite(open(username_file, 'r').read())
        misc.sleep_rand(200, 3000)
        input.keypress('tab')
        pag.typewrite(open(password_file, 'r').read())
        misc.sleep_rand(200, 3000)
        input.keypress('enter')
    return 0


def wait_rand(chance, wait_min=10000, wait_max=60000):
    """
    Roll for a chance to do nothing for the specified period of time.

    Args:
        chance (int): The number that must be rolled for the wait to be
                      called. For example, if change is 25, then there
                      is a 1 in 25 chance for the roll to pass.
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
        misc.sleep_rand(wait_min, wait_max)
    return 0


def drop_item_rapid(item):
    """
    Drops all instances of the provided item from the inventory. Assumes
    the inventory is already open.

    Args:
       item (file): Filepath to an image of the item to drop, as it
                    appears in the player's inventory.
    """
    log.info('Dropping item.')
    log.debug('Dropping' + str(item) + '.')

    inv_full = vinv.wait_for_image(loop_num=1, needle=item)
    while inv_full != 1:

        pag.keyDown('shift')
        # Alternate between searching for the item in upper half and the
        #   lower half of the player's inventory. This helps reduce the
        #   chances the bot will click on the same icon twice.
        vinv_bottom.click_image(loop_num=1,
                                click_sleep_before_min=0,
                                click_sleep_before_max=50,
                                click_sleep_after_min=0,
                                click_sleep_after_max=50,
                                move_duration_min=5,
                                move_duration_max=200,
                                needle=item)
        inv_full = vinv.click_image(loop_num=1,
                                    click_sleep_before_min=0,
                                    click_sleep_before_max=50,
                                    click_sleep_after_min=0,
                                    click_sleep_after_max=50,
                                    move_duration_min=5,
                                    move_duration_max=200,
                                    needle=item)
        pag.keyUp('shift')
        if inv_full == 1:
            return 0

    if inv_full == 1:
        log.info('Could not find item.')
        return 1
    else:
        return 0

"""
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
