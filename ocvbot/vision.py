import logging as log

import pyautogui as pag

from ocvbot import input
from ocvbot import misc
from ocvbot import CLIENT_WIDTH, CLIENT_HEIGHT,\
                   GAME_SCREEN_WIDTH, GAME_SCREEN_HEIGHT, \
                   INV_WIDTH, INV_HEIGHT, \
                   INV_HALF_WIDTH, INV_HALF_HEIGHT, \
                   CHAT_MENU_WIDTH, CHAT_MENU_HEIGHT, \
                   CHAT_MENU_RECENT_WIDTH, CHAT_MENU_RECENT_HEIGHT, \
                   DISPLAY_WIDTH, DISPLAY_HEIGHT

client_status = ''

vdisplay = ''

vclient = ''
vclient_left = ''
vclient_top = ''

vinv = ''
vinv_left = ''
vinv_top = ''

vinv_bottom = ''
vinv_bottom_left = ''
vinv_bottom_top = ''

vinv_right_half = ''
vinv_right_half_left = ''
vinv_right_half_top = ''

vinv_left_half = ''
vinv_left_half_left = ''
vinv_left_half_top = ''

vgame_screen = ''
vgame_screen_left = ''
vgame_screen_top = ''

vchat_menu = ''
vchat_menu_left = ''
vchat_menu_top = ''

vchat_menu_recent = ''
vchat_menu_recent_left = ''
vchat_menu_recent_top = ''


def init_vision():
    """
    Initializes the core objects for the Vision class.
    """
    global client_status

    global vdisplay

    global vclient
    global vclient_left
    global vclient_top

    global vinv
    global vinv_left
    global vinv_top

    global vinv_bottom
    global vinv_bottom_left
    global vinv_bottom_top

    global vinv_right_half
    global vinv_right_half_left
    global vinv_right_half_top

    global vinv_left_half
    global vinv_left_half_left
    global vinv_left_half_top

    global vgame_screen
    global vgame_screen_left
    global vgame_screen_top

    global vchat_menu
    global vchat_menu_left
    global vchat_menu_top

    global vchat_menu_recent
    global vchat_menu_recent_left
    global vchat_menu_recent_top

    (client_status, anchor) = orient(display_width=DISPLAY_WIDTH,
                                     display_height=DISPLAY_HEIGHT)
    (vclient_left, vclient_top) = anchor

    if client_status == 'logged_in':
        vclient_left -= 735
        vclient_top -= 21
    elif client_status == 'logged_out':
        vclient_left -= 183
        vclient_top -= 59

    # Now we can create an object with the game client's X and Y
    #   coordinates. This will allow other functions to search for
    #   needles within the "client" object's coordinates, rather than
    #   within the entire display's coordinates, which is much faster.
    vclient = Vision(left=vclient_left, width=CLIENT_WIDTH,
                     top=vclient_top, height=CLIENT_HEIGHT)

    # The player's inventory.
    vinv_left = vclient_left + 548
    vinv_top = vclient_top + 205
    vinv = Vision(left=vinv_left, top=vinv_top,
                  width=INV_WIDTH, height=INV_HEIGHT)

    # Bottom half of the player's inventory.
    vinv_bottom_left = vinv_left
    vinv_bottom_top = vinv_top + INV_HALF_HEIGHT
    vinv_bottom = Vision(left=vinv_bottom_left, top=vinv_bottom_top,
                         width=INV_WIDTH, height=INV_HALF_HEIGHT)

    # Right half of the player's inventory.
    vinv_right_half_left = (vinv_left + INV_HALF_WIDTH) - 5
    vinv_right_half_top = vinv_top
    vinv_right_half = Vision(left=vinv_right_half_left,
                             top=vinv_right_half_top,
                             width=INV_HALF_WIDTH,
                             height=INV_HEIGHT)

    # Left half of the player's inventory.
    vinv_left_half_left = vinv_left
    vinv_left_half_top = vinv_top
    vinv_left_half = Vision(left=vinv_left_half_left,
                            top=vinv_left_half_top,
                            width=INV_HALF_WIDTH,
                            height=INV_HEIGHT)

    # Gameplay screen.
    vgame_screen_left = vclient_left + 4
    vgame_screen_top = vclient_top + 4
    vgame_screen = Vision(left=vgame_screen_left, top=vgame_screen_top,
                          width=GAME_SCREEN_WIDTH, height=GAME_SCREEN_HEIGHT)

    # Chat menu.
    vchat_menu_left = vclient_left + 7
    vchat_menu_top = vclient_top + 345
    vchat_menu = Vision(left=vchat_menu_left, top=vchat_menu_top,
                        width=CHAT_MENU_WIDTH, height=CHAT_MENU_HEIGHT)

    # The most recent chat message.
    vchat_menu_recent_left = vchat_menu_left - 3
    vchat_menu_recent_top = vchat_menu_top + 98
    vchat_menu_recent = Vision(left=vchat_menu_recent_left,
                               top=vchat_menu_recent_top,
                               width=CHAT_MENU_RECENT_WIDTH,
                               height=CHAT_MENU_RECENT_HEIGHT)

    # The entire display.
    vdisplay = Vision(left=0, width=DISPLAY_WIDTH,
                      top=0, height=DISPLAY_HEIGHT)
    return 0


