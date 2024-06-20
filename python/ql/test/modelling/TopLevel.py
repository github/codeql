from MyPackage import Foo

def top_level_funciton(x, /, y, *, z):
    return [x, y, z]

top_level_value = Foo.C1()

iC2 = Foo.C3.get_C2_instance()