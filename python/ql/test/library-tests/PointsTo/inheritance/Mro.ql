import python
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo

/** An unknown type. Not usually visible. */
class UnknownType extends UnknownClassInternal {
  override string toString() { result = "*UNKNOWN TYPE" }
}

from ClassObjectInternal c
where not c.isBuiltin()
select c.toString(), Types::getMro(c)
