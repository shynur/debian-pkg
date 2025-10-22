#! /bin/python3

import time
import datetime
import sys

while True:
    print(
        datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        file=sys.stderr
    )
    time.sleep(1)
