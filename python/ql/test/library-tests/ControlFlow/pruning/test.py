#Test number of CFG nodes for each use of 'count'

def dead():
    return 0
    count

def conditional_dead(test):
    if test:
        return
    if test:
        count

def made_true(seq):
    if seq:
        return
    seq.append(1)
    if seq:
        count

def boolop(t1, t2, t3, t4, t5, t6):
    if not t1:
        return
    #bool(t1) must be True
    t1 or count
    t1 and count
    if t2:
        return
    #bool(t2) must be False
    t2 or count
    t2 and count
    if t3 or t4:
        t3 or count
        t3 and count
        t3 or count
        t4 and count
    if t5 and t6:
        t5 or count
        t5 and count
        t6 or count
        t6 and count

def with_splitting(t1, t2):
    if t1:
        if not t2:
            return
    #Cannot have bool(t1) be True and bool(t2) be False
    if t1:
        t2 or count #Unreachable
        t2 and count
    else:
        t2 or count
        t2 and count

def loops(seq1, seq2, seq3, seq4, seq5):
    if seq1:
        return
    if not seq2:
        return
    #bool(seq1) is False; bool(seq2) is True
    while seq1:
        count #This is unreachable, but the pop below forces us to be conservative.
        seq1.pop()
    while seq2:
        count
        seq2.pop()
    if seq3:
        return
    if not seq4:
        return
    #bool(seq3) is False; bool(seq4) is True
    for var in seq3:
        count #This is unreachable, but we cannot infer this yet.
        print(var)
    for var in seq4:
        count
        print(var)
    #seq5 false then made true
    if seq5:
        return
    seq5.append(1)
    for var in seq5:
        count
        print(var)

#Logic does not apply to global variables in calls,
#as they may be changed from true to false externally.
from some_module import x, y
if not x:
    raise Exception()
if y:
    raise Exception()
make_a_call()
if not x:
    count
if y:
    count

# However, modules are always true -- Which is important.
import another_module

make_a_call()
if not another_module:
    count


def negated_conditional_live(t1, t2):
    if not t1:
        return
    if t2:
        return
    if t1:
        count
    if not t2:
        count

def negated_conditional_dead(test):
    if not test:
        return
    if not test:
        count

def made_true2(m):
    if m:
        return
    del m['a']
    if m:
        count

def prune_const_branches():
    if None:
        count
    if not None:
        count
    if False:
        count
    else:
        count
    if True:
        count
    else:
        count
    if 0:
        count
    else:
        count
    if -4:
        count
    else:
        count
    #Muliptle nots
    if not not False:
        count
    if not not not False:
        count

#ODASA-6794
def attribute_lookup_cannot_effect_comparisons_with_immutable_constants(ps):
    if ps is not None:
        ps_clamped = ps.clamp()
    if ps is None:
        count
    else:
        count

def func():
    global escapes
    so_something()
    escapes = True

#Don't prune on `escapes` as it escapes.
if __name__ == '__main__':
    escapes = None # global
    try:
        func()
    except Exception as err:
        count
        if escapes is None:
            count
        else:
            count

def func2():
    while 1:
        count
        if cond12:
            count
            try:
                true12()
                count
            except IOError:
                true12 = 0
                count

def inequality1(x):
    if x < 4:
        return
    if x < 4:
        count

def inequality2(x):
    if x < 4:
        return
    if not x >= 4:
        count

def reversed_inequality(x):
    if x < 4:
        return
    if 4 > x:
        count


#Splittings with boolean expressions:
def split_bool1(x=None,y=None):
    if x and y:
        raise
    if not (x or y):
        raise
    if x:
        count
    else:
        count
    if y:
        count
    else:
        count

def prune_on_constant1():
    k = False
    if k:
        count
    else:
        count
    pass

def prune_on_constant2():
    k = 3
    if k:
        count
    else:
        count
    pass

def prune_on_constant3():
    k = None
    if k:
        count
    else:
        count
    pass

def prune_on_constant_in_test(a, b):
    if a:
        k = True
    else:
        k = False
    if k:
        count
    pass

def prune_on_constant_in_try():
    try:
        import foo
        var = True
    except:
        var = False
    if var:
        count
    pass
