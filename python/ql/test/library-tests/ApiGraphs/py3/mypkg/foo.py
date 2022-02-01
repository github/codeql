value = 3 #$ def=moduleImport("mypkg").getMember("foo").getMember("value")

class MyClass: #$ def=moduleImport("mypkg").getMember("foo").getMember("MyClass")
    def myFunc(self, x): #$ def=moduleImport("mypkg").getMember("foo").getMember("MyClass").getMember("myFunc") use=moduleImport("mypkg").getMember("foo").getMember("MyClass").getMember("myFunc").getParameter(1)
        self.selfThing() #$ use=moduleImport("mypkg").getMember("foo").getMember("MyClass").getMember("myFunc").getParameter(0).getMember("selfThing").getReturn()
        x.xThing() #$ use=moduleImport("mypkg").getMember("foo").getMember("MyClass").getMember("myFunc").getParameter(1).getMember("xThing").getReturn()

value2 = 3 #$ def=moduleImport("mypkg").getMember("foo").getMember("value2")

# this entire file is imported from bar.py

value3 = 3 #$ def=moduleImport("mypkg").getMember("bar").getMember("value3")
