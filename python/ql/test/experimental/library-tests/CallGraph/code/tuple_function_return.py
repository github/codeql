def func():
    print("func()")

def return_func():
    return func

def return_func_in_tuple():
    return (func, 42)

f1 = return_func() # $ pt,tt=return_func
f1() # $ pt,tt=func


f2, _ = return_func_in_tuple() # $ pt,tt=return_func_in_tuple
f2() # $ pt=func MISSING: tt
