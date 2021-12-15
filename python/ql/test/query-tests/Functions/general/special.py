
#Special 
class C(object):

    def __init__(self):
        pass

    def __enter__(self):
        pass

    def __exit__(self, *args):
        pass

    def __get__(self, *args):
        pass

from zope.interface import Interface

class I(Interface):
    pass

class M(I):

    def __setattr__(name, value):
        pass

    def __getitem__(name):
        pass
