from __future__ import unicode_literals

def f(x):
    exec("raise thing")
    return x
