
class Meta1(type):
    pass

class Meta2(type):
    pass

class C1(metaclass=Meta1):
    pass

class C2(metaclass=Meta2):
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
