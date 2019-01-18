import javascript

from DataFlow::ClassNode cls, string name, string kind
select cls.getInstanceMember(name, kind), cls.getName() + "." + name, kind
