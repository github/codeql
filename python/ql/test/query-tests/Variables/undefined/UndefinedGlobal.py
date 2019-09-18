from ud_helper import d
import ud_helper as helper
from ud_helper import *
try:
    import __builtin__ as B
except:
    import builtins as B
defined = 2
#Monkey patch some builtins
B.__dict__["monkey1"] = 1
setattr(B, "monkey2", 2)
B.monkey3 = 3

def f(parameter):
    parameter
    local = 3
    local
    d # Explicitly from ud_helper
    helper  # Explicitly as import
    a # Imlicitly from ud_helper
    defined
    ug2 # ERROR
    e # ERROR Defined in ud_helper, but not in __all__
    int
    float
    __file__ #OK all files have __file__ defined
    __path__ #ERROR only modules have __path__ defined

    len #Ok defined in builtins
    monkey1 #Ok monkey-patched builtins
    monkey2 #Ok monkey-patched builtins
    monkey3 #Ok monkey-patched builtins
    
import sys
if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('usage')
        sys.exit(0)
    elif ('-s' in sys.argv):
        server = sys.argv[2]
    else:
        server = '127.0.0.1'
    server

#Check that builtins are always defined even if conditionally shadowed.
bool

if d:
    bool = int

bool
def t2():
    return bool
       
def f():
    
    global local_global
    local_global = 1
    
    local_global

#ODASA-2021
from elsewhere import gflags, a_function


def usage_and_quit():
    print("Usage: unusable")
    sys.exit(1)


def main():

    global from_hdb
    try:
        # Because of from_hdb, get_mp_hashes.py has a lot of extra unique flags
        gflags.DEFINE_bool("from_hdb", False, "")

        from_hdb = gflags.FLAGS.from_hdb

    except Exception as ex:
        usage_and_quit(str(ex))

    if not from_hdb:
        a_function()
    
#ODASA-2432
def globals_guard():
    if 'varname' in globals():
        f(varname)

#Example taken from logging module
try:
    import module1
    import module2
except ImportError:
    module1 = None 


if module1:
    inst = module2.Class()

#Some possible false positives, observed in ERP5.
if 1:
    pfp1 = 1

pfp1

def outer():
    global pfp2
    pfp2 = 2
    def inner():
        global pfp2
        pfp2 += 1

class Cls(object):
    global pfp3
    pfp3 = 3
    def inner():
        global pfp3
        pfp3 += 1

def only_report_once():
    ug3
    ug3
    ug3
    ug3

#ODASA-5381
from _ast import *

try:
    NameConstant
except NameError:
    NameConstant = Name

#ODASA-5486
class modinit:

    global _time
    import time
    _time = time
    try:
        import datetime
        _pydatetime = datetime.datetime
    except ImportError:
        # Set them to (), so that isinstance() works with them
        _pydatetime = ()

del modinit

# FP occurs in line below
def _isstring(arg, isinstance=isinstance, t=_time):
    pass

#ODASA-4688
def outer():
    def inner():
        global glob
        glob = 'asdf'
        print(glob[2])

    def otherInner():
        print(glob[3])

    inner()


#ODASA-5896
guesses_made = 0
while guesses_made < 6:  # This loop is guaranteed to execute at least once.
    guess = int(input('Take a guess: '))
    guesses_made += 1

if guess == 1017: # FP here
   pass

