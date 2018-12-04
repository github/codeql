

import python

private import semmle.python.types.Extensions


class CfgExtension  extends CustomPointsToOriginFact {

    CfgExtension() {
        this.(NameNode).getId() = "one"
        or
        this.(NameNode).getId() = "two"
    }

    override predicate pointsTo(Object value, ClassObject cls) {
        cls = theIntType() and
        (
            this.(NameNode).getId() = "one" and value.(NumericObject).intValue() = 1
            or
            this.(NameNode).getId() = "two" and value.(NumericObject).intValue() = 2
        )
    }
}

from ControlFlowNode f, Object o
where f.getLocation().getFile().getBaseName() = "test.py" and f.refersTo(o)
select f, o.toString()


