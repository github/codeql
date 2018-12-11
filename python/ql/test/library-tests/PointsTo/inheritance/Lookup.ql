
import python
import semmle.python.pointsto.PointsTo

from ClassObject cls, string name, PyFunctionObject f
where PointsTo::Types::class_attribute_lookup(cls, name, f, _, _)
select cls.toString(), name, f.toString(), f.getFunction().getLocation().getStartLine()
