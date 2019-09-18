import types

#Immutable version, which is safe to share.
class NonMutatingDescriptor(object):
    
    def __init__(self, func):
        self.my_func = func
        
    def __get__(self, obj, obj_type):
        #Return a new object to each access.
        return types.MethodType(self.my_func, obj)
    
def show(obj):
    print (obj)
    
class C(object):
    
    def __init__(self, value):
        self.value = value
        
    def __str__(self):
        return ("C: " + str(self.value))
    
    show = NonMutatingDescriptor(show)
    
c1 = C(1)
c1.show()
c2 = C(2)
c2.show()
c1_show = c1.show
c2.show
c1_show()

#Outputs:
#C: 1
#C: 2
#C: 1