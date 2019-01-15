import javascript

from DataFlow::ClassNode cls, string name
select cls.getAnInstanceMethod(name), cls.getName() + "." + name
