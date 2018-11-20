

class BaseClass(object):

    cls_attr = 0

    def __init__(self):
        self.shadowing = 2

class DerivedClass(BaseClass):

    cls_attr = 3
    shadowing = 5

    def __init__(self):
        BaseClass.__init__(self)
        self.inst_attr = 4

    def method(self):
        self.cls_attr
        self.inst_attr
        self.shadowing

#ODASA-3836
def comprehensions_and_generators(seq):
    [y*y for y in seq]
    (y*y for y in seq)
    {y*y for y in seq}
    {y:y*y for y in seq}

#ODASA-5391
@decorator(x)
class Decorated(object):
    pass

d = Decorated()

import module as thing
from module import foo
foo
thing.bar

from package import x
import package as p
p.x
