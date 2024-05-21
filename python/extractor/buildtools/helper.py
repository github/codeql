import os
import traceback
import re


SCRIPTDIR = os.path.split(os.path.dirname(__file__))[1]


def print_exception_indented(opt=None):
    exc_text = traceback.format_exc()
    for line in exc_text.splitlines():
        # remove path information that might be sensitive
        # for example, in the .pyc files for Python 2, a traceback would contain
        # /home/rasmus/code/target/thirdparty/python/build/extractor-python/buildtools/install.py
        line = re.sub(r'File \".*' + SCRIPTDIR + r'(.*)\",', r'File <'+ SCRIPTDIR + r'\1>', line)
        print('    ' + line)