def orient(display_width, display_height):
    """
    Look for an icon to orient the client. If it's found, use its
    location within the game client to determine the coordinates of
    the game client relative to the display's coordinates.

    This function is also used to determine if the client is logged out.

    Args:
        display_width (int): The total width of the display in pixels.
        display_height (int): The total height of the display in pixels.

    Raises:
       Raises a runtime error if the client cannot be found, or if the
       function can't determine if the client is logged in or logged
       out.

    Returns:
         If client is logged in, returns a string containing the text
         "logged_in" and a tuple containing the center XY coordinates of
         the orient needle.

         If client is logged out, returns a string containing the text
         "logged_out" and a tuple containing the center XY coordinates
         of the orient-logged-out needle.
    """

    logged_in = Vision(left=0, top=0,
                       width=display_width,
                       height=display_height) \
        .wait_for_image(needle='needles/minimap/orient.png',
                        loctype='center', loop_num=2, conf=0.8)
    if logged_in != 1:
        return 'logged_in', logged_in

    if logged_in == 1:

        # If the client is not logged in, check if it's logged out.
        logged_out = Vision(left=0, top=0,
                            width=display_width,
                            height=display_height) \
            .wait_for_image(needle='needles/login-menu/orient-logged-out.png',
                            loctype='center', loop_num=2)
        if logged_out != 1:
            return 'logged_out', logged_out

        elif logged_out == 1:
            log.critical('Could not find anchor!')
            raise RuntimeError('Could not find anchor!')


