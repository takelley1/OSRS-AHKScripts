import logging as log
#import sys

from ocvbot import behavior as behav
from ocvbot import chat_menu, chat_menu_recent, game_screen


def miner_double_drop(rock1, rock2, ore):
    """
    A 2-rock drop mining script. The player alternates mining between
    two different rocks containing the same ore. Ore is dropped when
    inventory is full.

    Arguments:
        rock1: Filepath to a needle showing the first rock is full.
        rock1_empty: Filepath to a needle showing the first rock is empty.
        rock2: Filepath to a needle showing the second rock is full.
        rock2_empty: Filepath to a needle showing the second rock is empty.

        ore: Filepath to a needle of the item icon of the ore being mined.

    Reutrns:
        Returns 0 after emptying inventory.
    """

    for attempts in range(1, 50):

        for rock in (rock1, rock2):

            # Small chance to do nothing for a short while.
            behav.wait_rand(chance=100, wait_min=10000, wait_max=60000)

            log.info('Searching for ore ' + str(attempts) + '...')

            # If first rock is full, begin mining it.
            rock_full = game_screen.click_image(needle=rock,
                                                conf=0.9,
                                                move_duration_min=10,
                                                move_duration_max=500,
                                                click_sleep_before_min=0,
                                                click_sleep_before_max=100,
                                                click_sleep_after_min=0,
                                                click_sleep_after_max=100,
                                                loop_sleep_max=100,
                                                loop_num=1)
            if rock_full != 1:
                log.info('Waiting for mining to start.')

                # Once the rock has been clicked on, wait for mining to start
                #   by monitoring chat.
                mining_started = chat_menu_recent. \
                    wait_for_image('./ocvbot/needles/chat-menu/mining-started.png',
                                   conf=0.9,
                                   loop_sleep_min=100,
                                   loop_sleep_max=200,
                                   loop_num=5)

                # If mining hasn't started after looping has finished, check
                #   to see if the inventory is full.
                if mining_started == 1:
                    log.debug('Timed out waiting for mining to start.')

                    inv_full = chat_menu. \
                        wait_for_image(needle='./ocvbot/needles/chat-menu/'
                                              'mining-inventory-full.png',
                                       loop_num=1)
                    # If the inventory is full, empty the ore and return.
                    if inv_full != 1:
                        log.info('Inventory is full.')
                        behav.drop_item_rapid(item=ore)
                        return 0
                    elif inv_full == 1:
                        return 0

                log.info('Mining started.')

                # Wait until the rock is empty by waiting until the "rock"
                #   needle can no longer be found
                rock_status = game_screen.wait_for_image(needle=rock,
                                                         conf=0.75,
                                                         loop_num=1)
                tries = 0
                while rock_status != 1 and tries <= 20:
                    rock_status = game_screen.wait_for_image(needle=rock,
                                                             conf=0.75,
                                                             loop_num=1)
                    tries += 1

                if rock_status == 1:
                    log.info('Rock is empty.')
                    log.debug(str(rock) + ' empty.')
                elif tries > 20:
                    log.info('Timed out waiting for mining to finish.')
    return 0


'''

        # If first rock is full, begin mining it.
        rock1_full = game_screen.click_image(needle=rock1,
                                             conf=0.9,
                                             move_duration_min=10,
                                             move_duration_max=500,
                                             click_sleep_before_min=0,
                                             click_sleep_before_max=100,
                                             click_sleep_after_min=0,
                                             click_sleep_after_max=100,
                                             loop_sleep_max=100,
                                             loop_num=1)
        if rock1_full != 1:

            # Once the rock has been clicked on, wait for mining to start
            #   by monitoring chat.
            mining_started = chat_menu_recent.\
                wait_for_image('./ocvbot/needles/chat-menu/mining-started.png',
                               conf=0.9,
                               loop_sleep_min=100,
                               loop_sleep_max=200,
                               loop_num=8)

            # If mining hasn't started after looping has finished, check
            #   to see if the inventory is full.
            if mining_started == 1:
                inv_full = chat_menu.\
                    wait_for_image(needle='./ocvbot/needles/chat-menu/'
                                          'mining-inventory-full.png',
                                   loop_num=2)
                # If the inventory is full, empty the ore and return.
                if inv_full != 1:
                    inv.drop_all_item(item=ore)
                    return 0
                elif inv_full == 1:
                    return 0

            log.info('Mining started')

            # After mining has started, keep monitoring the chat to wait
            #   until it has finished
            chat_menu_recent.\
                wait_for_image('./ocvbot/needles/chat-menu/mining-finished.png',
                               conf=0.9,
                               loop_sleep_min=100,
                               loop_sleep_max=200,
                               loop_num=15)

            log.info('Mining started')

        # Once mining the first rock has finished, do the same thing for
        #   the second rock.
        rock2_full = game_screen.click_image(needle=rock2,
                                             conf=0.9,
                                             move_duration_min=10,
                                             move_duration_max=500,
                                             click_sleep_before_min=0,
                                             click_sleep_before_max=100,
                                             click_sleep_after_min=0,
                                             click_sleep_after_max=100,
                                             loop_sleep_max=100,
                                             loop_num=1)
        if rock2_full != 1:

            mining_started = chat_menu_recent.\
                wait_for_image('./ocvbot/needles/chat-menu/mining-started.png',
                               conf=0.9,
                               loop_sleep_min=100,
                               loop_sleep_max=200,
                               loop_num=8)
            if mining_started == 1:
                inv_full = chat_menu.\
                    wait_for_image(needle='./ocvbot/needles/chat-menu/'
                                          'mining-inventory-full.png',
                                   loop_num=1)
                if inv_full != 1:
                    inv.drop_all_item(item=ore)
                    return 0
                elif inv_full == 1:
                    return 0

            log.info('Mining started.')

            chat_menu_recent.\
                wait_for_image('./ocvbot/needles/chat-menu/mining-finished.png',
                               conf=0.9,
                               loop_sleep_min=100,
                               loop_sleep_max=200,
                               loop_num=15)

            log.info('Mining finished.')
'''
