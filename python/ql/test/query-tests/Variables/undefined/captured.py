#!/usr/bin/python

def topLevel():
    foo = 3

    def bar():
        nonlocal foo
        print(foo)  # FP
        foo = 4

    bar()
    print(foo)

topLevel()
