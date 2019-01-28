
#This is prone to strange side effects and race conditions.
class MutatingDescriptor(object):

    def __init__(self, func):
        self.my_func = func

    def __get__(self, obj, obj_type):
        #Modified state is visible to all instances.
        self.my_obj = obj
        return self

    def __call__(self, *args):
        return self.my_func(self.my_obj, *args)

    #Not call from __get__, __set__ or __delete__
    def ok(self, func):
        self.my_func = func

    def __set__(self, obj, value):
        self.not_ok(value)

    def not_ok(self, value):
        #Modified state is visible to all instances.
        self.my_obj = value
