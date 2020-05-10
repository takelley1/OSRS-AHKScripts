import logging as log
import random as rand
import sys

import pyautogui as pag

import python.main.vision
from python.main import misc

sys.setrecursionlimit(9999)


def click_coord(left, top, width, height, button='left'):
    """
    Clicks within the provided coordinates. If width and height are both
    0, then this function will click in the exact same location every
    time.

    Arguments:
        left: The left edge (x) of the coordinate space to click within.

        top: The top edge (y) of the coordinate space to click within.

        width: The x width of the coordinate space to randomize the
        click within.

        height: The y height of the coordinate space to randomize the
        click within.

        button (default = left): The mouse button to click with.
        """
    move_to(left, top, xmin=0, xmax=width, ymin=0, ymax=height)
    click(button=button)


def move_to(x, y, xmax, ymax, xmin=0, ymin=0):
    """
    Moves the mouse pointer to the specified coordinates. Coordinates
    are relative to the display's dimensions. Units are in pixels.

    Arguments:
        x: The X coordinate to move the mouse to.
        y: The Y coordinate to move the mouse to.
        xmax: The maximum random pixel offset from x.
        ymax: The maximum random pixel offset from y.
        xmin (default = 0) The minimum random pixel offset from x.
        ymin (default = 0) The minimum random pixel offset from y.

    Returns:
        Always returns 0.
    """

    xrand = rand.randint(xmin, xmax)
    yrand = rand.randint(ymin, ymax)

    pag.moveTo((x + xrand),
               (y + yrand),
               move_duration(),
               move_path())
    return 0


def move_away(direction=rand.choice(['left', 'right'])):
    """
    Moves the mouse to a random spot on right half or the left half
    of the client window, away from wherever it clicked, to prevent
    tooltips from interfering with the script.

    Arguments:
        direction (default = [random]): Which side of the screen to move
        the mouse (left or right).

    Returns:
        Always returns 0.
    """

    log.debug('Moving mouse away towards ' + str(direction) +
              ' side of client.')
    misc.sleep_rand(0, 500)

    if direction == 'right':
        # TODO: Refactor this to input.move_to.
        pag.moveTo(
            (rand.randint((python.main.vision.client_width / 2),
                          python.main.vision.client_width)),
            (rand.randint(0, python.main.vision.client_height)),
            move_duration(), move_path())
        misc.sleep_rand(0, 500)

    elif direction == 'left':
        pag.moveTo(
            (rand.randint(0, (python.main.vision.client_width / 2))),
            (rand.randint(0, python.main.vision.client_height)),
            move_duration(), move_path())
        misc.sleep_rand(0, 500)

    return 0


def move_to_neutral(x, y, xmin=50, xmax=300, ymin=300, ymax=500):
    """
    Moves the mouse to a 'neutral zone', away from any buttons or
    tooltop icons that could get in the way of the script. Units are in
    pixels.

    Arguments:
        xmin (default = 50) : The minimum X-distance to move.
        xmax (default = 300): The maximum X-distance to move.

        ymin (default = 300): The minimum Y-distance to move.
        ymax (default = 500): The maximum X-distance to move.

    Returns:
        Always returns 0.
    """

    log.debug('Moving mouse towards neutral area.')

    move_to(x=x, y=y, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax)
    return 0


def click(button='left', before_min=0, before_max=500, after_min=0,
          after_max=500, duration_min=0, duration_max=100):
    """
    Clicks the left or right mouse button, waiting before and after
    for a randomized period of time.

    Arguments:
        button (default = 'left'): Which mouse button to click (left or
        right)

        before_min (default = 0)  : Minimum number of miliseconds to
        wait before clicking.

        before_max (default = 500): Maximum number of miliseconds to
        wait before clicking.

        after_min (default = 0)   : Minimum number of miliseconds to
        wait after clicking.

        after_max (default = 500) : Maximum number of miliseconds to
        wait after clicking.

        duration_min (default = 0) : Minimum number of miliseconds to
        hold down the mouse button.

        duration_max (default = 100) : Maximum number of miliseconds to
        hold down the mouse button.

    Returns:
        Always returns 0.
    """

    misc.sleep_rand(before_min, before_max)

    duration = misc.rand_seconds(rmin=duration_min, rmax=duration_max)
    log.debug('Holding down ' + button + ' mouse button for ' + str(duration) +
              ' seconds.')

    pag.click(button=button, duration=duration)
    misc.sleep_rand(after_min, after_max)
    return 0


def move_duration(duration_min=50, duration_max=1500):
    """
    Randomizes the amount of time the mouse cursor takes to move to a
    new location. Input arguments are in miliseconds but return value is
    in seconds.

    Arguments:
        duration_min (default = 50): Minimum number of miliseconds the
        mouse pointer will take to move to its destination.

        duration_max (default = 1500): Maximum number of miliseconds the
        mouse pointer will take to move to its destination.

    Returns:
        Returns a float.
    """

    move_duration_var = (misc.rand_seconds(duration_min, duration_max))
    return move_duration_var


