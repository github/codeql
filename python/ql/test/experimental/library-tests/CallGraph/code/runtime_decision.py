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

func() # $ pt=rd_foo pt=rd_bar

# Random doesn't work with points-to :O
if random.random() < 0.5:
    func2 = rd_foo
else:
    func2 = rd_bar

func2() # $ pt=rd_foo pt=rd_bar
