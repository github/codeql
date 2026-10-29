#Non existent class attribute

class Attributes(object):

    exists1 = 1

    def __init__(self):
        self.exists2 = 2

    def method(self):
        self.may_exist = 3

    def ok1(self):
        print (self.exists1)

    def ok2(self):
        print (self.exists2)

    def ok3(self):
        self.local_exists = 4
        print (self.local_exists)

    def neca1(self):
        print (self.not_exists)

    def neca2(self):
        print (self.may_exist)

#This is OK
class SetViaDict(object):

    def __init__(self, x):
        self.__dict__['x'] = x

    def use_x(self):
        return self.x


#This is also OK
class SetLocally(object):

    def use_x(self):
        self.x = 1
        return self.x


class UsesSetattr(object):

    def __init__(self, vals):
        for k, v in vals.items():
            setattr(self, k, v)

    def use_values(self):
        return self.x, self.y, self.z

#OK
class GuardedByHasAttr(object):

    def ok4(self):
        if hasattr(self, "x"):
            return self.x
        else:
            return None

class HasGetAttr(object):

    def __getattr__(self, name):
        return name

    def use_values(self):
       return self.x, self.y, self.z

class HasGetAttribute(object):

    def __getattribute__(self, name):
        return name

    def use_values(self):
       return self.x, self.y, self.z
















class DecoratedInit(object):
    
    @decorator
    def __init__(self):
        self.x = x
        
    def use(self):
        return self.x

#This is not OK
class NoInit(object):

    def use_y(self):
        return self.y

#This is also OK
class SetLocally2(object):
    
    def __init__(self):
        pass

    def use_y(self):
        self.x = 0
        self.y = 1
        if cond:
            print(self.y)
        else:
            return False
        return self.y
    
#Guarded
class Guarded(object):
    
    def __init__(self):
        self.guard = False
        
    def set_x(self):
        self.guard = True
        self.x = 1
        
    def use_x(self):
        if self.guard:
            return self.x
        else:
            return 0

#ODASA-2034
class ODASA2034A(object):

    def __init__(self, data):
        d = self.__dict__
        d['data'] = data

    def use_data(self):
        return self.data

class ODASA2034B(object):

    def __init__(self, key, value):
        d = self.__dict__
        d[key] = value

    def use_data(self):
        return self.data


class Test5(object):

    def readFromStream(stream):
        word = stream.read(4)
        if word == "true":
            return BooleanObject(True)
        elif word == "fals":
            stream.read(1)
            return BooleanObject(False)
        assert False
    readFromStream = staticmethod(readFromStream)


class Test1(object):

    def __init__(self, application):
        self.rabbitmq_channel = None

        def queue_declared(frame): # called in callback
            self.return_queue = frame.method.queue

    def use_it(self):
        return self.return_queue


#Check for FPs when overriding builtin methods

class PrintingDict(dict):

    def pop(self):
        print ("pop")
        return dict.pop(self)

    def __setitem__(self, key, value):
        print("__setitem__")
        return dict.__setitem__(self, key, value)

#Locally set by Call
#ODASA-4612
class WSGIContext(object):

    def _app_call(self, env):
        self._response_headers = None


class Odasa4612(WSGIContext):

    def meth1(self, arg):
        val = self._app_call(arg)
        if self._response_headers is None:
            self._response_headers = []



class OK9(object):
    cls_attr = 0
    def __init__(self):
        self.attr = self.cls_attr



class Foo1(object):
  pass

foo = Foo1()
setattr(foo, 'a', 1)
assert foo.a == 1

class Foo2(object):
  pass

setattr(Foo2, 'a', 1)
assert Foo2.a == 1

# False positive observed at customer

class Customer1(object):

    def x(self):
        if not hasattr(self, "attr"):
            return None
        else:
            return self.attr

#ODASA-4619
class Odasa4619a(object):

    def call(self):
        host = self.glance_host
        port = self.glance_port


class Odasa4619b(object):

    def call(self):
        host = self.glance_host
        port = self.glance_port

    @decorator
    def foo(self):
        (x, self.glance_host,
         self.glance_port, y) = bar()
