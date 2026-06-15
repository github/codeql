import module1 # $ Alert[py/cyclic-import]

class Foo(object):
    a = module1.a1