import os
import pyautogui as pag

from python.main import vision as vis


def main():
    """
    Takes and automatically crops a screenshot to capture the OSRS
    client window. Useful for running on demand manually.
    """

    os.chdir('/home/austin/OSRS-AHKScripts/python/tests')
    target_image = vis.Vision(left=0, top=0, width=1920, height=1080)
    target_image = target_image.mlocate(
        needle='../main/needles/menu/prayers.png', loctype='center')

    (x, y) = target_image
    x -= 709
    y -= 186

    pag.screenshot('screenshot.tmp.png', region=(x, y, 765, 503))

    os.system('pngcrush -s '
              'screenshot.tmp.png haystack_$(date +%Y-%m-%d_%H:%M:%S.png)'
              '&& notify-send -u low "screenshot taken" '
              '&& rm screenshot.tmp.png')
    return


if __name__ == '__main__':
    main()
