# encoding: utf-8
# import pyximport
# pyximport.install(pyimport=True)
import time
import random
import pyautogui


def keypress(key):
    """Holds down the specified key for a short period of time."""
    time.sleep(float(random.randint(500, 1000)) / 1000)
    pyautogui.keyDown(key)
    time.sleep(float(random.randint(5, 190)) / 1000)
    pyautogui.keyUp(key)
    time.sleep(float(random.randint(500, 1000)) / 1000)
    return


def hotkey(key1, key2):
    """Perform a two-key hotkey shortcut, such as Ctrl-c for copying."""
    time.sleep(float(random.randint(500, 1000)) / 1000)
    pyautogui.keyDown(key1)
    time.sleep(float(random.randint(10, 500)) / 1000)
    pyautogui.keyDown(key2)
    time.sleep(float(random.randint(10, 500)) / 1000)
    pyautogui.keyUp(key1)
    time.sleep(float(random.randint(10, 500)) / 1000)
    pyautogui.keyUp(key2)
    time.sleep(float(random.randint(500, 1000)) / 1000)
    return
