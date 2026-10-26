def return_arg(arg):
    return arg

def my_func():
    print("my_func")

x = return_arg(my_func)  # $ pt,tt=return_arg
x() # $ pt=my_func MISSING: tt=my_func
