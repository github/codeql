#There is no xxxx, rely on AbsentModule

import xxxx
xxxx

from xxxx import open

open()


#This is be present, so shouldn't be missing
import module

module

from xxxx import deco

@deco
def func1():
    pass

@deco(0)
def func2():
    pass

@deco(undefined)
def func3():
    pass

@deco(open)
def func4():
    pass

func1
func2
func3
func4
