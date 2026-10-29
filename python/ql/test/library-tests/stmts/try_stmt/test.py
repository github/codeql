
def f():
    try:
        call()
        try:
            nested()
        except Exception:
            return 1
    except:
        return 2
    
    try:
        call2()
    except Exception:
        return 2
    
    try:
        call3a()
    finally:
        call3b()