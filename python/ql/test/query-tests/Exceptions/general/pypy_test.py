
def test():
    class A(BaseException):
        class __metaclass__(type):
            def __getattribute__(self, name):
                if flag and name == '__bases__':
                    fail("someone read bases attr")
                else:
                    return type.__getattribute__(self, name)
    
    try:
        a = A()
        raise a
    except 42:
        #Some comment
        pass
    except A:
        #Another comment
        pass

