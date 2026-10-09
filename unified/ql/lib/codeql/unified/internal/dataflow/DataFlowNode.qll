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
    // Hoist local functions to the top of their block
    declOrAssignment instanceof LocalFunctionDeclaration and
    cfgNode.isBefore(declOrAssignment.getParent())
    or
    // In other cases, it's a binding pattern whose CFG node can be used
    // as its assignment time
    not declOrAssignment instanceof Assignment and
    not declOrAssignment instanceof VariableDeclaration and
    not declOrAssignment instanceof LocalFunctionDeclaration and
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
    expr = call.getCallee()
  )
}

/**
 * Holds if `repr` performs an access to `var` of the given `kind` at `cfgNode`.
 *
 * `repr` should be an arbitrary but unique representative for the access.
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
  TCallableNode(DataFlowCallable callable) or
  TImplicitParameterNode(DataFlowCallable callable, ImplicitParameterPosition pos) or
  TImplicitArgumentNode(DataFlowCall call, ImplicitArgumentPosition pos, Boolean isPost) or
  TLocalSsaNode(LocalSsaDataFlowOutput::SsaNode node) or
  TCaptureSsaNode(CaptureSsaOutput::SynthesizedCaptureNode node)

class TDataFlowNodeStage1 =
  TValueNode or TStrictlyIncomingValue or TExprPostUpdateNode or TLocalVariableRefNode or
      TCallableNode or TImplicitParameterNode or TImplicitArgumentNode;

class TDataFlowNodeStage2 = TDataFlowNodeStage1 or TLocalSsaNode;

/**
 * A data-flow node used during construction of the local data flow graph.
 *
 * This only contains nodes that are materialised in "stage 1".
 */
class BuilderNode extends TDataFlowNodeStage1 {
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

  /** Holds if this node represents an implicit parameter of `callable`. */
  predicate isImplicitParameter(DataFlowCallable callable, ImplicitParameterPosition pos) {
    this = TImplicitParameterNode(callable, pos)
  }

  /** Holds if this node represents an implicit argument to `call` (or its post-update). */
  predicate isImplicitArgument(DataFlowCall call, ImplicitArgumentPosition pos, boolean isPost) {
    this = TImplicitArgumentNode(call, pos, isPost)
  }

  /**
   * Holds if this represents the receiver passed to the given callable.
   *
   * Note that for non-methods and closures that capture the receiver from the enclosing method,
   * this node still exists but will typically not flow anywhere.
   */
  predicate isReceiverParameter(Callable callable) {
    this.isImplicitParameter(getDataFlowCallable(callable),
      any(ParameterPosition p | p.isReceiver()))
  }

  /** Holds if this node represents the receiver argument passed to `call`. */
  predicate isReceiverArgument(CallExpr call) {
    this.isImplicitArgument(getDataFlowCall(call), any(ArgumentPosition p | p.isReceiver()), false)
  }

  /** Holds if this node represents the updated state of the receiver of `call` after the call returns. */
  predicate isReceiverPostUpdate(CallExpr call) {
    this.isImplicitArgument(getDataFlowCall(call), any(ArgumentPosition p | p.isReceiver()), true)
  }

  /** Holds if this is the canonical representative for the given `callable`. */
  predicate isCallableEx(DataFlowCallable callable) { this = TCallableNode(callable) }

  /** Holds if this is the canonical representative for the given `callable`. */
  predicate isCallable(Callable callable) { this = TCallableNode(getDataFlowCallable(callable)) }

  /** Holds if this node represents the function being invoked at `call`. */
  predicate isCalleeArgument(CallExpr call) {
    this.isImplicitArgument(getDataFlowCall(call), any(ArgumentPosition p | p.isCallee()), false)
  }

  /** Holds if this node represents the updated state of the function being invoked at `call`, after the call returns. */
  predicate isCalleePostUpdate(CallExpr call) {
    this.isImplicitArgument(getDataFlowCall(call), any(ArgumentPosition p | p.isCallee()), true)
  }

  /**
   * Gets the post-update node for this node, if any.
   *
   * The post-update node represents the updated state of the value held in this node, after it has been mutated by the surrounding assignment or call.
   */
  pragma[nomagic]
  BuilderNode getPostUpdateNode() {
    exists(Expr expr |
      this.isResultValue(expr) and
      result.isPostUpdate(expr)
    )
    or
    exists(Expr expr, LocalVariable var |
      this.isLocalVariableRead(expr, var) and
      result.isLocalVariablePostUpdate(expr, var)
    )
    or
    exists(DataFlowCall call, ArgumentPosition pos |
      this.isImplicitArgument(call, pos, false) and
      result.isImplicitArgument(call, pos, true)
    )
  }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() {
    this = TValueNode(result) or
    this = TStrictlyIncomingValue(result) or
    this = TExprPostUpdateNode(result)
  }

