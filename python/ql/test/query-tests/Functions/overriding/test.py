

class Base(object):

    def meth1(self):
        pass

    def meth2(self, spam):
        pass

    def meth3(self):
        pass

    def foo(self):
        self.meth1()
        self.meth1(0)
        self.meth2()
        self.meth2(0)
        self.meth1(spam="eggs")
        self.meth2(spam="eggs")

class Derived(Base):

    def meth1(self, spam): # $Alert[py/inheritance/signature-mismatch] # Has 1 more arg, base called in Base.foo
        pass

    def meth2(self): # $Alert[py/inheritance/signature-mismatch] # Has 1 fewer arg, base called in Base.foo
        pass

    def meth3(self, eggs): # $Alert[py/inheritance/signature-mismatch] # Has 1 more arg. Method is not called.
        pass

    def bar(self):
        self.meth1() # Can only call Derived.meth1 so report as incorrect number of arguments
        self.meth1(0)
        self.meth2()
        self.meth2(0) # Can only call Derived.meth2 so report as incorrect number of arguments
        self.meth1(spam="eggs")
        self.meth2(spam="eggs")
        self.foo()

d = Derived()
d.meth1

class Abstract(object):

    def meth(self):
        raise NotImplementedError()


class Concrete(object):

    def meth(self, arg):
        pass


#Attempt to fool analysis
x = Abstract() if cond else Concrete()
x.meth("hi")


class BlameBase(object):

    def meth(self):
        pass

class Correct1(BlameBase):

    def meth(self, arg): # $Alert[py/inheritance/signature-mismatch] # Has 1 more arg. The incorrect-overridden-method query would alert for the base method in this case.
        pass

class Correct2(BlameBase):

    def meth(self, arg): # $Alert[py/inheritance/signature-mismatch] # Has 1 more arg
        pass

c = Correct2()
c.meth("hi")

class Base2:

    def meth1(self, x=1): pass

    def meth2(self, x=1): pass

    def meth3(self): pass

    def meth4(self, x=1): pass

    def meth5(self, x, y, z, w=1): pass

    def meth6(self, x, *ys): pass

    def meth7(self, *ys): pass

    def meth8(self, x, y): pass

    def meth9(self, x, y): pass

    def meth10(self, x, *, y=3): pass

    def meth11(self, x, y): pass

    def meth12(self, **kwargs): pass

    def meth13(self, /, x): pass

    def call_some(self):
        self.meth1()
        self.meth1(x=2)
        self.meth3()
        self.meth3(x=2)
        self.meth6(2, 3, 4)
        self.meth7()
        self.meth8(1,y=3)
        self.meth9(1,2)
        self.meth10(1,y=3)
        self.meth11(1,y=3)
        self.meth12(x=2)
        self.meth13(x=2)


class Derrived2(Base2):

    def meth1(self): pass # $Alert[py/inheritance/signature-mismatch] # Weak mismatch (base may be called with 2 args. only alert if mismatching call exists)

    def meth2(self): pass # No alert (weak mismatch, but not called)

    def meth3(self, x=1): pass # No alert (no mismatch - all base calls are valid for sub)

    def meth4(self, x, y, z=1): pass # $Alert[py/inheritance/signature-mismatch] # sub min > base max (strong mismatch)

    def meth5(self, x, y=1): pass # $Alert[py/inheritance/signature-mismatch]

    def meth6(self, x): pass # $Alert[py/inheritance/signature-mismatch] # weak mismatch (base may be called with 3+ args)

    def meth7(self, x, *ys): pass # $Alert[py/inheritance/signature-mismatch] # weak mismatch (base may be called with 1 arg only)

    def meth8(self, x, z): pass # $Alert[py/inheritance/signature-mismatch] # weak mismatch (base may be called with arg named y)

    def meth9(self, x, z): pass # No alert (never called with wrong keyword arg)

    def meth10(self, x, **kwargs): pass # No alert (y is kw-only arg in base, calls that use it are valid for sub)

    def meth11(self, x, z, **kwargs): pass # $MISSING:Alert[py/inheritance/signature-mismatch] # call using y kw-arg is invalid due to not specifying z, but this is not detected. Likely a fairly niche situation.

    def meth12(self): pass # $Alert[py/inheritance/signature-mismatch] # call including extra kwarg invalid

    def meth13(self, /, y): pass # $Alert[py/inheritance/signature-mismatch] # weak mismatch (base may be called with arg named x), however meth13 is incorrectly detected as having 2 minimum positional arguments, whereas x is kw-only; resulting in the witness call not being detected as a valid call to Base2.meth13. 
