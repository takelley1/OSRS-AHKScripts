from python.main import behavior as behav
from python.main import vision as vis


def miner_double_drop(rock1_full, rock1_empty, rock2_full, rock2_empty, ore):
    """
    A 2-rock drop mining script. The player alternates mining between
    two different rocks containing the same ore. Ore is dropped when
    inventory is full.

    Arguments:
        rock1_full: Filepath to a needle showing the first rock is full.
        rock1_empty: Filepath to a needle showing the first rock is empty.
        rock2_full: Filepath to a needle showing the second rock is full.
        rock2_empty: Filepath to a needle showing the second rock is empty.

        ore: Filepath to a needle of the item icon of the ore being mined.

    Reutrns:
        Returns 0 after emptying inventory.
    """

    (client, inv, game_screen, chat_menu) = vis.orient()

    while True:

        # Small chance to do nothing for a short while.
        behav.wait_rand(chance=100, wait_min=10000, wait_max=60000)

        # If first rock is full, begin mining it.
        rock1_full_var = game_screen.click_image(needle=rock1_full,
                                                 conf=0.85,
                                                 move_duration_min=10,
                                                 move_duration_max=500,
                                                 click_sleep_before_min=0,
                                                 click_sleep_before_max=100,
                                                 click_sleep_after_min=0,
                                                 click_sleep_after_max=100,
                                                 loop_sleep_min=100,
                                                 loop_sleep_max=100,
                                                 loop_num=1)
        if rock1_full_var != 1:

            # Before checking to see if the first rock is empty, check
            #   if the player's inventory is full.
            inv_full = chat_menu.wait_for_image(needle='./main/needles/'
                                                'chat-menu/'
                                                'mining-inventory-full.png',
                                                loop_num=1)

            # If the player's inventory is full, drop all ore.
            if inv_full != 1:
                inv.drop_all_item(item=ore)
                return 0

            # Wait until first rock is empty.
            game_screen.wait_for_image(rock1_empty,
                                       conf=0.85,
                                       loop_sleep_min=100, loop_sleep_max=100,
                                       loop_num=50)

        # If/when first rock is empty, check second rock.
        rock2_full_var = game_screen.click_image(needle=rock2_full,
                                                 conf=0.85,
                                                 move_duration_min=10,
                                                 move_duration_max=500,
                                                 click_sleep_before_min=0,
                                                 click_sleep_before_max=100,
                                                 click_sleep_after_min=0,
                                                 click_sleep_after_max=100,
                                                 loop_sleep_min=100,
                                                 loop_sleep_max=100,
                                                 loop_num=1)
        if rock2_full_var != 1:
            inv_full = chat_menu.wait_for_image(needle='./main/needles/'
                                                'chat-menu/mining-inventory-'
                                                'full.png',
                                                loop_num=1)
            if inv_full != 1:
                inv.drop_all_item(item=ore)
                return 0

            game_screen.wait_for_image(needle=rock2_empty,
                                       conf=0.85,
                                       loop_sleep_min=100, loop_sleep_max=100,
                                       loop_num=50)