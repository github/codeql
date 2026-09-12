private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private newtype TDataFlowNode =
  TValueNode(Expr expr) { hasResultValue(expr) or hasIncomingValue(expr, _) } or
  TStrictlyIncomingValue(Expr expr) { hasResultValue(expr) and hasIncomingValue(expr, _) }

/**
 * A node representing something that can have a value.
 */
class Node extends TDataFlowNode {
  /** Holds if this is the result of evaluating `expr`. */
  pragma[nomagic]
  predicate isResultValue(Expr expr) { hasResultValue(expr) and this = TValueNode(expr) }

  /** Holds if this represents the value about to be assigned to `expr` or pattern-matched against `expr`. */
  pragma[nomagic]
  predicate isIncomingValue(Expr expr) {
    // Use the TValueNode when it is not needed for representing the result value
    hasIncomingValue(expr, _) and
    not hasResultValue(expr) and
    this = TValueNode(expr)
    or
    this = TStrictlyIncomingValue(expr)
  }

  /** Gets the expression represented by this node. */
  Expr asExpr() { this = TValueNode(result) }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() { result = this.asExpr() or this = TStrictlyIncomingValue(result) }

  /** Get a string representation of this element. */
  string toString() {
    result = this.asExpr().toString()
    or
    exists(Expr expr |
      this = TStrictlyIncomingValue(expr) and
      result = "[incoming] " + expr.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() { result = this.getWrappedAstNode().getLocation() }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() { result = this.getWrappedAstNode().getEnclosingCallable() }
}
