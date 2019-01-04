
import python
import semmle.python.pointsto.MRO

from ClassObject cls
where not cls.isBuiltin()

select cls.toString(), new_style_mro(cls)

