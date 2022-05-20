import sys
import random

# hmm, annoying that you have to keep names unique accross files :|
# since I like to use foo and bar ALL the time :D

# name:rd_foo
def rd_foo():
    print('rd_foo')

# name:rd_bar
def rd_bar():
    print('rd_bar')

if len(sys.argv) >= 2 and not sys.argv[1] in ['0', 'False', 'false']:
    func = rd_foo
else:
    func = rd_bar

# calls:rd_foo calls:rd_bar
func()

# Random doesn't work with points-to :O
if random.random() < 0.5:
    func2 = rd_foo
else:
    func2 = rd_bar

# calls:rd_foo calls:rd_bar
func2()
