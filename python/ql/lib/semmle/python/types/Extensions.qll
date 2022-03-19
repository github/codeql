/**
 * This library allows custom extensions to the points-to analysis to incorporate
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
  string toString() { result = "PointsToExtension with missing toString" }

  abstract predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin);
}

/* Legacy API */
/*
 * Custom Facts. This extension mechanism allows you to add custom
 * sources of data to the points-to analysis.
 */

/* An example */
/** An extension representing the fact that a variable iterating over range or xrange must be an integer */
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
deprecated class BottleRoutePointToExtension extends PointsToExtension {
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
string short_flag(string flag) {
  flag in ["ASCII", "IGNORECASE", "LOCALE", "UNICODE", "MULTILINE", "TEMPLATE"] and
  result = flag.prefix(1)
  or
  flag = "DOTALL" and result = "S"
  or
  flag = "VERBOSE" and result = "X"
}

class ReModulePointToExtension extends PointsToExtension {
  string name;

  ReModulePointToExtension() {
    exists(ModuleObjectInternal re |
      re.getName() = "re" and
      PointsTo::pointsTo(this.(AttrNode).getObject(name), _, re, _)
    )
  }

  override predicate pointsTo(Context context, ObjectInternal value, ControlFlowNode origin) {
    exists(ModuleObjectInternal sre_constants, CfgOrigin orig, string flag |
      (name = flag or name = short_flag(flag)) and
      sre_constants.getName() = "sre_constants" and
      sre_constants.attribute("SRE_FLAG_" + flag, value, orig) and
      origin = orig.asCfgNodeOrHere(this)
    ) and
    this.pointsTo_helper(context)
  }

  pragma[noinline]
  private predicate pointsTo_helper(Context context) { context.appliesTo(this) }
}
