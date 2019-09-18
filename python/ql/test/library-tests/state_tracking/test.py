# We must initialize before we frobnicate and we must frobnicate before exacerbating.

#Keep these functions at low line numbers to keep test results tidy.
def initialize():
    pass

def frobnicate():
    pass

def exacerbate():
    pass

def defrobnicate():
    pass





#Actual code of interest after line 20
def good1():
    initialize()
    frobnicate()
    exacerbate()

def good2(test):
    if test:
        initialize()
    if test:
        frobnicate()

def init_and_frob():
    initialize()
    frobnicate()

def good3():
    init_and_frob()
    exacerbate()

def bad1():
    #No init
    frobnicate()
    exacerbate()

def bad2():
    initialize()
    #No frobnicate
    exacerbate()

def bad3():
    exacerbate()

def good4(frob):
    initialized = False
    if frob:
        initialize()
        initialized = True
    if initialized:
        frobnicate()
        exacerbate()

def bad4(frob):
    if frob:
        initialize()
    frobnicate()
    exacerbate()

def on_off():
    initialize()
    frobnicate()
    exacerbate()
    defrobnicate()
    frobnicate()
    defrobnicate()
    exacerbate()
