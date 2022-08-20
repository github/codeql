def func():
    print("func")

func() # $ resolved=func


class MyBase:
    def base_method(self):
        print("base_method", self)


class MyClass(MyBase):
    def method1(self):
        print("method1", self)

    @classmethod
    def cls_method(cls):
        print("cls_method", cls)

    @staticmethod
    def static():
        print("static")

    def method2(self):
        print("method2", self)
        self.method1() # $ resolved=method1
        self.base_method()
        self.cls_method() # $ resolved=cls_method
        self.static() # $ resolved=static




MyClass.cls_method() # $ resolved=cls_method
MyClass.static() # $ resolved=static

x = MyClass()
x.base_method()
x.method1()
x.cls_method()
x.static()
x.method2()
