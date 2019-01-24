/** This library allows custom extensions to the points-to analysis to incorporate
 * custom domain knowledge into the points-to analysis.
 * 
 * This should be considered an advance feature. Modifying the points-to analysis
 * can cause queries to give strange and misleading results, if not done with care.
 */

import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext

/* Custom Facts. This extension mechanism allows you to add custom
 * sources of data to the points-to analysis.
 */

abstract class CustomPointsToFact extends @py_flow_node {

    string toString() { none() }

    abstract predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin);

}

/* For backwards compatibility */
class FinalCustomPointsToFact = CustomPointsToFact;

abstract class CustomPointsToOriginFact extends CustomPointsToFact {

    abstract predicate pointsTo(Object value, ClassObject cls);

    override predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin) {
        this.pointsTo(value, cls) and origin = this and context.appliesTo(this)
    }

}

/** INTERNAL -- Do not use */
abstract class CustomPointsToAttribute extends Object {

    abstract predicate attributePointsTo(string name, Object value, ClassObject cls, ControlFlowNode origin);

}

/* An example */

/** Any variable iterating over range or xrange must be an integer */
class RangeIterationVariableFact extends CustomPointsToFact {

    RangeIterationVariableFact() {
        exists(For f, ControlFlowNode iterable |
            iterable.getBasicBlock().dominates(this.(ControlFlowNode).getBasicBlock()) and
            f.getIter().getAFlowNode() = iterable and
            f.getTarget().getAFlowNode() = this and
            PointsTo::points_to(iterable, _, theRangeType(), _, _)
        )
    }

    override predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin) {
        value = this and 
        origin = this and
        cls = theIntType() and
        context.appliesTo(this)
    }
}

/* Python 3.6+ regex module constants */

class ReModulePointToExtension extends CustomPointsToAttribute {

    ReModulePointToExtension() {
        this.(ModuleObject).getName() = "re"
    }

    override predicate attributePointsTo(string name, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(ModuleObject sre_constants |
            sre_constants.getName() = "sre_constants" and
            sre_constants.attributeRefersTo("SRE_FLAG_" + name, value, cls, origin)
        )
    }
}



