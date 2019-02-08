
class Meta1(type):
    pass

class Meta2(type):
    pass


class C1(object):
    __metaclass__ = Meta1

class C2(object):
    __metaclass__ = Meta2


#No explicit metaclass
class C3(object):
    pass

#Multiple non-conflicting metaclasses:
class C4(C2, object):
    pass

#Metaclass conflict
class C5(C2, C1):
    pass

class NoDeclaredMetaclass:
    pass

__metaclass__ = type

class NewStyleEvenForPython2:
    pass
