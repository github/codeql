
import python

/** Make unknown type visible */
class UnknownType extends ClassObject {

    UnknownType() { this = theUnknownType() }

    override string toString() { result = "*UNKNOWN TYPE" }

    override string getName() { result = "UNKNOWN" }

}

from ClassObject c
where not c.isBuiltin()
select c.toString(), c.getMro()
