# Fake library functions that is missing on purpose to simulate complex code that our
# analysis is not able to handle.

def mylib_some_func(arg):
    pass

def mylib_call_indirectly(func, *arg, **kwargs):
    pass


# A basic case showing TAINTED_STRING gives taint

def basic():
    s = TAINTED_STRING
    ensure_tainted(s)


# In the following example, we need to teach taint tracking that the result of calling
# `mylib.some_func` with a tainted argument gives a tainted result

def additional_flow_step1():
    s = TAINTED_STRING
    x = mylib_some_func(s)
    ensure_tainted(x)


# In the following example, we need to teach taint tracking that `mylib.call_indirectly`
# makes taint flow from `arg[1:]` to the function in `arg[0]`

def my_vuln_func(arg):
    sink(arg)
    ensure_tainted(arg)

def my_vuln_func_kwarg(kwarg):
    sink(arg)
    ensure_tainted

class Foo(object):

    def vuln_func(self, arg):
        sink(arg)
        ensure_tainted(arg)


def additional_flow_step2():
    s = TAINTED_STRING
    mylib_call_indirectly(my_vuln_func, s)

    mylib_call_indirectly(func=my_vuln_func_kwarg, kwarg=s)

    f = Foo()
    mylib_call_indirectly(f.vuln_func, s)
