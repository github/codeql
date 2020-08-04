/**
 * Provides Python-specific definitions for use in the data flow library.
 */

import python
private import DataFlowPrivate

/**
 * IPA type for data flow nodes.
 *
 * Flow between SSA variables are computed in `Essa.qll`
 *
 * Flow from SSA variables to control flow nodes are generally via uses.
 *
 * Flow from control flow nodes to SSA variables are generally via assignments.
 *
 * The current implementation of these cross flows can be seen in `EssaTaintTracking`.
 */
newtype TNode =
  /** A node corresponding to an SSA variable. */
  TEssaNode(EssaVariable var) or
  /** A node corresponding to a control flow node. */
  TCfgNode(ControlFlowNode node)

/**
 * An element, viewed as a node in a data flow graph. Either an SSA variable
 * (`EssaNode`) or a control flow node (`CfgNode`).
 */
class Node extends TNode {
  /** Gets a textual representation of this element. */
  string toString() { result = "Data flow node" }

  /** Gets the scope of this node. */
  Scope getScope() { none() }

  private DataFlowCallable getCallableScope(Scope s) {
    result.getScope() = s
    or
    not exists(DataFlowCallable c | c.getScope() = s) and
    result = getCallableScope(s.getEnclosingScope())
  }

  /** Gets the enclosing callable of this node. */
  DataFlowCallable getEnclosingCallable() { result = getCallableScope(this.getScope()) }

  /** Gets the location of this node */
  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class EssaNode extends Node, TEssaNode {
  EssaVariable var;

  EssaNode() { this = TEssaNode(var) }

  EssaVariable getVar() { result = var }

  /** Gets a textual representation of this element. */
  override string toString() { result = var.toString() }

  override Scope getScope() { result = var.getScope() }

  override Location getLocation() { result = var.getDefinition().getLocation() }
}

class CfgNode extends Node, TCfgNode {
  ControlFlowNode node;

  CfgNode() { this = TCfgNode(node) }

  ControlFlowNode getNode() { result = node }

  /** Gets a textual representation of this element. */
  override string toString() { result = node.toString() }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node { }

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DataFlowExpr e) { none() }

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends EssaNode {
  ParameterNode() { var instanceof ParameterDefinition }

  /**
   * Holds if this node is the parameter of callable `c` at the
   * (zero-based) index `i`.
   */
  predicate isParameterOf(DataFlowCallable c, int i) {
    var.(ParameterDefinition).getDefiningNode() = c.getParameter(i)
  }

  override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }
}

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends Expr {
  // /** Holds if this guard validates `e` upon evaluating to `v`. */
  // abstract predicate checks(Expr e, AbstractValue v);
  /** Gets a node guarded by this guard. */
  final ExprNode getAGuardedNode() {
    none()
    // exists(Expr e, AbstractValue v |
    //   this.checks(e, v) and
    //   this.controlsNode(result.getControlFlowNode(), e, v)
    // )
  }
}

/**
 * A reference contained in an object. This is either a field or a property.
 */
class Content extends string {
  Content() { this = "Content" }
}
