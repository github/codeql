

def ok():
    raise Exception, "message"

def bad1():
    ex = Exception, "message"
    raise ex # $ Alert

def bad2():
    raise (Exception, "message") # $ Alert

def bad3():
    ex = Exception, 
    raise ex, "message" # $ Alert
