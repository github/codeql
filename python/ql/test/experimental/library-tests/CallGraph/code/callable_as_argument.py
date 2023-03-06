# ==============================================================================
# function
# ==============================================================================

def call_func(f):
    f() # $ pt,tt=my_func pt,tt=test_func.inside_test_func


def my_func():
    print("my_func")

call_func(my_func) # $ pt,tt=call_func


def test_func():
    def inside_test_func():
        print("inside_test_func")

    call_func(inside_test_func) # $ pt,tt=call_func

test_func() # $ pt,tt=test_func


# ==============================================================================
# class
# ==============================================================================

def class_func(cls):
    cls.sm() # $ pt,tt=MyClass.sm tt=test_class.InsideTestFunc.sm
    cls(42) # $ tt=MyClass.__init__ tt=test_class.InsideTestFunc.__init__


class MyClass(object):
    def __init__(self, arg):
        print(self, arg)

    @staticmethod
    def sm():
        print("MyClass.staticmethod")

class_func(MyClass) # $ pt,tt=class_func


def test_class():
    class InsideTestFunc(object):
        def __init__(self, arg):
            print(self, arg)

        @staticmethod
        def sm():
            print("InsideTestFunc.staticmethod")

    class_func(InsideTestFunc) # $ pt,tt=class_func

test_class() # $ pt,tt=test_class
