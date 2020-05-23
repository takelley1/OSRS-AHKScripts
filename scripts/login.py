import pyautogui as pag

from ocvbot import input, misc
from ocvbot.vision import vdisplay


def main():
    """
    Automatically logs the client in using credentials specified in a file.
    """

    logged_out = vdisplay.click_image(needle='./needles/orient-logged-out.png')
    if logged_out == 1:
        raise RuntimeError("Cannot find client!")
    else:
        misc.sleep_rand(200, 3000)
        input.keypress('enter')
        misc.sleep_rand(200, 3000)
        pag.typewrite(open('username', 'r').read())
        misc.sleep_rand(200, 3000)
        input.keypress('tab')
        pag.typewrite(open('password', 'r').read())
        misc.sleep_rand(200, 3000)
        input.keypress('enter')


if __name__ == '__main__':
    main()
