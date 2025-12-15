/**
 * DEPRECATED: Using the methods in this module may lead to a degradation of performance. Use at
 * your own peril.
 *
 * This module contains legacy points-to predicates and methods for various classes in the
 * points-to analysis.
 *
 * Existing code that depends on, say, points-to predicates on `ControlFlowNode` should be modified
 * to use `ControlFlowNodeWithPointsTo` instead. In particular, if inside a method call chain such
 * as
 *
 * `someCallNode.getFunction().pointsTo(...)`
 *
 *  an explicit cast should be added as follows
 *
 * `someCallNode.getFunction().(ControlFlowNodeWithPointsTo).pointsTo(...)`
 *
 * Similarly, if a bound variable has type `ControlFlowNode`, and a points-to method is called on
 * it, the type should be changed to `ControlFlowNodeWithPointsTo`.
 */

private import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.objects.Modules

/**
 * An extension of `ControlFlowNode` that provides points-to predicates.
 */
class ControlFlowNodeWithPointsTo extends ControlFlowNode {
  /** Gets the value that this ControlFlowNode points-to. */
  predicate pointsTo(Value value) { this.pointsTo(_, value, _) }

  /** Gets the value that this ControlFlowNode points-to. */
  Value pointsTo() { this.pointsTo(_, result, _) }

  /** Gets a value that this ControlFlowNode may points-to. */
  Value inferredValue() { this.pointsTo(_, result, _) }

  /** Gets the value and origin that this ControlFlowNode points-to. */
  predicate pointsTo(Value value, ControlFlowNode origin) { this.pointsTo(_, value, origin) }

  /** Gets the value and origin that this ControlFlowNode points-to, given the context. */
  predicate pointsTo(Context context, Value value, ControlFlowNode origin) {
    PointsTo::pointsTo(this, context, value, origin)
  }

  /**
   * Gets what this flow node might "refer-to". Performs a combination of localized (intra-procedural) points-to
   * analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   * precise, but may not provide information for a significant number of flow-nodes.
   * If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ClassObject cls, ControlFlowNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /** Gets what this expression might "refer-to" in the given `context`. */
  pragma[nomagic]
  predicate refersTo(Context context, Object obj, ClassObject cls, ControlFlowNode origin) {
    not obj = unknownValue() and
    not cls = theUnknownType() and
    PointsTo::points_to(this, context, obj, cls, origin)
  }

  /**
   * Whether this flow node might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)` this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ControlFlowNode origin) {
    not obj = unknownValue() and
    PointsTo::points_to(this, _, obj, _, origin)
  }

  /** Equivalent to `this.refersTo(value, _)` */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /**
   * Check whether this control-flow node has complete points-to information.
   * This would mean that the analysis managed to infer an over approximation
   * of possible values at runtime.
   */
  predicate hasCompletePointsToSet() {
    // If the tracking failed, then `this` will be its own "origin". In that
    // case, we want to exclude nodes for which there is also a different
    // origin, as that would indicate that some paths failed and some did not.
    this.refersTo(_, _, this) and
    not exists(ControlFlowNode other | other != this and this.refersTo(_, _, other))
    or
    // If `this` is a use of a variable, then we must have complete points-to
    // for that variable.
    exists(SsaVariable v | v.getAUse() = this | varHasCompletePointsToSet(v))
  }
}

/**
 * Check whether a SSA variable has complete points-to information.
 * This would mean that the analysis managed to infer an overapproximation
 * of possible values at runtime.
 */
private predicate varHasCompletePointsToSet(SsaVariable var) {
  // Global variables may be modified non-locally or concurrently.
  not var.getVariable() instanceof GlobalVariable and
  (
    // If we have complete points-to information on the definition of
    // this variable, then the variable has complete information.
    var.getDefinition()
        .(DefinitionNode)
        .getValue()
        .(ControlFlowNodeWithPointsTo)
        .hasCompletePointsToSet()
    or
    // If this variable is a phi output, then we have complete
    // points-to information about it if all phi inputs had complete
    // information.
    forex(SsaVariable phiInput | phiInput = var.getAPhiInput() |
      varHasCompletePointsToSet(phiInput)
    )
  )
}

/**
 * An extension of `Expr` that provides points-to predicates.
 */
class ExprWithPointsTo extends Expr {
  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to". Performs a combination of localized (intra-procedural) points-to
   *  analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   *  precise, but may not provide information for a significant number of flow-nodes.
   *  If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   * NOTE: For complex dataflow, involving multiple stages of points-to analysis, it may be more precise to use
   * `ControlFlowNode.refersTo(...)` instead.
   */
  predicate refersTo(Object obj, ClassObject cls, AstNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to" in the given `context`.
   */
  predicate refersTo(Context context, Object obj, ClassObject cls, AstNode origin) {
    this.getAFlowNode()
        .(ControlFlowNodeWithPointsTo)
        .refersTo(context, obj, cls, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Holds if this expression might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)`, this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, AstNode origin) {
    this.getAFlowNode().(ControlFlowNodeWithPointsTo).refersTo(obj, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Equivalent to `this.refersTo(value, _)`
   */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`
   * in the given `context`.
   */
  predicate pointsTo(Context context, Value value, AstNode origin) {
    this.getAFlowNode()
        .(ControlFlowNodeWithPointsTo)
        .pointsTo(context, value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`.
   */
  predicate pointsTo(Value value, AstNode origin) {
    this.getAFlowNode().(ControlFlowNodeWithPointsTo).pointsTo(value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value`.
   */
  predicate pointsTo(Value value) { this.pointsTo(value, _) }

  /** Gets a value that this expression might "point-to". */
  Value pointsTo() { this.pointsTo(result) }

  override string getAQlClass() { none() }
}

/**
 * An extension of `Module` that provides points-to related methods.
 */
class ModuleWithPointsTo extends Module {
  /** Gets a name exported by this module, that is the names that will be added to a namespace by 'from this-module import *' */
  string getAnExport() {
    py_exports(this, result)
    or
    exists(ModuleObjectInternal mod | mod.getSource() = this.getEntryNode() |
      mod.(ModuleValue).exports(result)
    )
  }

  override string getAQlClass() { none() }
}
