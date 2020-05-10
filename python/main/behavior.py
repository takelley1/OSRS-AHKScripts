import random as rand

from python.main import input
from python.main import misc
from python.main import vision

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
        misc.sleep_rand(wait_min, wait_max)


"""
def open_menu(main-menu)
  if main-menu == 'prayers'
    menu_open = vsion.click_image(needle='./prayers')
    if menu_open == 0:
      menu_open = vision.wait_for_image(needle='prayer_x')
        if menu_open == 0:
          return 0
        else:
          return 1
    else:
      return 1
  elif main-menu == 'inventory'
  elif main-menu == 'magic'
  elif main-menu == 'equipment'
  elif main-menu == 'logout'

def logout()
  open_menu(logout)

def switch_worlds()
"""
