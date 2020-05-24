import logging as log

from ocvbot import behavior as behav, input


def miner_double_drop(rock1, rock2, ore):
    """
    A 2-rock drop mining script. The player alternates mining between
    two different rocks containing the same ore. All ore and gems are
    dropped when inventory is full.

    Args:
        rock1 (file): Filepath to a needle showing the first rock is
                      full.
        rock2 (file): Filepath to a needle showing the second rock is
                      full.
        ore (file): Filepath to a needle of the item icon of the ore
                    being mined.

    Reutrns:
        Always returns 0.
    """

    # Vision objects have to be imported within functions because the
    #   init_vision() function has to run before the objects get valid
    #   values.
    from ocvbot.vision import vchat_menu, vchat_menu_recent, vgame_screen

    for attempts in range(1, 50):

        for rock in (rock1, rock2):

            # Small chance to do nothing for a short while.
            behav.wait_rand(chance=200, wait_min=10000, wait_max=60000)

            log.info('Searching for ore ' + str(attempts) + '...')

            # If first rock is full, begin mining it.
            rock_full = vgame_screen.click_image(needle=rock,
                                                 conf=0.85,
                                                 move_durmin=10,
                                                 move_durmax=500,
                                                 click_sleep_befmin=0,
                                                 click_sleep_befmax=100,
                                                 click_sleep_afmin=0,
                                                 click_sleep_afmax=1,
                                                 loop_sleep_max=100,
                                                 loop_num=1)
            if rock_full != 1:
                # Move the mouse away from the rock so it doesn't interfere
                #   with matching the image.
                input.moverel(xmin=15, xmax=100, ymin=15, ymax=100)
                log.info('Waiting for mining to start.')

                # Once the rock has been clicked on, wait for mining to start
                #   by monitoring chat.
                mining_started = vchat_menu_recent. \
                    wait_for_image('./needles/chat-menu/'
                                   'mining-started.png',
                                   conf=0.9,
                                   loop_sleep_min=100,
                                   loop_sleep_max=200,
                                   loop_num=5)

                # If mining hasn't started after looping has finished,
                #   check to see if the inventory is full.
                if mining_started == 1:
                    log.debug('Timed out waiting for mining to start.')

                    inv_full = vchat_menu. \
                        wait_for_image(needle='./needles/chat-menu/'
                                              'mining-inventory-full.png',
                                       loop_num=1)
                    # If the inventory is full, empty the ore and
                    #   return.
                    if inv_full != 1:
                        log.info('Inventory is full.')
                        behav.drop_item(item=ore)
                        behav.drop_item(item='./needles/items/'
                                             'uncut-sapphire.png')
                        behav.drop_item(item='./needles/items/'
                                             'uncut-ruby.png')
                        behav.drop_item(item='./needles/items/'
                                             'uncut-emerald.png')
                        return 0
                    elif inv_full == 1:
                        return 0

                log.info('Mining started.')

                # Wait until the rock is empty by waiting until the
                #   "rock" needle can no longer be found.
                rock_status = vgame_screen.wait_for_image(needle=rock,
                                                          conf=0.7,
                                                          loop_num=1)
                tries = 0
                while rock_status != 1 and tries <= 20:
                    rock_status = vgame_screen.wait_for_image(needle=rock,
                                                              conf=0.7,
                                                              loop_num=1)
                    tries += 1

                if rock_status == 1:
                    log.info('Rock is empty.')
                    log.debug(str(rock) + ' empty.')
                elif tries > 20:
                    log.info('Timed out waiting for mining to finish.')
    return 0
