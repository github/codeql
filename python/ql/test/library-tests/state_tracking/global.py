# We must initialize before we frobnicate and we must frobnicate before exacerbating.

from test import initialize, frobnicate, exacerbate
















#To keep test results tidy don't put any thing we want results for before line 20

def bad1():
    frobnicate()

def bad2():
    exacerbate()

def good():
    exacerbate()

bad2()
bad1()
initialize()
good()