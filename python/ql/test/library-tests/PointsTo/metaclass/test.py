import six

class Meta1(type):
    pass

class Meta2(type):
    pass

@six.add_metaclass(Meta1)
class C1(object):
    pass

@six.add_metaclass(Meta2)
class C2(object):
    pass

#No explicit metaclass
class C3(object):
    pass

#Multiple non-conflicting metaclasses:
class C4(C2, object):
    pass

#Metaclass conflict
class C5(C2, C1):
    pass

@not_known_decorator
class C6(object):
    pass

__metaclass__ = type

class NewStyleEvenForPython2:
    pass
