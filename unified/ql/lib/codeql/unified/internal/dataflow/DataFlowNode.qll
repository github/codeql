private import unified
private import AllDataFlow

private newtype TDataFlowNode = TValueNode(Expr expr)

/**
 * A node representing something that can have a value.
 */
class Node extends TDataFlowNode {
  /** Holds if this is the result of evaluating `expr`. */
  predicate isResultValue(Expr expr) { this = TValueNode(expr) }

  /** Gets the expression represented by this node. */
  Expr asExpr() { this = TValueNode(result) }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() { result = this.asExpr() }

  /** Get a string representation of this element. */
  string toString() { result = this.asExpr().toString() }

  /** Gets the location of this data flow node. */
  Location getLocation() { result = this.getWrappedAstNode().getLocation() }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() { result = this.getWrappedAstNode().getEnclosingCallable() }
}
