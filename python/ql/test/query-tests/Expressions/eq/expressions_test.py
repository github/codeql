


























#OK as we are using identity tests for unique objects
V2 = "v2"
V3 = "v3"

class C:
    def __init__(self, c):
        if c:
            self.version = V2
        else:
            self.version = V3

    def meth(self):
        if self.version is V2:    #FP here.
            pass


#Using 'is' when should be using '=='
s = "Hello " + "World"
if "Hello World" is s:
    print ("OK")

#This is OK in CPython, but may not be portable
s = str(7)
if "7" is s:
    print ("OK")

#And some data flow
CONSTANT = 20
if x is CONSTANT:
    print ("OK")

#This is OK
x = object()
y = object()
if x is y:
    print ("Very surprising!")

#This is also OK
if s is None:
    print ("Also surprising")

#Portable is comparisons
def f(arg):
    arg is ()
    arg is 0

class C(object):
    def __eq__(self, other):
        '''
        'is' must be fine here.
        '''
        return self is other

#Was FP -- https://github.com/lgtmhq/lgtm-queries/issues/13
def both_sides_known(zero_based="auto", query_id=False):
    if query_id and zero_based == "auto":
        zero_based = True
    if zero_based is False: # False positive here
        pass

#Avoid depending on enum back port for Python 2 tests:
class Enum(object):
    pass

class MyEnum(Enum):

    memberA = None
    memberB = 10
    memberC = ("Hello", "World")

def comp_enum(x):
    if x is MyEnum.memberA:
        return
    if x is MyEnum.memberB:
        return
    if x is MyEnum.memberC:
        return

