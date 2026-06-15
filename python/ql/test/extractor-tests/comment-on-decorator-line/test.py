def my_decorator(func):
    return func

@my_decorator # comment
def my_function():
    print("hello")

def unrelated_function(arg):
    # this uses match, so we trigger tsg parsing
    match arg:
        case _:
            print("ok")

my_function()
