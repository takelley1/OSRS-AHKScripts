import pyautogui as pag

from ocvbot import input, misc, vision


def main():
    """
    Automatically logs the client in using credentials specified in a file.
    """

    vision.init_vision()
    from ocvbot.vision import vdisplay

    logged_out = vdisplay.click_image(needle='./needles/login-menu'
                                             '/orient-logged-out.png')
    if logged_out == 1:
        raise RuntimeError("Cannot find client!")
    else:
        misc.sleep_rand(800, 3000)
        input.keypress('enter')
        misc.sleep_rand(800, 3000)
        pag.typewrite(open('username.txt', 'r').read())
        misc.sleep_rand(800, 3000)
        pag.typewrite(open('password.txt', 'r').read())
        misc.sleep_rand(800, 3000)
        input.keypress('enter')
        postlogin = vdisplay.click_image(needle='./needles/login-menu/'
                                                'orient-postlogin.png',
                                         conf=0.8,
                                         loop_num=10,
                                         loop_sleep_max=5000)
        if postlogin != 1:
            return 0
        else:
            raise RuntimeError("Cannot log in!")


if __name__ == '__main__':
    main()
