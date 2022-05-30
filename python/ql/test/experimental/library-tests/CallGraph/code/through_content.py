def my_func():
    print("my_func")

funcs = [my_func]
for f in funcs:
    f() # $ MISSING: tt=my_func
