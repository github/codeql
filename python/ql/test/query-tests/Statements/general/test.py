




def break_in_finally(seq, x):
    for i in seq:
        try:
            x()
        finally:
            break
    return 0

def return_in_finally(seq, x):
    for i in seq:
        try:
            x()
        finally:
            return 1
    return 0
    
#Break in loop in finally
#This is OK
def return_in_loop_in_finally(f, seq):
    try:
        f()
    finally:
        for i in seq:
            break
            
#But this is not
def return_in_loop_in_finally(f, seq):
    try:
        f()
    finally:
        for i in seq:
            return

def unnecessary_pass(arg):
    print (arg)
    pass

#Non-iterator in for loop

class NonIterator(object):

    def __init__(self):
        pass

for x in NonIterator():
    do_something(x)
    
#None in for loop

def dodgy_iter(x):
    if x:
        s = None
    else:
        s = [0,1]
    #Error -- Could be None
    for i in s:
        print(i)
    #Ok Test for None
    if s:
        for i in s:
            print(i)
    if s is not None:
        for i in s:
            print(i)

#OK to iterate over:
class GetItem(object):

    def __getitem__(self, i):
        return i

for y in GetItem():
    pass

class D(dict): pass

for z in D():
    pass










        
        
def modification_of_locals():
    x = 0
    locals()['x'] = 1
    l = locals()
    l.update({'x':1, 'y':2})
    l.pop('y')
    del l['x']
    l.clear()
    return x


#C-style things

if (cond):
    pass

while (cond):
    pass

assert (test)

def parens(x):
    return (x)


#ODASA-2038
class classproperty(object):

    def __init__(self, getter):
        self.getter = getter

    def __get__(self, instance, instance_type):
        return self.getter(instance_type)

class WithClassProperty(object):
    
    @classproperty
    def x(self):
        return [0]

wcp = WithClassProperty()

for i in wcp.x:
    assert x == 0
for i in WithClassProperty.x:
    assert x == 0

#Should use context mamager

class CM(object):
    
    def __enter__(self):
        pass
    
    def __exit__(self, ex, cls, tb):
        pass
    
    def write(self, data):
        pass

def no_with():
    f = CM()
    try:
        f.write("Hello ")
        f.write(" World\n")
    finally:
        f.close()

#Assert without side-effect
def assert_ok(seq):
    assert all(isinstance(element, (str, unicode)) for element in seq)

# False positive. ODASA-8042. Fixed in PR #2401.
class false_positive:
    e = (x for x in [])

