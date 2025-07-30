class A:
    def __init__(self, default_func=None):
        if default_func is not None:
            self.default = default_func 

    # GOOD: The shadowing behavior is explicitly intended in the superclass.
    def default(self):
        return []
    
class B(A):
    
    # Subclasses may override the method `default`, which will still be shadowed by the attribute `default` if it is set.
    # As this is part of the expected behavior of the superclass, this is fine. 
    def default(self):
        return {}