  /** Get a string representation of this element. */
  string toString() {
    exists(Expr expr |
      this = TValueNode(expr) and
      result = expr.toString()
      or
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
    exists(DataFlowCallable callable |
      exists(ParameterPosition pos |
        this.isImplicitParameter(callable, pos) and
        result = "[" + pos + " param] " + callable.toString()
      )
      or
      this.isCallableEx(callable) and
      result = "[callable] " + callable.toString()
    )
    or
    exists(DataFlowCall call, ArgumentPosition pos |
      this.isImplicitArgument(call, pos, false) and
      result = "[" + pos + " arg] " + call.toString()
      or
      this.isImplicitArgument(call, pos, true) and
      result = "[" + pos + " post] " + call.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() {
    result = this.getWrappedAstNode().getLocation()
    or
    exists(AstNode repr |
      this.isLocalVariableRef(repr, _, _) and
      result = repr.getLocation()
    )
    or
    exists(DataFlowCallable callable |
      this.isImplicitParameter(callable, _)
      or
      this.isCallableEx(callable)
    |
      result = callable.getLocation()
    )
    or
    exists(DataFlowCall call |
      this.isImplicitArgument(call, _, _) and
      result = call.getLocation()
    )
  }
}

/** A node in stage 2, which includes stage 1 and local SSA nodes. */
class Stage2Node extends TDataFlowNodeStage2 {
  /** Get a string representation of this element. */
  string toString() {
    result = this.(BuilderNode).toString()
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result = node.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() {
    result = this.(BuilderNode).getLocation()
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result = node.getLocation()
    )
  }
}

class Node extends TDataFlowNode {
  /** Gets the expression represented by this node. */
  Expr asExpr() { this = TValueNode(result) }

  /** Holds if this is the result of evaluating `expr`. */
  pragma[nomagic]
  predicate isResultValue(Expr expr) { this.(BuilderNode).isResultValue(expr) }

  /** Holds if this represents the value about to be assigned to `expr` or pattern-matched against `expr`. */
  pragma[nomagic]
  predicate isIncomingValue(Expr expr) { this.(BuilderNode).isIncomingValue(expr) }

  /** Holds if this represents the reference to `v` at `repr`. */
  predicate isLocalVariableRef(AstNode repr, LocalVariable v, VariableRefKind kind) {
    this.(BuilderNode).isLocalVariableRef(repr, v, kind)
  }

  /** Holds if this represents the value read from `v` at `repr`. */
  predicate isLocalVariableRead(AstNode repr, LocalVariable v) {
    this.(BuilderNode).isLocalVariableRead(repr, v)
  }

  /** Holds if this represents the value written to `v` at `repr`. */
  predicate isLocalVariableWrite(AstNode repr, LocalVariable v) {
    this.(BuilderNode).isLocalVariableWrite(repr, v)
  }

  /** Holds if this represents the updated state of the value held in `v` after it has been mutated by the surrounding assignment or call. */
  predicate isLocalVariablePostUpdate(AstNode repr, LocalVariable v) {
    this.(BuilderNode).isLocalVariablePostUpdate(repr, v)
  }

  /** Holds if this represents the updated state of the value returned by `expr` after it has been mutated by the surrounding assignment or call. */
  predicate isPostUpdate(Expr expr) { this.(BuilderNode).isPostUpdate(expr) }

  /**
   * Holds if this represents the receiver passed to the given callable.
   *
   * Note that for non-methods and closures that capture the receiver from the enclosing method,
   * this node still exists but will typically not flow anywhere.
   */
  predicate isReceiverParameter(Callable callable) {
    this.(BuilderNode).isReceiverParameter(callable)
  }

  /** Holds if this node represents the receiver argument passed to `call`. */
  predicate isReceiverArgument(CallExpr call) { this.(BuilderNode).isReceiverArgument(call) }

  /** Holds if this node represents the updated state of the receiver of `call` after the call returns. */
  predicate isReceiverPostUpdate(CallExpr call) { this.(BuilderNode).isReceiverPostUpdate(call) }

  /** Holds if this is the canonical representative for the given `callable`. */
  predicate isCallableEx(DataFlowCallable callable) { this.(BuilderNode).isCallableEx(callable) }

  /** Holds if this is the canonical representative for the given `callable`. */
  predicate isCallable(Callable callable) { this.(BuilderNode).isCallable(callable) }

  /**
   * Gets the AST node wrapped by this data flow, if any.
   */
  AstNode getWrappedAstNode() { result = this.(BuilderNode).getWrappedAstNode() }

  /** Get a string representation of this element. */
  string toString() {
    result = this.(Stage2Node).toString()
    or
    exists(CaptureSsaOutput::SynthesizedCaptureNode node |
      this = TCaptureSsaNode(node) and
      result = "[capture] " + node.toString()
    )
  }

  /** Gets the location of this data flow node. */
  Location getLocation() {
    result = this.(Stage2Node).getLocation()
    or
    exists(CaptureSsaOutput::SynthesizedCaptureNode node |
      this = TCaptureSsaNode(node) and
      result = node.getLocation()
    )
  }

  /** Gets the data-flow callable containing this data flow node. */
  DataFlowCallable getEnclosingCallableEx() {
    result.asSourceCallable() = this.getWrappedAstNode().getEnclosingCallable()
    or
    exists(AstNode repr, LocalVariable var, VariableRefKind kind, ControlFlowNode cfgNode |
      this.isLocalVariableRef(repr, var, kind) and
      performsVariableAccess(repr, var, kind, cfgNode) and
      result.asSourceCallable() = cfgNode.getEnclosingCallable()
    )
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      result.asSourceCallable() = node.getSourceVariable().getDeclaringCallable()
    )
    or
    this.(BuilderNode).isImplicitParameter(result, _)
    or
    exists(CaptureSsaOutput::SynthesizedCaptureNode node |
      this = TCaptureSsaNode(node) and
      result.asSourceCallable() = node.getEnclosingCallable()
    )
    or
    this.(BuilderNode).isImplicitParameter(result, _)
    or
    exists(DataFlowCall call |
      this.(BuilderNode).isImplicitArgument(call, _, _) and
      result = call.getEnclosingCallable()
    )
    or
    exists(DataFlowCallable callable |
      this.isCallableEx(callable) and
      result.asSourceCallable() = callable.asSourceCallable().getEnclosingCallable()
    )
  }

  /** Gets the callable containing this data flow node. */
  Callable getEnclosingCallable() { result = this.getEnclosingCallableEx().asSourceCallable() }

  /**
   * Holds if this data flow node is associated with the `i`'th index in the given basic block.
   *
   * Note that some data flow nodes may have an index appearing before the first or after the
   * last `ControlFlowNode` node in the basic block. Multiple data flow nodes may share the same control flow position.
   *
   * Also note that some data flow nodes have no associated control flow position, either because they are
   * in unreachable code, or belong to a synthesized callable that has no control flow graph.
   */
  predicate hasControlFlowPosition(BasicBlock bb, int i) {
    exists(ControlFlowNode cfgNode | cfgNode = bb.getNode(i) |
      exists(Expr expr |
        this.isResultValue(expr) and cfgNode.asExpr() = expr
        or
        this.isIncomingValue(expr) and hasIncomingValueAtCfgNode(expr, cfgNode)
        or
        this.isPostUpdate(expr) and hasPostUpdate(expr, cfgNode)
      )
      or
      exists(AstNode repr, LocalVariable var, VariableRefKind kind |
        this.isLocalVariableRef(repr, var, kind) and
        performsVariableAccess(repr, var, kind, cfgNode)
      )
      or
      exists(DataFlowCallable callable |
        this.(BuilderNode).isImplicitParameter(callable, _) and
        cfgNode.(ControlFlow::EntryNode).getEnclosingCallable() = callable.asSourceCallable()
        or
        this.isCallableEx(callable) and
        cfgNode.injects(callable.asSourceCallable())
      )
      or
      exists(DataFlowCall call, CallExpr sourceCall, boolean isPost |
        call.asExplicitCall() = sourceCall and
        this.(BuilderNode).isImplicitArgument(call, _, isPost) and
        (
          isPost = false and cfgNode.injects(sourceCall)
          or
          isPost = true and cfgNode.isAfter(sourceCall)
        )
      )
    )
    or
    exists(LocalSsaDataFlowOutput::SsaNode node |
      this = TLocalSsaNode(node) and
      bb = node.getBasicBlock() and
      i = node.getIndex() // TODO: why is this marked as internal in the SSA library?
    )
    or
    exists(CaptureSsaOutput::SynthesizedCaptureNode node |
      this = TCaptureSsaNode(node) and
      node.hasCfgNode(bb, i)
    )
  }

  /** Gets the basic block associated with this data flow node, if any. */
  BasicBlock getBasicBlock() { this.hasControlFlowPosition(result, _) }

  /**
   * Gets the post-update node for this node, if any.
   *
   * The post-update node represents the updated state of the value held in this node, after it has been mutated by the surrounding assignment or call.
   */
  Node getPostUpdateNode() {
    result = this.(BuilderNode).getPostUpdateNode()
    or
    result = getCaptureSsaPostUpdate(this)
  }
}
