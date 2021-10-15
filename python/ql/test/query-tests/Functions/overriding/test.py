

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

    def meth1(self, spam):
        pass

    def meth2(self):
        pass

    def meth3(self, eggs): #Incorrectly overridden and not called. 
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

    def meth(self, arg):
        pass

class Correct2(BlameBase):

    def meth(self, arg):
        pass

c = Correct2()
c.meth("hi")
