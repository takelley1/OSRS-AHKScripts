import logging as log
import sys
import python.main.vision as vision
import yaml
sys.setrecursionlimit(9999)


# Search for the 'anchor image'.
# This will provide the basis for the client's the coordinate system.
def orient():
    global client_xmin
    global client_ymin
    anchor = vision.Vision(needle='./main/needles/menu/prayers.png').\
                                                                wait_for_image()
    if anchor is None:
        log.fatal('Cannot find anchor image ' + str(anchor) + ' on client!')
        return 1
    else:
        log.debug('Found anchor' + str(anchor))
        (client_xmin, client_ymin) = anchor
        # Move the origin up and to the left slightly to get it to the exact top
        # left corner of the eve client window.
        #   This is necessary because the image
        # searching algorithm returns coordinates to the center of the image
        #   rather than its top right corner.
        return 0

# Read config file and get client resolution.
#with open('./config.yaml') as f:
    #config = yaml.safe_load(f)

#client_xmax = config['client_width']
#client_ymax = config['client_height']

client_xmin = 0
client_ymin = 0

client_xmax = 1920
client_ymax = 1080
