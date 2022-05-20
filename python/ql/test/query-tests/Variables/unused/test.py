
#Unused
def fail():
    for t in [TypeA, TypeB]:
        x = TypeA()
        run_test(x)

#OK by name
def OK1(seq):
    for _ in seq:
        do_something()
        print("Hi")

#OK counting
def OK2(seq):
    i = 3
    for x in seq:
        i += 1
    return i

#OK check emptiness
def OK3(seq):
    for thing in seq:
        return "Not empty"
    return "empty"

#OK iteration over range
def OK4(n):
    r = range(n)
    for i in r:
        print("x")

#OK named as unused
def OK5(seq):
    for unused_x in seq:
        print("x")

#ODASA-3794
def OK6(seq):
    for thing in seq:
        if sum(1 for s in STATUSES
               if thing <= s < thing + 100) >= quorum:
                    return True

#OK -- Implicitly using count
def OK7(seq):
    for x in seq:
        queue.add(None)

def OK8(seq):
    for x in seq:
        output.append("</item>")

#Likewise with parameters
def OK7(seq, queue):
    for x in seq:
        queue.add(None)

def OK8(seq, output):
    for x in seq:
        output.append("</item>")

#Not OK -- Use a constant, but also a variable
def fail2(sequence):
    for x in sequence:
        for y in sequence:
            do_something(x+1)

def fail3(sequence):
    for x in sequence:
        do_something(x+1)
    for y in sequence:
        do_something(x+1)

def fail4(coll, sequence):
    while coll:
        x = coll.pop()
    for s in sequence:
        do_something(x+1)

#OK See ODASA-4153 and ODASA-4533
def fail5(t):
    x, y = t
    return x


class OK9(object):
    cls_attr = 0
    def __init__(self):
        self.attr = self.cls_attr

__all__ = [ 'hello' ]
__all__.extend(foo())
maybe_defined_in_all = 17

#ODASA-5895
def rand_list():
    return [ random.random() for i in range(100) ]

def kwargs_is_a_use(seq):
    for arg in seq:
        func(**arg)

#A deletion is a use, but this is almost certainly an error
def cleanup(sessions):
    for sess in sessions:
        # Original code had some comment about deleting sessions
        del sess

# For SuspiciousUnusedLoopIterationVariable.ql
# ok
for x in list(range(100)):
        print('hi')

# ok
for y in list(list(range(100))):
        print('hi')
