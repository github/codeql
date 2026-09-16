private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private predicate hasIncomingValueAtCfgNode(Expr expr, ControlFlowNode cfgNode) {
  exists(AstNode declOrAssignment |
    hasIncomingValue(expr, declOrAssignment) and
    cfgNode.injects(declOrAssignment)
  )
}

private predicate hasPostUpdate(Expr expr, ControlFlowNode cfgNode) {
  exists(MemberAccessExpr member |
    (hasIncomingValueAtCfgNode(member, cfgNode) or hasPostUpdate(member, cfgNode)) and
    expr = member.getBase()
  )
}

/**
 * Holds if `expr` performs an access to `var` of the given `kind` at `cfgNode`.
 */
predicate performsVariableAccess(
  Expr expr, LocalVariable var, VariableRefKind kind, ControlFlowNode cfgNode
) {
  exists(LocalVariableAccess access | var = access.getLocalVariable() and expr = access |
    hasResultValue(access) and kind.isRead() and cfgNode.asExpr() = expr
    or
    hasIncomingValueAtCfgNode(access, cfgNode) and kind.isWrite()
    or
    hasPostUpdate(access, cfgNode) and kind.isPostUpdate()
  )
  or
  exists(UnqualifiedMemberAccess access |
    access.isInstanceAccess() and var = access.getImplicitQualifierVariable() and expr = access
  |
    kind.isRead() and cfgNode.isBefore(access)
    or
    (hasIncomingValueAtCfgNode(access, cfgNode) or hasPostUpdate(access, cfgNode)) and
    kind.isPostUpdate()
  )
}

newtype TDataFlowNode =
  TValueNode(Expr expr) { hasResultValue(expr) or hasIncomingValue(expr, _) } or
  TStrictlyIncomingValue(Expr expr) { hasResultValue(expr) and hasIncomingValue(expr, _) } or
  TExprPostUpdateNode(Expr expr) { hasPostUpdate(expr, _) } or
  TLocalVariableRefNode(Expr expr, LocalVariable var, VariableRefKind kind) {
    performsVariableAccess(expr, var, kind, _)
  } or
  TLocalSsaNode(LocalSsaDataFlowOutput::SsaNode node)

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

  /** Holds if this represents the reference to `v` at `access`. */
  predicate isLocalVariableRef(Expr access, LocalVariable v, VariableRefKind kind) {
    this = TLocalVariableRefNode(access, v, kind)
  }

  /** Holds if this represents the value read from `v` at `access`. */
  predicate isLocalVariableRead(Expr access, LocalVariable v) {
    this.isLocalVariableRef(access, v, TRead())
  }

  /** Holds if this represents the value written to `v` at `access`. */
  predicate isLocalVariableWrite(Expr access, LocalVariable v) {
    this.isLocalVariableRef(access, v, TWrite())
  }

  /** Holds if this represents the updated state of the value held in `v` after it has been mutated by the surrounding assignment or call. */
  predicate isLocalVariablePostUpdate(Expr access, LocalVariable v) {
    this.isLocalVariableRef(access, v, TPostUpdate())
  }

  /** Holds if this represents the updated state of the value returned by `expr` after it has been mutated by the surrounding assignment or call. */
  predicate isPostUpdate(Expr expr) { this = TExprPostUpdateNode(expr) }

  /** Gets the expression represented by this node. */
  Expr asExpr() { this = TValueNode(result) }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() {
    result = this.asExpr() or
    this = TStrictlyIncomingValue(result) or
    this = TExprPostUpdateNode(result) or
    this = TLocalVariableRefNode(result, _, _)
  }

  /** Get a string representation of this element. */
  string toString() {
    result = this.asExpr().toString()
    or
    exists(Expr expr |
      this = TStrictlyIncomingValue(expr) and
      result = "[incoming] " + expr.toString()
      or
      this = TExprPostUpdateNode(expr) and
      result = "[post] " + expr.toString()
    )
    or
    exists(LocalVariable v, VariableRefKind kind |
      this = TLocalVariableRefNode(_, v, kind) and
      result = "[variable " + kind + "] " + v.toString()
    )
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result = node.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() {
    result = this.getWrappedAstNode().getLocation()
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result = node.getLocation()
    )
  }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() {
    result = this.getWrappedAstNode().getEnclosingCallable()
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result = node.getSourceVariable().getDeclaringCallable()
    )
  }
}

Node getPostUpdateNode(Node pre) {
  exists(Expr expr |
    pre.isResultValue(expr) and
    result.isPostUpdate(expr)
  )
  or
  exists(Expr expr, LocalVariable var |
    pre.isLocalVariableRead(expr, var) and
    result.isLocalVariablePostUpdate(expr, var)
  )
}
