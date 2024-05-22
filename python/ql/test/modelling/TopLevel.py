from MyPackage import Foo

def top_level_funciton(x, /, y, *, z):
    return [x, y, z]

top_level_value = Foo.C1()