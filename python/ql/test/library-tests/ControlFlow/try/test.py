#Test that the flow control through nested trys is handled correctly.

def f1():
    try:
        x = call()
    finally:
        try:
            another_call()
        except:
            pass
    return x

def f2():
    try:
        x = call()
    except:
        try:
            another_call()
        finally:
            x = 0
    return x

def f3():
    try:
        x = call()
    except:
        try:
            another_call()
        except:
            pass
    return x

def f4():
    try:
        x = call()
    finally:
        try:
            another_call()
        finally:
            x = 0
    return x

