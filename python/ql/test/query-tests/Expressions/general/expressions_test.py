#encoding: utf-8
def dup_key():
    return { 1: -1,
             1: -2,
             u'a' : u'A',
             u'a' : u'B'
            }

def simple_func(*args, **kwrgs): pass
#Unnecessary lambdas
lambda arg0, arg1: simple_func(arg0, arg1)
lambda arg0, *arg1: simple_func(arg0, *arg1)
lambda arg0, **arg1: simple_func(arg0, **arg1)
# these lambdas are_ necessary
lambda arg0, arg1=1: simple_func(arg0, arg1)
lambda arg0, arg1: simple_func(arg0, *arg1)
lambda arg0, arg1: simple_func(arg0, **arg1)
lambda arg0, *arg1: simple_func(arg0, arg1)
lambda arg0, **arg1: simple_func(arg0, arg1)

#Non-callable called
class NonCallable(object):
    pass
    
class MaybeCallable(Unknown, object):
    pass

def call_non_callable(arg):
    non = NonCallable()
    non(arg)
    ()()
    []()
    dont_know = MaybeCallable()
    dont_know() # Not a violation

#Explicit call to __del__
x.__del__()

#Unhashable object
def func():
    mapping = dict(); unhash = list()
    return mapping[unhash]

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
    arg is ''

#Non-container

class XIter(object):
    #Support both 2 and 3 form of next, but omit __iter__ method    
    
    def __next__(self):
        pass

    def next(self):
        pass

def non_container():

    seq = XIter()
    if 1 in seq:
        pass
    if 1 not in seq:
        pass

#Container inheriting from builtin
class MyDict(dict):
    pass

class MySequence(UnresolvablebaseClass):
    pass

def is_container():
    mapping = MyDict()
    if 1 in mapping:
        pass
    seq = MySequence()
    if 1 in seq:
        pass 
    seq = None
    if seq is not None and 1 in seq:
        pass

#Equals none

def x(arg):
    return arg == None

class NotMyDict(object):
    
    def f(self):
        super(MyDict, self).f()

# class defining __del__
class Test(object):
    def __del__(self):
        pass

# subclass
class SubTest(Test):
    def __del__(self):
        # This is permitted and required.
        Test.__del__(self)
        # This is a violation.
        self.__del__()
        # This is an alternate syntax for the super() call, and hence OK.
        super(SubTest, self).__del__()
        # This is the Python 3 spelling of the same.
        super().__del__()

#Some more lambdas
#Unnecessary lambdas
lambda arg0: len(arg0)
lambda arg0: XIter.next(arg0)
class UL(object):
    
    def f(self, x):
        pass
    
    def g(self):
        return lambda x: self.f(x)

# these lambdas are necessary
lambda arg0: XIter.next(arg0, arg1)
lambda arg0: func()(arg0)
lambda arg0, arg1: arg0.meth(arg0, arg1)

#Cannot flag lists as unhashable if the object 
#we are subscripting may be a numpy array
def func(maybe_numpy):
    unhash = list()
    return maybe_numpy[unhash]

#Guarded non-callable called
def guarded_non_callable(cond):
    if cond:
        val = []
    else:
        val = func
    if hasattr(val, "__call__"):
        x(1)


#ODASA-4056
def format_string(s, formatter='minimal'):
    """Format the given string using the given formatter."""
    if not callable(formatter):
        formatter = get_formatter_for_name(formatter)
    if formatter is None:
        output = s
    else:
        output = formatter(s)
    return output

#ODASA-4614
def f(x):
    d = {}
    d['one'] = {}
    d['two'] = 0
    return x[d['two']]

#ODASA-4055
class C:

    def _internal(arg):
        # arg is not a C
        def wrapper(args):
            return arg(args)
        return wrapper

    @_internal
    def method(self, *args):
        pass

#ODASA-4689
class StrangeIndex:
  def __getitem__(self,index):
    return 1

x = StrangeIndex();
print(x[{'a': 'b'}])

def not_dup_key():
    return { u'a' : 0,
             b'a' : 0,
            u"😄" : 1,
            u"😅" : 2,
            u"😆" : 3
            }

# Lookup of unhashable object triggers TypeError, but the
# exception is caught, so it's not a bug. This used to be
# a false positive of the HashedButNoHash query.
def func():
    unhash = list()
    try:
      hash(unhash)
    except TypeError:
      return 1
    return 0

def func():
    mapping = dict(); unhash = list()
    try:
      mapping[unhash]
    except TypeError:
      return 1
    return 0

# False positive for py/member-test-non-container

# Container wrapped in MappingProxyType
from types import MappingProxyType

def mpt_arg(d=MappingProxyType({})):
    return 1 in d







#### UseofApply.ql

# Use of the builtin function `apply` is generally considered bad now that the
# ability to destructure lists of arguments is possible, but we should not flag
# cases where the function is merely named `apply` rather than being the actual
# builtin `apply` function.

def useofapply():
  
  def foo():
    pass



  # Positive Cases

  # This use of `apply` is a reference to the builtin function and so SHOULD be
  # caught by the query.
  apply(foo, [1])



  # Negative Cases

  # This use of `apply` is a reference to the locally defined function inside of
  # `local`, and so SHOULD NOT be caught by the query.  
  def local():
    def apply(f):
      pass
    apply(foo)([1])