# TODO: Remove self.haystack functionality as smaller coordinate spaces
#  are used instead. Also, referring to both images and coordinate spaces
#  as "haystacks" is confusing.
class Vision:
    """
    The primary object method for locating images on the display. All
    coordinates are relative to the display's dimensions. Coordinate
    units are in pixels.

    Args:
        grayscale (bool): Converts the haystack to grayscale before
                          searching within it. Speeds up searching by
                          about 30%, default is false.
        left (int): The left edge (x) of the coordinate space to search
                    within for the needle.
        top (int): The top edge (y) of the coordinate space to search
                   within for the needle.
        width (int): The total x width of the coordinate space to search
                     within for the needle (going right from left).
        height (int): The total y height of the coordinate space to
                      search within for the needle (going down from
                      top).
    """

    def __init__(self, left, top, width, height, grayscale=False):
        self.grayscale = grayscale
        self.left = left
        self.top = top
        self.width = width
        self.height = height

    def mlocate(self, needle, loctype='regular', conf=0.95):
        """
        Searches the haystack image for the needle image, returning a
        tuple containing the needle's XY coordinates within the
        haystack. If a haystack image is not provided, this function
        searches the entire client window.

        Args:
            needle: The image to search within the haystack or
                    left/top/width/height coordinate space for.
                    Must be a filepath.
            loctype (str): The method and/or haystack used to search for
                           images. If a haystack is provided, this
                           parameter is ignored, default is regular.
                regular = Searches the client window. If the needle is
                          found, returns the needle's left, top, width,
                          and height.
                center = Searches the client window. If the needle is
                         found, returns the XY coordinates of its
                         center, relative to the coordinate plane of the
                         haystack image.
            conf (float): The confidence value required to match the
                          image successfully, expressed as a
                          decimal <= 1. This is used by Pyautogui,
                          default is 0.95.

        Returns:
            If the needle is found, and loctype is regular, returns the
            needle's left/top/width/height parameters as a tuple. If the
            needle is found and loctype is center, returns coordinates
            of the needle's center as a tuple. If the needle is not
            found, returns 1.
        """

        if loctype == 'regular':
            target_image = pag.locateOnScreen(needle,
                                              confidence=conf,
                                              grayscale=self.grayscale,
                                              region=(self.left,
                                                      self.top,
                                                      self.width,
                                                      self.height))
            if target_image is not None:
                log.debug('Found regular image ' + str(needle) + ', ' +
                          str(target_image))
                return target_image

            elif target_image is None:
                log.debug('Cannot find regular image ' + str(needle) +
                          ' conf=' + str(conf))
                return 1

        if loctype == 'center':
            target_image = pag.locateCenterOnScreen(needle,
                                                    confidence=conf,
                                                    grayscale=self.grayscale,
                                                    region=(self.left,
                                                            self.top,
                                                            self.width,
                                                            self.height))
            if target_image is not None:
                log.debug('Found center of ' + str(needle) + ', ' +
                          str(target_image))
                return target_image

            elif target_image is None:
                log.debug('Cannot find center of ' + str(needle) +
                          ', conf=' + str(conf))
                return 1

        else:
            raise RuntimeError('Incorrect mlocate function parameters!')

    def wait_for_image(self, needle, loctype='regular', conf=0.95,
                       loop_num=10, loop_sleep_min=10, loop_sleep_max=1000):
        """
        Repeatedly searches within the haystack or coordinate space
        for the needle.

        Args:
            needle: See mlocate()'s docstring.
            loctype (str): see mlocate()'s docstring, default is
                           regular.
            conf (float): See mlocate()'s docstring, default is 0.95
            loop_num (int): The number of times to search for
                            the needle before giving up, default is 10.
            loop_sleep_min (int): The minimum number of miliseconds to
                                  wait after each search attempt,
                                  default is 10.
            loop_sleep_max (int): The maximum number of miliseconds to
                                  wait after wach search attempt,
                                  default is 1000.

        Returns:
            See mlocate()'s docstring.
        """

        # log.debug('Looking for ' + str(needle))

        # Need to add 1 to loop_num because if range() starts at 0, the
        #   first loop will be the "0th" loop, which is confusing.
        for tries in range(1, (loop_num + 1)):

            target_image = Vision.mlocate(self,
                                          conf=conf,
                                          needle=needle,
                                          loctype=loctype)

            if target_image == 1:
                log.debug('Cannot find ' + str(needle) + ', tried '
                          + str(tries) + ' times.')
                misc.sleep_rand(loop_sleep_min, loop_sleep_max)

            else:
                log.debug('Found ' + str(needle) + ' after trying '
                          + str(tries) + ' times.')
                return target_image

        log.debug('Timed out looking for ' + str(needle) + '.')
        return 1

    def click_image(self, needle, button='left', conf=0.95,
                    loop_num=25, loop_sleep_min=10, loop_sleep_max=1000,
                    click_sleep_befmin=0, click_sleep_befmax=500,
                    click_sleep_afmin=0, click_sleep_afmax=500,
                    move_durmin=50, move_durmax=1500):
        """
        Moves the mouse to the provided needle image and clicks on
        it. If a haystack is provided, searches for the provided needle
        image within the haystack's coordinates. If a haystack is not
        provided, searches within the entire display.

        Args:
            needle (file): See mlocate()'s docstring.
            button (str): The mouse button to use when clicking on the,
                          default is left.
            conf (float): See mlocate()'s docstring, default is 0.95.
            loop_num (int): See wait_for_image()'s docstring, default is
                            25.
            loop_sleep_min (int): See wait_for_image()'s docstring,
                                  default is 10.
            loop_sleep_max (int): See wait_for_image()'s docstring,
                                  default is 1000.
            click_sleep_befmin (int): The minimum number of miliseconds
                                      to wait before clicking the
                                      needle, default is 0.
            click_sleep_befmax (int): The maximum number of miliseconds
                                      to wait before clicking the
                                      needle, default is 500.
            click_sleep_afmin (int): The minimum number of miliseconds
                                     to wait after clicking the
                                     needle, default is 0.
            click_sleep_afmax (int): The maximum number of miliseconds
                                     to wait after clicking the
                                     needle, default is 0.
            move_durmin (int): The minumum number of miliseconds to take
                               to move the mouse cursor to the needle,
                               default is 50.
            move_durmax (int): The maximum number of miliseconds to take
                               to move the mouse cursor to the needle,
                               default is 1500.

        Returns:
            See mlocate()'s docstring.
        """

        log.debug('Looking for ' + str(needle) + ' to click on.')

        target_image = self.wait_for_image(loop_num=loop_num,
                                           loop_sleep_min=loop_sleep_min,
                                           loop_sleep_max=loop_sleep_max,
                                           loctype='regular',
                                           needle=needle,
                                           conf=conf)
        if target_image == 1:
            return 1
        else:
            (left, top, width, height) = target_image
            # Randomize the location the pointer will move to using the
            #   dimensions of needle image.
            input.move_to(left, top,
                          xmin=0, xmax=width,
                          ymin=0, ymax=height,
                          durmin=move_durmin,
                          durmax=move_durmax)

            log.debug('Clicking on ' + str(needle) + '.')

            input.click(button=button,
                        sleep_befmin=click_sleep_befmin,
                        sleep_befmax=click_sleep_befmax,
                        sleep_afmin=click_sleep_afmin,
                        sleep_afmax=click_sleep_afmax)
            return 0
