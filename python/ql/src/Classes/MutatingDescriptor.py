
#This is prone to strange side effects and race conditions.
class MutatingDescriptor(object):
    
    def __init__(self, func):
        self.my_func = func
        
    def __get__(self, obj, obj_type):
        #Modified state is visible to all instances of C that might call "show".
        self.my_obj = obj
        return self
        
    def __call__(self, *args):
        return self.my_func(self.my_obj, *args)
    
def show(obj):
    print (obj)
    
class C(object):
    
    def __init__(self, value):
        self.value = value
        
    def __str__(self):
        return ("C: " + str(self.value))
    
    show = MutatingDescriptor(show)
    
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
#C: 2