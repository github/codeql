def func(func_arg):
    print("func")

    def func2():
        print("func2")
        return func_arg()

    func2()


def nop():
    print("nop")
    pass


func(nop)


"""
Needs handling of LOAD_DEREF. Disassembled bytecode looks like:

  6           8 LOAD_DEREF               0 (func_arg)
             10 CALL_FUNCTION            0
             12 RETURN_VALUE
"""
