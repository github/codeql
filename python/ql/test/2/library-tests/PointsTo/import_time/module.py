
import sys

os_test = sys.platform == "linux2"
version_test = sys.version_info < (3,)
if version_test:
    version_2 = True
else:
    version_3 = False