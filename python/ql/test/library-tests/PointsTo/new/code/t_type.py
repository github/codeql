import sys

class C(object):
    pass

type(C())
type(sys)
from module import unknown
type(unknown)
type(name, (object,), {})

def k(arg):
    type(C())
    type(sys)
    type(arg)
    type(name, (object,), {})
