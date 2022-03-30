import python
import semmle.python.pointsto.MRO
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

ClassList mro(ClassObjectInternal cls) {
  if Types::isNewStyle(cls) then result = Mro::newStyleMro(cls) else result = Mro::oldStyleMro(cls)
}

from ClassObjectInternal cls
where not cls.isBuiltin()
select cls.toString(), mro(cls)
