#Superclass __init__ calls subclass method

def bad1():
    class Super:

        def __init__(self, arg):
            self._state = "Not OK"
            self.set_up(arg) # BAD: set_up is overriden.
            self._state = "OK"

        def set_up(self, arg):
            "Do some set up"

    class Sub(Super):

        def __init__(self, arg):
            super().__init__(arg)
            self.important_state = "OK"

        def set_up(self, arg):
            super().set_up(arg)
            "Do some more set up" # `self` is partially initialized
            if self.important_state == "OK":
                pass

def bad2():
    class Super:
        def __init__(self, arg):
            self.a = arg 
            # BAD: postproc is called after initialization. This is still an issue 
            #      since it may still occur before all initialization on a subclass is complete.
            self.postproc() 

        def postproc(self):
            if self.a == 1:
                pass

    class Sub(Super):
        def __init__(self, arg):
            super().__init__(arg)
            self.b = 3

        def postproc(self):
            if self.a == 2 and self.b == 3:
                pass

def good3():
    class Super:
        def __init__(self, arg):
            self.a = arg 
            self.set_b() # OK: Here `set_b` is used for initialisation, but does not read the partialy initialized state of `self`. 
            self.c = 1

        def set_b(self):
            self.b = 3

    class Sub(Super):
        def set_b(self):
            self.b = 4

def good4():
    class Super:
        def __init__(self, arg):
            self.a = arg 
            # OK: Here `_set_b` is likely an internal method (as indicated by the _ prefix). 
            # We assume thus that regular consumers of the library will not override it, and classes that do are internal and account for `self`'s partially initialised state.
            self._set_b() 
            self.c = 1 

        def _set_b(self):
            self.b = 3

    class Sub(Super):
        def _set_b(self): 
            self.b = self.a+1