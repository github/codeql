import javascript

from DataFlow::ClassNode cls, DataFlow::ClassNode sup
where sup = cls.getADirectSuperClass()
select cls, cls.getName(), sup, sup.getName()
