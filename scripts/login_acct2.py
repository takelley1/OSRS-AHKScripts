from ocvbot import vision, behavior as behav


def main():
    """
    Automatically logs the client in using credentials specified in a file.
    """

    vision.init_vision()
    behav.login(username_file='credentials/username_ironman.txt',
                password_file='credentials/password_ironman.txt')


if __name__ == '__main__':
    main()
