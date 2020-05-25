import logging as log

from ocvbot import behavior as behav, input


def miner_double_drop(rock1, rock2, ore,
                      drop_sapphire=True,
                      drop_emerald=True,
                      drop_ruby=True,
                      drop_diamond=True,
                      drop_clue_geode=True):
    """
    A 2-rock drop mining script.

    This function alternates mining between two different rocks that
    contain the same type of ore. All mined ore, gems, and clue geodes
    are dropped by default when the inventory becomes full.

    Args:
        rock1 (tuple): Tuple containing two filepaths: The first file
                       must be a needle showing the first rock is
                       full. The second file must be a needle showing
                       the first rock is empty.
        rock2 (tuple): Tuple containing two filepaths: The first file
                       must be a needle showing the second rock is
                       full. The second file must be a needle showing
                       the second rock is empty.
        ore (file): Filepath to a needle of the item icon of the ore
                    being mined, as it appears in the player's
                    inventory.
        drop_sapphire (bool): Drop mined uncut sapphires, default is
                              True.
        drop_emerald (bool): Drop mined uncut emearalds, default is
                             True.
        drop_ruby (bool): Drop mined uncut rubies, default is True.
        drop_diamond (bool): Drop mined uncut diamonds, default is True.
        drop_clue_geode (bool): Drop mined uncut clue geodes, default is
                                True.

    Reutrns:
        Always returns 0.
    """

    # Vision objects have to be imported within functions because the
    #   init_vision() function has to run before the objects get valid
    #   values.
    from ocvbot.vision import vchat_menu, vchat_menu_recent, vgame_screen

    log.info('drop_sapphire= ' + str(drop_sapphire) +
             ' drop_emerald= ' + str(drop_emerald) +
             ' drop_ruby= ' + str(drop_ruby) +
             ' drop_diamond= ' + str(drop_diamond) +
             ' drop_clue_geode= ' + str(drop_clue_geode))

    for attempts in range(1, 100):

        for rock_needle in (rock1, rock2):
            # Unpack the "rock_needle" tuple to obtain "full" and
            #   "empty" versions of each needle.
            (rock_full_needle, rock_empty_needle) = rock_needle

            log.info('Searching for ore ' + str(attempts) + '...')

            # If current rock is full, begin mining it.
            rock_full = vgame_screen.click_image(needle=rock_full_needle,
                                                 conf=0.8,
                                                 move_durmin=5,
                                                 move_durmax=500,
                                                 click_sleep_befmin=0,
                                                 click_sleep_befmax=100,
                                                 click_sleep_afmin=0,
                                                 click_sleep_afmax=1,
                                                 loop_sleep_max=100,
                                                 loop_num=1)
            if rock_full != 1:
                # Move the mouse away from the rock so it doesn't
                #   interfere with matching the needle.
                input.moverel(xmin=15, xmax=100, ymin=15, ymax=100)
                log.info('Waiting for mining to start.')

                # Small chance to do nothing for a short while.
                behav.wait_rand(chance=100, wait_min=10000, wait_max=60000)

                # Once the rock has been clicked on, wait for mining to
                #   start by monitoring chat.
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
                        if drop_sapphire is True:
                            behav.drop_item(item='./needles/items/'
                                                 'uncut-sapphire.png')
                        if drop_emerald is True:
                            behav.drop_item(item='./needles/items/'
                                                 'uncut-emerald.png')
                        if drop_ruby is True:
                            behav.drop_item(item='./needles/items/'
                                                 'uncut-ruby.png')
                        if drop_diamond is True:
                            behav.drop_item(item='./needles/items/'
                                                 'uncut-diamond.png')
                        if drop_clue_geode is True:
                            behav.drop_item(item='./needles/items/'
                                                 'clue-geode.png')
                        return 0
                    elif inv_full == 1:
                        return 0

                log.info('Mining started.')

                # Wait until the rock is empty by waiting for the
                #   "empty" version of the rock_needle tuple.
                rock_empty = vgame_screen.wait_for_image(
                                                    needle=rock_empty_needle,
                                                    conf=0.85,
                                                    loop_num=100,
                                                    loop_sleep_min=100,
                                                    loop_sleep_max=200)

                if rock_empty != 1:
                    log.info('Rock is empty.')
                    log.debug(str(rock_needle) + ' empty.')
                elif rock_empty == 1:
                    log.info('Timed out waiting for mining to finish.')
    return 0
