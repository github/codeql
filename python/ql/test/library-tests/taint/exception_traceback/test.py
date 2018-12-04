from __future__ import print_function

import traceback
import sys

class MyException(Exception):
    pass

def raise_secret_exception():
    raise MyException("Message", "secret info")

def foo():
    try:
        raise_secret_exception()
    except Exception as e:
        s = traceback.format_exc()
        print(s)
        etype, evalue, tb = sys.exc_info()
        t = traceback.extract_tb(tb)
        u = traceback.extract_stack()
        v = traceback.format_list(t)
        w = traceback.format_exception_only(etype, evalue)
        x = traceback.format_exception(etype, evalue, tb)
        y = traceback.format_tb(tb)
        z = traceback.format_stack()
        message, args = e.message, e.args
        print(tb, t, u, v, w, x, y, z, message, args)


foo()


#For test to find stdlib
import os
