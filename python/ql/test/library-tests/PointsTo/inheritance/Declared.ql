import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

from ClassObjectInternal cls, string name, PythonFunctionObjectInternal f
where Types::declaredAttribute(cls, name, f, _)
select cls.toString(), name, f.toString(), f.getScope().getLocation().getStartLine()
