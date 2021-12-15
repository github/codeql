def test():
    var = 1 
    def print_var():
        print var      # Use variable from outer scope
    print_var()
    print var 


def test1():
    var = 2 
    def print_var():
        print var       # Attempt to use variable from local scope. 
        var = 3         # Since this is not initialized yet, this results
    print_var()         # in an UnboundLocalError
    print var 


def test2():
    var = 2 
    def print_var():
        var = 3         # Initialize local version of the variable
        print var       # Use variable from local scope.
    print_var()         # Note that this local variable "shadows" the variable from
    print var           # outer scope which makes code more difficult to interpret.


def test3():
    var = 4
    def print_var():
        nonlocal var    # Use non-local variable from outer scope.
        print var
    print_var()
    print var