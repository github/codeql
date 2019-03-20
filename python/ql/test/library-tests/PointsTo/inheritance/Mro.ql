
import python

private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2

/** Make unknown type visible */
class UnknownType extends UnknownClassInternal {

    override string toString() { result = "*UNKNOWN TYPE" }

    override string getName() { result = "UNKNOWN" }

}

from ClassObjectInternal c
where not c.isBuiltin()
select c.toString(), Types::getMro(c)
