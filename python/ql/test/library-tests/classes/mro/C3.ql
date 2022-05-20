import python
import semmle.python.pointsto.MRO

from ClassValue cls
where not cls.isBuiltin()
select cls.toString(), Mro::newStyleMro(cls)
