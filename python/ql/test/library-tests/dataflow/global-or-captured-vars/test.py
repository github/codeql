import threading 
import time

# Test 1
# TP - Flow is tracked through a global variable
foo1 = None

def bar1():
    time.sleep(1)
    ensure_tainted(foo1) # $tainted

# The intent of these tests is to test how dataflow is handled through shared state accessed by different threads; 
# but the presense or absense of the actual call to start a thread does not affect the results (there is no special modelling for Thread)
# threading.Thread(target=bar).start() 

foo1 = TAINTED_STRING

# Test 2
# FN - Flow is *not* tracked through an access path on a global variable
foo2 = []

def bar2():
    time.sleep(1)
    ensure_tainted(foo2[0]) # $MISSING:tainted

threading.Thread(target=bar2).start()

foo2.append(TAINTED_STRING)

# Test 3
# FN - Flow is not found even when there is a direct call
foo3 = []

def bar3():
    time.sleep(1)
    ensure_tainted(foo2[0]) # $MISSING:tainted

foo3.append(TAINTED_STRING)
bar3()

# Tast 4
# TP - Sanity check: Flow is found through a ListElement directly without a call
foo4 = []
foo4.append(TAINTED_STRING)
ensure_tainted(foo4[0]) # $tainted

# Test 5
# FN - Flow is *not* tracked through a shared captured but non-global variable
def test5():
    foo5 = None 

    def bar5():
        time.sleep(1)
        ensure_tainted(foo5) # $MISSING:tainted

    threading.Thread(target=bar5).start() # Only the presense of this thread call makes this an FN rather than a TN

    foo5 = TAINTED_STRING

 # Test 6
 # TP - Flow is tracked through a shared captured but non-global variable with a direct call
def test6():
    foo6 = []

    def bar6():
        time.sleep(1)
        ensure_tainted(foo[0]) # $tainted

    foo6.append(TAINTED_STRING)
    bar6()


# Test 7
# FN - Flow is *not* found through an access path on a global variable that's also used as a parameter
# We'd like to cover this case in order to be able to cover this CVE: https://github.com/github/codeql-python-CVE-coverage/issues/3176

foo7 = []

def bar7():
    time.sleep(1)
    ensure_tainted(foo7[0]) # $MISSING: tainted

def baz7(loc_foo):
    loc_foo.append(TAINTED_STRING)

threading.Thread(target=bar7).start()

baz7(foo7)