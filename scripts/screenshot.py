import os
#import time
import pyautogui as pag

from ocvbot import vision as vis


def main():
    #time.sleep(5)
    """
    Takes and automatically crops a screenshot to capture the OSRS
    client window. Useful for running on demand manually.
    """

    os.chdir('tests')
    orient = vis.Vision(left=0, top=0, width=1920, height=1080)

    # First check to see if the client is logged in.
    orient_logged_in = orient.mlocate(
        needle='../ocvbot/needles/orient.png', loctype='center')
    if orient_logged_in != 1:
        (x, y) = orient_logged_in
        x -= 748
        y -= 21
        pag.screenshot('screenshot.tmp.png', region=(x, y, 765, 503))

    elif orient_logged_in == 1:
        # If the client is not logged in, try a different anchor.
        orient_logged_out = orient.mlocate(
            needle='../ocvbot/needles/login-menu/orient-logged-out.png',
            loctype='center')
        (x, y) = orient_logged_out
        x -= 183
        y -= 59
        pag.screenshot('screenshot.tmp.png', region=(x, y, 765, 503))

    os.system('pngcrush -s '
              'screenshot.tmp.png haystack_$(date +%Y-%m-%d_%H:%M:%S.png)'
              '&& notify-send -u low "screenshot taken" '
              '&& rm screenshot.tmp.png')
    return


if __name__ == '__main__':
    main()
