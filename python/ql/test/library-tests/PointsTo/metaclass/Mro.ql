import python
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo

/** An unknown type. Not usually visible. */
class UnknownType extends UnknownClassInternal {
  override string toString() { result = "*UNKNOWN TYPE" }
}

from PythonClassObjectInternal cls
where cls.getScope().getEnclosingModule().getName() = "test" and not Types::failedInference(cls, _)
select cls.toString(), Types::getMro(cls)
