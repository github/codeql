

import python

private import semmle.python.types.Extensions


class CfgExtension extends CustomPointsToOriginFact {

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

class AttributeExtension  extends CustomPointsToAttribute {

    AttributeExtension() { this = this }

    override predicate attributePointsTo(string name, Object value, ClassObject cls, ControlFlowNode origin) {
        cls = theIntType() and origin = any(Module m).getEntryNode() and
        (
            name = "three" and value.(NumericObject).intValue() = 3
            or
            name = "four" and value.(NumericObject).intValue() = 4
        )
    }

}

class NoClassExtension extends CustomPointsToObjectFact {

    NoClassExtension() { this = this }

    override predicate pointsTo(Object value) {
        this.(NameNode).getId() = "five" and value.(NumericObject).intValue() = 5
        or
        this.(NameNode).getId() = "six" and value.(NumericObject).intValue() = 6
    }

}


from ControlFlowNode f, Object o
where f.getLocation().getFile().getBaseName() = "test.py" and f.refersTo(o)
select f, o.toString()


