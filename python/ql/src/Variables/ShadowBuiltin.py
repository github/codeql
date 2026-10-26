def test():
    int = 1           # Variable should be renamed to avoid
    def print_int():  # shadowing the int() built-in function
        print int
    print_int()
    print int 

test()
