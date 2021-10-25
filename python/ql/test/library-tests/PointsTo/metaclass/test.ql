import python
private import semmle.python.objects.ObjectInternal

/** Make unknown type visible */
class UnknownType extends UnknownClassInternal {
  override string toString() { result = "*UNKNOWN TYPE" }
}

from ClassObject cls
where cls.getPyClass().getEnclosingModule().getName() = "test"
select cls.toString(), cls.getMetaClass().toString()
