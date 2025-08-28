class A:
    def __eq__(self, other):
        return True 
    
    def __hash__(self):
        return 7 
    
# B is automatically non-hashable - so eq without hash never needs to alert
class B:
    def __eq__(self, other):
        return True 
    
class C: # $ Alert
    def __hash__(self):
        return 5
    
class D(A): # $ Alert 
    def __hash__(self):
        return 4