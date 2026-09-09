private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private predicate hasPostUpdate(Expr expr) {
  exists(MemberAccessExpr member |
    (hasIncomingValue(member, _) or hasPostUpdate(member)) and
    expr = member.getBase()
  )
}

private newtype TDataFlowNode =
  TValueNode(Expr expr) { hasResultValue(expr) or hasIncomingValue(expr, _) } or
  TStrictlyIncomingValue(Expr expr) { hasResultValue(expr) and hasIncomingValue(expr, _) } or
  TPostUpdateNode(Expr expr) { hasPostUpdate(expr) } or
  TLocalVariableNode(LocalVariable v)

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

  /** Holds if this represents the value stored in the given local variable. */
  predicate isLocalVariable(LocalVariable v) { this = TLocalVariableNode(v) }

  /** Holds if this represents the updated state of the value returned by `expr` after it has been mutated by the surrounding assignment or call. */
  predicate isPostUpdate(Expr expr) { this = TPostUpdateNode(expr) }

  /** Gets the expression represented by this node. */
  Expr asExpr() { this = TValueNode(result) }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() {
    result = this.asExpr() or
    this = TStrictlyIncomingValue(result) or
    this = TPostUpdateNode(result)
  }

  /** Get a string representation of this element. */
  string toString() {
    result = this.asExpr().toString()
    or
    exists(Expr expr |
      this = TStrictlyIncomingValue(expr) and
      result = "[incoming] " + expr.toString()
      or
      this = TPostUpdateNode(expr) and
      result = "[post] " + expr.toString()
    )
    or
    exists(LocalVariable v |
      this.isLocalVariable(v) and
      result = "[variable] " + v.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() {
    result = this.getWrappedAstNode().getLocation()
    or
    exists(LocalVariable v | this.isLocalVariable(v) and result = v.getLocation())
  }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() {
    result = this.getWrappedAstNode().getEnclosingCallable()
    or
    exists(LocalVariable v |
      this.isLocalVariable(v) and
      result = v.getABinding().getEnclosingCallable()
    )
  }
}

Node getPostUpdateNode(Node pre) {
  exists(Expr expr |
    pre.isResultValue(expr) and
    result.isPostUpdate(expr)
  )
}
