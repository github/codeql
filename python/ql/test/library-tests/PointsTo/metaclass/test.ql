import python
private import semmle.python.objects.ObjectInternal

/** An unknown type. Not usually visible. */
class UnknownType extends UnknownClassInternal {
  override string toString() { result = "*UNKNOWN TYPE" }
}

from ClassObject cls
where cls.getPyClass().getEnclosingModule().getName() = "test"
select cls.toString(), cls.getMetaClass().toString()
