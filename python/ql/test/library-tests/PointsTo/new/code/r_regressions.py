#Assorted regressions and test cases

# FP for None spotted during development
# in multiprocessing/queue.py
class Queue(object):

    def __init__(self):

        self._after_fork()

    def _after_fork(self):
        self._closed = False
        self._close = None

    def close(self):
        self._closed = True
        try:
            self._reader.close()
        finally:
            close = self._close
            if close:
                self._close = None
                close() # FP was here: None on exceptional branch


#ODASA-5018
def f(x,y=None, z=0):
    if (
        x
        and
        y
    ) or (
        y
        and
        not
        z
    ):
        #y cannot be None here.
        use(y)

#from Ansible
def find_library(name):
    [data, _] = x()
    return data

def fail(msg):
    pass

class C(object):

    def fail(self, msg):
        fail(msg)

#The following challenge is provided for us by Django...

# The challenge here is that the decorator returned by this functions returns a different object
# depending on whether its argument is a class or not.
def method_decorator(decorator, name=''):
    # Original django comment and docstring removed.

    def _dec(obj):
        is_class = isinstance(obj, type)
        if is_class:
            do_validation()
        else:
            func = obj

        def _wrapper(self, *args, **kwargs):
            #Doesn't matter what this does.
            pass

        if is_class: 
            setattr(obj, name, _wrapper)
            return obj   # If obj is a class, we return it.

        return _wrapper # Otherwise we return the wrapper function.

    return _dec

def deco(func):
    def _wrapper(*args, **kwargs):
        return True
    return _wrapper

@method_decorator(deco, "method")
class TestFirst(object):
    def method(self):
        return "hello world"

TestFirst().method()  # TestFirst here should be the class, not the wrapper function...


import sys

_names = sys.builtin_module_names

if 'time' in _names:
    import time as t

gv = C()

unrelated_call()

gv

def mod_gv(x):
    gv.attr = x


