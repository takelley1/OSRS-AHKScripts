import os
import logging as log
import pyautogui as pag

log.basicConfig(format='%(asctime)s -- %(filename)s.%(funcName)s - %(message)s'
                , level='INFO')


def main(debug=False):
    """
    Takes a screenshot of the OldSchool Runescape client window.

    Automatically censors player's username.

    Optionally overlays the coordinates of Vision objects, which can be
    useful for debugging. This function is designed to be run manually.


    Args:
        debug (bool): Whether the function will perform extra processing
                      to overlay rectanges cooresponding to Vision
                      object coordinates on the screenshot, which takes
                      a second or two, default is False. If set to
                      False, the function produces an image called
                      haystack_$(date +%Y-%m-%d_%H:%M:%S).png in the
                      current directory.

    Returns:
        Always returns 0.
    """

    log.info('Initializing')

    from ocvbot import vision
    vision.init_vision()

    from ocvbot.vision import vclient_left, vclient_top, \
        CLIENT_HEIGHT, CLIENT_WIDTH, client_status

    if debug is False:
        pag.screenshot('.screenshot.tmp.png', region=(vclient_left,
                                                      vclient_top,
                                                      CLIENT_WIDTH,
                                                      CLIENT_HEIGHT))
        log.info('Processing screenshot')
        if client_status == 'logged_in':
            # If the client is logged in, censor the player's username
            #   by drawing a black box over it with ImageMagick.
            os.system('pngcrush -s '
                      '.screenshot.tmp.png .screenshot.tmp2.png '
                      '&>/dev/null '
                      '&& convert .screenshot.tmp2.png '
                      '-fill black '
                      '-draw "rectangle 7 458 190 473" '
                      'haystack_$(date +%Y-%m-%d_%H:%M:%S).png'
                      '&& rm .screenshot.tmp*.png'
                      '&& notify-send -u low "Screenshot taken"')
        elif client_status == 'logged_out':
            os.system('pngcrush -s '
                      '.screenshot.tmp.png '
                      'haystack_$(date +%Y-%m-%d_%H:%M:%S).png '
                      '&>/dev/null '
                      '&& rm .screenshot.tmp*.png'
                      '&& notify-send -u low "Screenshot taken"')
        else:
            raise RuntimeError("Could not interpret client_status var!")

    elif debug is True:
        # Import all the Vision objects to overlay onto the screenshot.
        from ocvbot import DISPLAY_WIDTH, DISPLAY_HEIGHT
        from ocvbot.vision import \
            vinv_left, vinv_top, \
            INV_WIDTH, INV_HEIGHT, \
            INV_HALF_WIDTH, INV_HALF_HEIGHT, \
            vinv_bottom_left, vinv_bottom_top, \
            vinv_right_half_left, vinv_right_half_top, \
            vinv_left_half_left, vinv_left_half_top, \
            vgame_screen_left, vgame_screen_top, \
            GAME_SCREEN_HEIGHT, GAME_SCREEN_WIDTH, \
            vchat_menu_left, vchat_menu_top, \
            CHAT_MENU_WIDTH, CHAT_MENU_HEIGHT, \
            vchat_menu_recent_left, vchat_menu_recent_top, \
            CHAT_MENU_RECENT_HEIGHT, CHAT_MENU_RECENT_WIDTH, \
            GAME_SCREEN_WIDTH, GAME_SCREEN_HEIGHT, \
            DISPLAY_WIDTH, DISPLAY_HEIGHT

        pag.screenshot('.screenshot.tmp2.png', region=(0, 0,
                                                       DISPLAY_WIDTH,
                                                       DISPLAY_HEIGHT))
        log.info('Compressing screenshot')
        os.system('pngcrush -s .screenshot.tmp2.png .screenshot.tmp.png'
                  '&>/dev/null')

        # Create a separate edited file for each Vision object, as some
        #   of the objects' coordinates overlap.
        log.info('Creating client.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vclient_left)
                  + ' ' + str(vclient_top)
                  + ' ' + str(vclient_left + CLIENT_WIDTH)
                  + ' ' + str(vclient_top + CLIENT_HEIGHT)
                  + '" client.png')

        log.info('Creating inv.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vinv_left)
                  + ' ' + str(vinv_top)
                  + ' ' + str(vinv_left + INV_WIDTH)
                  + ' ' + str(vinv_top + INV_HEIGHT)
                  + '" inv.png')

        log.info('Creating inv_bottom_half.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vinv_bottom_left)
                  + ' ' + str(vinv_bottom_top)
                  + ' ' + str(vinv_bottom_left + INV_WIDTH)
                  + ' ' + str(vinv_bottom_top + INV_HALF_HEIGHT)
                  + '" inv_bottom_half.png')

        log.info('Creating inv_right_half.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vinv_right_half_left)
                  + ' ' + str(vinv_right_half_top)
                  + ' ' + str(vinv_right_half_left + INV_HALF_WIDTH)
                  + ' ' + str(vinv_right_half_top + INV_HEIGHT)
                  + '" inv_right_half.png')

        log.info('Creating inv_left_half.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vinv_left_half_left)
                  + ' ' + str(vinv_left_half_top)
                  + ' ' + str(vinv_left_half_left + INV_HALF_WIDTH)
                  + ' ' + str(vinv_left_half_top + INV_HEIGHT)
                  + '" inv_left_half.png')

        log.info('Creating game_screen.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vgame_screen_left)
                  + ' ' + str(vgame_screen_top)
                  + ' ' + str(vgame_screen_left + GAME_SCREEN_WIDTH)
                  + ' ' + str(vgame_screen_top + GAME_SCREEN_HEIGHT)
                  + '" game_screen.png')

        log.info('Creating chat_menu.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vchat_menu_left)
                  + ' ' + str(vchat_menu_top)
                  + ' ' + str(vchat_menu_left + CHAT_MENU_WIDTH)
                  + ' ' + str(vchat_menu_top + CHAT_MENU_HEIGHT)
                  + '" chat_menu_recent.png')

        log.info('Creating chat_menu_recent.png')
        os.system('convert .screenshot.tmp.png '
                  '-fill red '
                  '-draw "rectangle '
                  + str(vchat_menu_recent_left)
                  + ' ' + str(vchat_menu_recent_top)
                  + ' ' + str(vchat_menu_recent_left + CHAT_MENU_RECENT_WIDTH)
                  + ' ' + str(vchat_menu_recent_top + CHAT_MENU_RECENT_HEIGHT)
                  + '" chat_menu_recent.png')

        os.system('rm .screenshot.tmp*.png && '
                  'notify-send -u low "Debug screenshots taken!"')
        return 0

    return 0


if __name__ == '__main__':
    main()
