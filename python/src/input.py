# encoding: utf-8
import sys
import random as rand
import logging as log
import pyautogui as pag
from python.src import misc
from python.src.orient import client_xmax, client_xmin, client_ymax, client_ymin
sys.setrecursionlimit(9999999)


class Mouse:

    @staticmethod
    def move_away(direction=rand.choice(['left', 'right'])):
        """Moves the mouse to a random spot on right half or the left half of
        the client window, away from wherever it clicked,
        to prevent tooltips from interfering with the script."""
        log.debug('Moving mouse away towards ' +
                  str(direction) + ' side of client.')
        misc.sleep_rand(0, 500)
        if direction == 'right':
            pag.moveTo((rand.randint(
                ((client_xmax - 100) - (client_xmax / 2)), (client_xmax - 100))),
                (rand.randint(10, (client_ymax - 100))),
                Mouse.move_duration(), Mouse.move_path())
            misc.sleep_rand(0, 500)
            return 0

        elif direction == 'left':
            pag.moveTo((rand.randint(10, ((client_xmax - 100) -
                       (client_xmax / 2)))),
                       (rand.randint(10,(client_ymax - 100))),
                       Mouse.move_duration(), Mouse.move_path())
            misc.sleep_rand(0, 500)
            return 0

    @staticmethod
    def move_to_neutral(xmin=50, xmax=300, ymin=300, ymax=500):
        """Moves the mouse to a 'neutral zone', away from any buttons or tooltop
        icons that could get in the way of the script.

        parameters:

            xmin (default = 50): The minimum X-distance the mouse position should be
            randomized from the origin (top left corner of client window).

            xmax (default = 300): The maximum X-distance the mouse position
            should be randomized from the origin.

            ymin (default = 300): The minimum Y-distance the mouse position
            should be randomized from the origin.

            ymax (default = 500): The maximum X-distance the mouse position
            should be randomized from the origin."""

        log.debug('Moving mouse towards neutral area.')
        pag.moveTo((client_xmin + (rand.randint(xmin, xmax))),
                   (client_ymin + (rand.randint(ymin, ymax))),
                   Mouse.move_duration(), Mouse.move_path())
        return 0

    @staticmethod
    def click(button='left', before_min=0, before_max=500, after_min=0,
              after_max=500):
        """Clicks the left or right mouse button, waiting before and after for a
        randomized period of time.

        parameters:
            button (default = 'left'): Which mouse button to click with.

            before_min (default = 0): Minimum number of miliseconds to wait
            before clicking.

            before_max (default = 500): Maximum number of miliseconds to wait
            before clicking.

            after_min (default = 0): Minimum number of miliseconds to wait after
            clicking.

            after_max (default = 500): Maximum number of miliseconds to wait
            after clicking."""

        log.debug('Clicking ' + button + ' mouse button.')
        misc.sleep_rand(before_min, before_max)
        pag.click(button=button, duration=misc.rand_val)
        misc.sleep_rand(after_min, after_max)
        return 0

    @staticmethod
    def move_duration(duration_min=50, duration_max=1500):
        """Randomizes the amount of time the mouse cursor takes to move to a
        new location.

        parameters:
            duration_min (default = 50): Minimum number of miliseconds for mouse
            movement.

            duration_max (default = 1500): Maximum number of miliseconds for
            mouse movement."""

        move_duration_var = (misc.rand_val(duration_min, duration_max))
        return move_duration_var

    @staticmethod
    def move_path():
        """Randomizes the movement behavior of the mouse cursor as it moves to a
        new location. One of 22 different movement patters is chosen at random.
        """
        # TODO: implement bezier-curve mouse behavior
        # https://stackoverflow.com/questions/44467329
        # /pyautogui-mouse-movement-with-bezier-curve
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


class Keyboard:

    @staticmethod
    def keypress(key, timedown_min=5, timedown_max=190, before_min=500,
                 before_max=1000, after_min=500, after_max=1000):
        """Holds down the specified key for a random period of time. All
        times are in miliseconds.

        parameters:

            key: The key on the keyboard to press, according to PyAutoGui.

            timedown_min (default = 5): The shortest time the key can be down.
            timedown_max (default = 190): The longest time the key can be down.

            before_min (default = 500): The shortest time to wait before
                                        pressing the key down.
            before_max (default = 1000): The longest time to wait before
                                         pressing the key down.

            afterm_in (default = 500): The shortest time to wait after
                                       releasing the key.
            afterm_ax (default = 1000): The longest time to wait after
                                        releasing the key.
        """
        log.debug('Pressing key: ' + str(key))
        misc.sleep_rand(before_min, before_max)
        pag.keyDown(key)
        misc.sleep_rand(timedown_min, timedown_max)
        pag.keyUp(key)
        misc.sleep_rand(after_min, after_max)
        return 0

    @staticmethod
    def double_hotkey_press(key1, key2, timedown_min=5, timedown_max=190,
                            before_min=500, before_max=1000,
                            after_min=500, after_max=1000):
        """Performs a two-key hotkey shortcut, such as Ctrl-c for copying
        text."""
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
