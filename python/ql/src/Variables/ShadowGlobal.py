var = 2              # Global variable

def test2():
    def print_var():
        var = 3 
        print var    # Local variable which "shadows" the global variable
    print_var()      # making it more difficult to determine which "var"
    print var        # is referenced

test2()
