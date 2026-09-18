private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions
private import codeql.unified.internal.LocalNameBinding
private import codeql.util.Boolean

private predicate hasIncomingValueAtCfgNode(Expr expr, ControlFlowNode cfgNode) {
  exists(AstNode declOrAssignment | hasIncomingValue(expr, declOrAssignment) |
    // In cases where the CFG node for 'expr' appears before its actual assignment,
    // use the CFG node from the surrounding assignment-like node
    cfgNode.injects(declOrAssignment.(Assignment))
    or
    // Variable declarations are pre-order and visit the target first.
    // Use the after node.
    cfgNode.isAfter(declOrAssignment.(VariableDeclaration))
    or
    // In other cases, it's a binding pattern whose CFG node can be used
    // as its assignment time
    not declOrAssignment instanceof Assignment and
    not declOrAssignment instanceof VariableDeclaration and
    cfgNode.injects(expr)
  )
}

private predicate hasPostUpdate(Expr expr, ControlFlowNode cfgNode) {
  exists(MemberAccessExpr member |
    (hasIncomingValueAtCfgNode(member, cfgNode) or hasPostUpdate(member, cfgNode)) and
    expr = member.getBase()
  )
  or
  exists(CallExpr call | cfgNode.isAfter(call) |
    expr = call.getAnArgument().getValue()
    or
    expr = call.getCallee().(MemberAccessExpr).getBase()
  )
}

/**
 * Holds if `repr` performs an access to `var` of the given `kind` at `cfgNode`.
 *
 * `repr` should be an arbitary but unique representative for the access.
 */
predicate performsVariableAccess(
  AstNode repr, LocalVariable var, VariableRefKind kind, ControlFlowNode cfgNode
) {
  exists(LocalVariableAccess access | var = access.getLocalVariable() and repr = access |
    hasResultValue(access) and kind.isRead() and cfgNode.asExpr() = repr
    or
    hasIncomingValueAtCfgNode(access, cfgNode) and kind.isWrite()
    or
    hasPostUpdate(access, cfgNode) and kind.isPostUpdate()
  )
  or
  exists(UnqualifiedMemberAccess access |
    access.isInstanceAccess() and var = access.getImplicitQualifierVariable() and repr = access
  |
    kind.isRead() and cfgNode.isBefore(access)
    or
    (hasIncomingValueAtCfgNode(access, cfgNode) or hasPostUpdate(access, cfgNode)) and
    kind.isPostUpdate()
    or
    exists(CallExpr call |
      access = call.getCallee() and
      cfgNode.isAfter(call) and
      kind.isPostUpdate()
    )
  )
  or
  exists(Callable callable |
    repr = callable and
    var = getImplicitReceiverVariable(callable) and
    kind.isWrite() and
    cfgNode.(ControlFlow::EntryNode).getEnclosingCallable() = callable
  )
}

