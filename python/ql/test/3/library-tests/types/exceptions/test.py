    
def f4():
    a.write(x)

def io(x):
    x.read()
    try:
        x.write()
    except IOError:
        pass
