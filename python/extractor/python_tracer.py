#!/usr/bin/env python

#This file needs to be able to handle all versions of Python we are likely to encounter
#Which is probably 2.6 and upwards

'''This module sets up sys.path from the environment
and runs the populator when called from semmle tools such as buildSnapshot.'''

import sys
import os

# The constant is put here instead of make_zips.py, since make_zips.py is not present in
# the distributed extractor-python code
def getzipfilename():
    return 'python3src.zip'


def load_library():
    try:
        tools = os.environ['ODASA_TOOLS']
    except KeyError:
        try:
            tools = os.path.join(os.environ['SEMMLE_DIST'], "tools")
        except KeyError:
            tools = sys.path[0]
    try:
        zippath = os.path.join(tools, getzipfilename())
        sys.path = [ zippath ] + sys.path
    except Exception:
        #Failed to find tools. Error is reported below
        zippath = tools
    try:
        import semmle.populator
    except ImportError as ex:
        print("FATAL ERROR: ")
        print(ex)
        if tools is not None:
            if not os.path.exists(os.path.join(tools, getzipfilename())):
                sys.stderr.write("No tracer library found in " + tools + "\n")
            else:
                sys.stderr.write("Unable to load tracer library at %s:\n" % zippath)
                import traceback
                traceback.print_exc(file=sys.stderr)
        else:
            print(sys.path)
            sys.stderr.write("Cannot find Semmle tools\n")
        sys.exit(2)

if __name__ == "__main__":
    original_path = sys.path
    load_library()
    import semmle.populator
    semmle.populator.main(original_path)
