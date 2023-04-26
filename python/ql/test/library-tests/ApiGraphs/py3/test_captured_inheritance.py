from foo import A, B

def func():
    if cond():
        class Foo(A): pass
    else:
        class Foo(B): pass

    class Bar(A): pass
    class Bar(B): pass

    class Baz(A): pass
    
    def other_func():
        print(Foo)  #$ use=moduleImport("foo").getMember("A").getASubclass() use=moduleImport("foo").getMember("B").getASubclass()
        print(Bar)  #$ use=moduleImport("foo").getMember("B").getASubclass() MISSING: use=moduleImport("foo").getMember("A").getASubclass()  The MISSING here is documenting correct behaviour
        print(Baz)  #$ use=moduleImport("foo").getMember("B").getASubclass() SPURIOUS: use=moduleImport("foo").getMember("A").getASubclass()

    class Baz(B): pass

    other_func()