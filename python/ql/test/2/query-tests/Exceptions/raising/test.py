

def ok():
    raise Exception, "message"

def bad1():
    ex = Exception, "message"
    raise ex

def bad2():
    raise (Exception, "message")

def bad3():
    ex = Exception, 
    raise ex, "message"
