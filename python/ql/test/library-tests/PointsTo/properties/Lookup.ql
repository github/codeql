import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

from ClassObjectInternal cls, string name, ObjectInternal f
where cls.lookup(name, f, _) and exists(f.getOrigin())
select cls.toString(), name, f.toString()
