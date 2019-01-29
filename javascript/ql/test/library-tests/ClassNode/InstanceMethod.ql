import javascript

from DataFlow::ClassNode cls, string name
select cls.getInstanceMethod(name), cls.getName() + "." + name
