from MyPackage import Foo, ModuleWithAll

def top_level_function(x, /, y, *, z):
    return [x, y, z]

top_level_value = Foo.C1()

iC2 = Foo.C3.get_C2_instance()

f = ModuleWithAll.Foo()
b = ModuleWithAll.Bar()