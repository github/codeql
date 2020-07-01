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
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {

  /**
   * Get the underlying SSA variable if this is such a node.
   */
  EssaVariable asEssaNode() { this = TEssaNode(result) }

  /**
   * Get the underlying ControlFlowNode if this is such a node.
   */
  ControlFlowNode asCfgNode() { this = TCfgNode(result) }

  /**
   * Get a string representation of this data flow node.
   */
  string toString() {
    result = this.asEssaNode().toString()
    or
    result = this.asCfgNode().toString()
  }

  /** Gets the enclosing callable of this node. */
  DataFlowCallable getEnclosingCallable() {
    result.getScope() = this.asCfgNode().getNode().getScope() // this allows Cfg -> ESSA def
    or
    result.getScope() = this.asEssaNode().getScope() // this allows ESSA var -> Cfg use
  }

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
    this.asEssaNode().getDefinition().getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.asCfgNode().getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }


}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node {
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DataFlowExpr e) { none() }

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node {
  ParameterNode() {
    this.asEssaNode() instanceof ParameterDefinition
  }

  /**
   * Holds if this node is the parameter of callable `c` at the specified
   * (zero-based) position.
   */
  predicate isParameterOf(DataFlowCallable c, int i) {
    this.asEssaNode().(ParameterDefinition).getDefiningNode() = c.getParameter(i)
  }

  override DataFlowCallable getEnclosingCallable() {
    this.isParameterOf(result, _)
  }
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