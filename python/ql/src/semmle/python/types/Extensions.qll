/** This library allows custom extensions to the points-to analysis to incorporate
 * custom domain knowledge into the points-to analysis.
 * 
 * This should be considered an advance feature. Modifying the points-to analysis
 * can cause queries to give strange and misleading results, if not done with care.
 *
 * WARNING:
 *     This module interacts with the internals of points-to analysis and
 *     the classes here are more likely to change than the rest of the library.
 */

import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.objects.TObject
private import semmle.python.web.HttpConstants

/* Make ObjectInternal visible to save extra imports in user code */
import semmle.python.objects.ObjectInternal

abstract class PointsToExtension extends @py_flow_node {

    string toString() { none() }

    abstract predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin);

}


/* Legacy API */

/* Custom Facts. This extension mechanism allows you to add custom
 * sources of data to the points-to analysis.
 */

/** DEPRECATED -- Use PointsToExtension instead */
deprecated abstract class CustomPointsToFact extends @py_flow_node {

    string toString() { none() }

    abstract predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin);

}

/* For backwards compatibility */
class FinalCustomPointsToFact = CustomPointsToFact;

deprecated abstract class CustomPointsToOriginFact extends CustomPointsToFact {

    abstract predicate pointsTo(Object value, ClassObject cls);

    override predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin) {
        this.pointsTo(value, cls) and origin = this and context.appliesTo(this)
    }

}

/* Custom points-to fact with inferred class */
deprecated abstract class CustomPointsToObjectFact extends CustomPointsToFact {

    abstract predicate pointsTo(Object value);

    override predicate pointsTo(Context context, Object value, ClassObject cls, ControlFlowNode origin) {
        this.pointsTo(value) and cls = simple_types(value) and origin = this and context.appliesTo(this)
    }

}


/** DEPRECATED -- Unsupported; do not use */
deprecated abstract class CustomPointsToAttribute extends Object {

    abstract predicate attributePointsTo(string name, Object value, ClassObject cls, ControlFlowNode origin);

}

/* An example */

/** Any variable iterating over range or xrange must be an integer */
class RangeIterationVariableFact extends PointsToExtension {

    RangeIterationVariableFact() {
        exists(For f, ControlFlowNode iterable |
            iterable.getBasicBlock().dominates(this.(ControlFlowNode).getBasicBlock()) and
            f.getIter().getAFlowNode() = iterable and
            f.getTarget().getAFlowNode() = this and
            exists(ObjectInternal range |
                PointsTo::pointsTo(iterable, _, range, _) and
                range.getClass() = ObjectInternal::builtin("range")
            )
        )
    }

    override predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin) {
        value = TUnknownInstance(ObjectInternal::builtin("int")) and
        origin = this and
        context.appliesTo(this)
    }

}

/* bottle module route constants */

class BottleRoutePointToExtension extends PointsToExtension {

    string name;

    BottleRoutePointToExtension() {
        exists(DefinitionNode defn |
            defn.getScope().(Module).getName() = "bottle" and
            this = defn.getValue() and
            name = defn.(NameNode).getId()
            |
            name = "route" or
            name = httpVerbLower()
        )
    }

    override predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin) {
        context.isImport() and
        exists(CfgOrigin orig |
            Module::named("bottle").attr("Bottle").(ClassObjectInternal).attribute(name, value, orig) and
            origin = orig.asCfgNodeOrHere(this)
        )
    }

}

/* Python 3.6+ regex module constants */

class ReModulePointToExtension extends PointsToExtension {

    string name;

    ReModulePointToExtension() {
        exists(ModuleObjectInternal re | re.getName() = "re" and
            PointsTo::pointsTo(this.(AttrNode).getObject(name), _, re, _)
        )
    }

    override predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin) {
        exists(ModuleObjectInternal sre_constants, CfgOrigin orig |
            sre_constants.getName() = "sre_constants" and
            sre_constants.attribute("SRE_FLAG_" + name, value, orig) and
            origin = orig.asCfgNodeOrHere(this)
        )
        and pointsTo_helper(context)
    }

    pragma [noinline]
    private predicate pointsTo_helper(Context context) {
        context.appliesTo(this)
    }

}

private class BackwardCompatiblePointToExtension extends PointsToExtension {

    BackwardCompatiblePointToExtension() {
        this instanceof CustomPointsToFact
    }

    override predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin) {
        exists(Object obj, ClassObject cls |
            this.(CustomPointsToFact).pointsTo(context, obj, cls, origin)
            |
            value.getBuiltin() = obj
            or
            obj instanceof ControlFlowNode and
            exists(ClassObjectInternal c |
                c.getSource() = cls and
                value = TUnknownInstance(c)
            )
        )
        or
        exists(ObjectInternal owner, string name |
            PointsTo::pointsTo(this.(AttrNode).getObject(name), context, owner, _) and
            additionalAttribute(owner, name, value, origin)
        )
    }

}

private predicate additionalAttribute(ObjectInternal owner, string name, ObjectInternal value, ControlFlowNode origin) {
    exists(Object obj, ClassObject cls |
        owner.getSource().(CustomPointsToAttribute).attributePointsTo(name, obj, cls, origin)
        |
        value.getBuiltin() = obj
        or
        obj instanceof ControlFlowNode and
        exists(ClassObjectInternal c |
            c.getSource() = cls and
            value = TUnknownInstance(c)
        )
    )
}

