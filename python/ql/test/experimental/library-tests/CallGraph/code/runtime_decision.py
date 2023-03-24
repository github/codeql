import sys
import random

# hmm, annoying that you have to keep names unique across files :|
# since I like to use foo and bar ALL the time :D

def rd_foo():
    print('rd_foo')

def rd_bar():
    print('rd_bar')

if len(sys.argv) >= 2 and not sys.argv[1] in ['0', 'False', 'false']:
    func = rd_foo
else:
    func = rd_bar

func() # $ pt,tt=rd_foo pt,tt=rd_bar

# Random doesn't work with points-to :O
if random.random() < 0.5:
    func2 = rd_foo
else:
    func2 = rd_bar

func2() # $ pt,tt=rd_foo pt,tt=rd_bar


# ==============================================================================
# definition is random

if random.random() < 0.5:
    def func3():
        print("func3 A")
else:
    def func3():
        print("func3 B")

func3() # $ pt,tt=33:func3 pt,tt=36:func3


# func4 uses same setup as func3, it's just defined in an other file
from code.runtime_decision_defns import func4
func4() # $ pt,tt="code/runtime_decision_defns.py:4:func4" pt,tt="code/runtime_decision_defns.py:7:func4"