def keypress(key, timedown_min=1, timedown_max=180, before_min=50,
             before_max=1000, after_min=50, after_max=1000):
    """
    Holds down the specified key for a random period of time. All
    values are in miliseconds.

    Arguments:
        key: The key on the keyboard to press, according to PyAutoGUI.

        timedown_min (default = 1): The shortest time the key can be
        down.
        timedown_max (default = 180): The longest time the key can be
        down.

        before_min (default = 50): The shortest time to wait before
        pressing the key down.
        before_max (default = 1000): The longest time to wait before
        pressing the key down.

        after_min (default = 50): The shortest time to wait after
        releasing the key.
        after_max (default = 1000): The longest time to wait after
        releasing the key.

    Returns:
        Always returns 0.
    """

    log.debug('Pressing key: ' + str(key) + '.')
    misc.sleep_rand(before_min, before_max)
    pag.keyDown(key)
    misc.sleep_rand(timedown_min, timedown_max)
    pag.keyUp(key)
    misc.sleep_rand(after_min, after_max)
    return 0


def double_hotkey_press(key1, key2, timedown_min=5, timedown_max=190,
                        before_min=500, before_max=1000,
                        after_min=500, after_max=1000):
    """
    Performs a two-key hotkey shortcut, such as Ctrl-c for copying
    text.

    Arguments:
        key1: The first hotkey used in the two-hotkey shortcut.
        Sometimes also called the modifier key.

        key2: The second hotkey used in the two-hotkey shortcut.

        timedown_min (default = 5): See keypress()'s docstring.
        timedown_max (default = 190): See keypress()'s docstring.

        before_min (default = 500): See keypress()'s docstring.
        before_max (default = 1000): See keypress()'s docstring.

        after_min (default = 500): See keypress()'s docstring.
        after_max (default = 1000): See keypress()'s docstring.

    Returns:
        Always returns 0.
    """

    log.debug('Pressing hotkeys: ' + str(key1) + ' + ' + str(key2))
    misc.sleep_rand(before_min, before_max)
    pag.keyDown(key1)
    misc.sleep_rand(timedown_min, timedown_max)
    pag.keyDown(key2)
    misc.sleep_rand(timedown_min, timedown_max)
    pag.keyUp(key1)
    misc.sleep_rand(timedown_min, timedown_max)
    pag.keyUp(key2)
    misc.sleep_rand(after_min, after_max)
    return 0


def move_path():
    """
    Randomizes the movement behavior of the mouse cursor as it moves
    to a new location. One of 22 different movement patters is chosen at
    random.

    Returns:
        Returns a random PyAutoGUI function for different mouse
        movement.
    """

    # to do: implement bezier-curve mouse behavior
    # https://stackoverflow.com/questions/44467329/pyautogui-mouse-movement-with-bezier-curve
    rand_path = rand.randint(1, 22)
    if rand_path == 1:
        log.debug('Generated rand_path easeInQuad.')
        return pag.easeInQuad
    elif rand_path == 2:
        log.debug('Generated rand_path easeOutQuad.')
        return pag.easeOutQuad
    elif rand_path == 3:
        log.debug('Generated rand_path easeInOutQuad.')
        return pag.easeInOutQuad

    elif rand_path == 4:
        log.debug('Generated rand_path easeInQuart.')
        return pag.easeInQuart
    elif rand_path == 5:
        log.debug('Generated rand_path easeOutQuart.')
        return pag.easeOutQuart
    elif rand_path == 6:
        log.debug('Generated rand_path easeinOutQuart.')
        return pag.easeInOutQuart

    elif rand_path == 7:
        log.debug('Generated rand_path easeInQuint.')
        return pag.easeInQuint
    elif rand_path == 8:
        log.debug('Generated rand_path easeOutQuint.')
        return pag.easeOutQuint
    elif rand_path == 9:
        log.debug('Generated rand_path easeInOutQuint.')
        return pag.easeInOutQuint

    elif rand_path == 10:
        log.debug('Generated rand_path easeInBack.')
        return pag.easeInBack
    elif rand_path == 11:
        log.debug('Generated rand_path easeOutBack.')
        return pag.easeOutBack
    elif rand_path == 12:
        log.debug('Generated rand_path easeInOutBack.')
        return pag.easeInOutBack

    elif rand_path == 13:
        log.debug('Generated rand_path easeInCirc.')
        return pag.easeInCirc
    elif rand_path == 14:
        log.debug('Generated rand_path easeOutCirc.')
        return pag.easeOutCirc
    elif rand_path == 15:
        log.debug('Generated rand_path easeInOutCirc.')
        return pag.easeInOutCirc

    elif rand_path == 16:
        log.debug('Generated rand_path easeInSine.')
        return pag.easeInSine
    elif rand_path == 17:
        log.debug('Generated rand_path easeOutSine.')
        return pag.easeOutSine
    elif rand_path == 18:
        log.debug('Generated rand_path easeInOutSine.')
        return pag.easeInOutSine

    elif rand_path == 19:
        log.debug('Generated rand_path linear.')
        return pag.linear

    elif rand_path == 20:
        log.debug('Generated rand_path easeInExpo.')
        return pag.easeInExpo
    elif rand_path == 21:
        log.debug('Generated rand_path easeOutExpo.')
        return pag.easeOutExpo
    elif rand_path == 22:
        log.debug('Generated rand_path easeInOutExpo.')
        return pag.easeInOutExpo
    else:
        return 1