newtype TDataFlowNode =
  TValueNode(Expr expr) { hasResultValue(expr) or hasIncomingValue(expr, _) } or
  TStrictlyIncomingValue(Expr expr) { hasResultValue(expr) and hasIncomingValue(expr, _) } or
  TExprPostUpdateNode(Expr expr) { hasPostUpdate(expr, _) } or
  TLocalVariableRefNode(AstNode repr, LocalVariable var, VariableRefKind kind) {
    performsVariableAccess(repr, var, kind, _)
  } or
  TLocalSsaNode(LocalSsaDataFlowOutput::SsaNode node) or
  TReceiverParameterNode(DataFlowCallable callable) or
  TReceiverArgumentNode(DataFlowCall call, Boolean isPost)

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

  /** Holds if this represents the reference to `v` at `repr`. */
  predicate isLocalVariableRef(AstNode repr, LocalVariable v, VariableRefKind kind) {
    this = TLocalVariableRefNode(repr, v, kind)
  }

  /** Holds if this represents the value read from `v` at `repr`. */
  predicate isLocalVariableRead(AstNode repr, LocalVariable v) {
    this.isLocalVariableRef(repr, v, TRead())
  }

  /** Holds if this represents the value written to `v` at `repr`. */
  predicate isLocalVariableWrite(AstNode repr, LocalVariable v) {
    this.isLocalVariableRef(repr, v, TWrite())
  }

  /** Holds if this represents the updated state of the value held in `v` after it has been mutated by the surrounding assignment or call. */
  predicate isLocalVariablePostUpdate(AstNode repr, LocalVariable v) {
    this.isLocalVariableRef(repr, v, TPostUpdate())
  }

  /** Holds if this represents the updated state of the value returned by `expr` after it has been mutated by the surrounding assignment or call. */
  predicate isPostUpdate(Expr expr) { this = TExprPostUpdateNode(expr) }

  /**
   * Holds if this represents the receiver passed to the given callable.
   *
   * Note that for non-methods and closures that capture the receiver from the enclosing method,
   * this node still exists but will typically not flow anywhere.
   */
  predicate isReceiverParameter(Callable callable) {
    this.isReceiverParameterEx(any(DataFlowCallable c | c.asSourceCallable() = callable))
  }

  /**
   * Holds if this represents the receiver passed to the given callable.
   *
   * Note that for non-methods and closures that capture the receiver from the enclosing method,
   * this node still exists but will typically not flow anywhere.
   */
  predicate isReceiverParameterEx(DataFlowCallable callable) {
    this = TReceiverParameterNode(callable)
  }

  /** Holds if this node represents the receiver argument passed to `call`. */
  predicate isReceiverArgument(CallExpr call) {
    this.isReceiverArgumentEx(any(DataFlowCall c | c.asExplicitCall() = call))
  }

  /** Holds if this node represents the updated state of the receiver of `call` after the call returns. */
  predicate isReceiverPostUpdate(CallExpr call) {
    this.isReceiverPostUpdateEx(any(DataFlowCall c | c.asExplicitCall() = call))
  }

  /** Holds if this node represents the receiver argument passed to `call`. */
  predicate isReceiverArgumentEx(DataFlowCall call) { this.isReceiverArgumentEx(call, false) }

  /** Holds if this node represents the updated state of the receiver of `call` after the call returns. */
  predicate isReceiverPostUpdateEx(DataFlowCall call) { this.isReceiverArgumentEx(call, true) }

  /** Holds if this node represents the receiver argument passed to `call`. */
  predicate isReceiverArgumentEx(DataFlowCall call, boolean isPost) {
    this = TReceiverArgumentNode(call, isPost)
  }

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
    or
    exists(DataFlowCallable callable |
      this.isReceiverParameterEx(callable) and
      result = "[receiver] " + callable.toString()
    )
    or
    exists(DataFlowCall call |
      this.isReceiverArgumentEx(call) and
      result = "[receiver arg] " + call.toString()
      or
      this.isReceiverPostUpdateEx(call) and
      result = "[receiver post] " + call.toString()
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
    or
    exists(DataFlowCallable callable |
      this.isReceiverParameterEx(callable) and
      result = callable.getLocation()
    )
    or
    exists(DataFlowCall call |
      this.isReceiverArgumentEx(call, _) and
      result = call.getLocation()
    )
  }

  /** Gets the data-flow callable containing this data flow node. */
  DataFlowCallable getEnclosingCallableEx() {
    result.asSourceCallable() = this.getWrappedAstNode().getEnclosingCallable()
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result.asSourceCallable() = node.getSourceVariable().getDeclaringCallable()
    )
    or
    this.isReceiverParameterEx(result)
    or
    exists(DataFlowCall call |
      this.isReceiverArgumentEx(call, _) and
      result = call.getEnclosingCallable()
    )
  }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() { result = this.getEnclosingCallableEx().asSourceCallable() }
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
  or
  exists(DataFlowCall call |
    pre.isReceiverArgumentEx(call) and
    result.isReceiverPostUpdateEx(call)
  )
}
