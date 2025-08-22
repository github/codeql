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
        # On the next line, we wish to express that it is not possible for `Bar` to be a subclass of `A`.
        # However, we have no "true negative" annotation, so we use the MISSING annotation instead.
        # (Normally, "true negative" is not needed as all applicable annotations must be present,
        # but these API graph tests work differently, since having all results recorded in annotations 
        # would be excessive)
        print(Bar)  #$ use=moduleImport("foo").getMember("B").getASubclass() MISSING: use=moduleImport("foo").getMember("A").getASubclass()
        print(Baz)  #$ use=moduleImport("foo").getMember("B").getASubclass() SPURIOUS: use=moduleImport("foo").getMember("A").getASubclass()

    class Baz(B): pass

    other_func()