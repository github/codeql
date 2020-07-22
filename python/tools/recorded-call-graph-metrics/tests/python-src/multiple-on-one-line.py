def one(*args, **kwargs):
    print("one")
    return 1

def two(*args, **kwargs):
    print("two")
    return 2

def three(*args, **kwargs):
    print("three")
    return 3

one(); two()
print("---")

one(); one()
print("---")

alias_one = one
alias_one(); two()
print("---")

three(one(), two())
print("---")

three(one(), two=two())
print("---")

def f():
    print("f")

    def g():
        print("g")

    return g

f()()
