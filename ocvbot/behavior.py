import logging as log
import random as rand

import pyautogui as pag

from ocvbot.ocvbot import inv
from ocvbot.ocvbot import inv_bottom

from ocvbot.ocvbot import input
from ocvbot.ocvbot import misc
from ocvbot.ocvbot import vision as vis

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


def wait_rand(chance, wait_min, wait_max):
    """Random chance to do nothing for the specified period of time."""
    wait_roll = rand.randint(1, chance)
    if wait_roll == chance:
        log.info('Random wait called.')
        misc.sleep_rand(wait_min, wait_max)


def drop_item_rapid(item):
    """
    Drops an instance of the given inventory item.
    """

    log.info('Dropping item.')
    log.debug('Dropping' + str(item) + '.')

    inv_full = inv.wait_for_image(loop_num=1, needle=item)
    while inv_full != 1:

        pag.keyDown('shift')
        inv_bottom.click_image(loop_num=1,
                                          click_sleep_before_min=0,
                                          click_sleep_before_max=50,
                                          click_sleep_after_min=0,
                                          click_sleep_after_max=50,
                                          move_duration_min=5,
                                          move_duration_max=200,
                                          needle=item)
        inv_full = inv.click_image(loop_num=1,
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
