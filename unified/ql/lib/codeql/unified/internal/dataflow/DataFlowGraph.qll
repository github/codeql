private import unified
private import AllDataFlow
private import codeql.unified.internal.LocalNameBinding

predicate step(Node node1, Step step, Node node2) {
  any(DataFlowPlugin p).step(node1, step, node2)
  or
  exists(Callable callable |
    node1.isReceiverParameter(callable) and
    step.value() and
    node2.isLocalVariableWrite(callable, getImplicitReceiverVariable(callable))
  )
  or
  exists(CallExpr call, Expr receiverExpr |
    receiverExpr = call.getCallee().(MemberAccessExpr).getBase()
  |
    node1.isResultValue(receiverExpr) and
    step.value() and
    node2.isReceiverArgument(call)
    or
    node1.isReceiverPostUpdate(call) and
    step.value() and
    node2.isPostUpdate(receiverExpr)
  )
  or
  exists(CallExpr call, UnqualifiedMemberAccess callee | callee = call.getCallee() |
    node1.isLocalVariableRead(callee, callee.getImplicitQualifierVariable()) and
    step.value() and
    node2.isReceiverArgument(call)
    or
    node1.isReceiverPostUpdate(call) and
    step.value() and
    node2.isLocalVariablePostUpdate(callee, callee.getImplicitQualifierVariable())
  )
  or
  exists(VariableDeclaration decl |
    node1.isResultValue(decl.getValue()) and
    step.value() and
    node2.isIncomingValue(decl.getPattern())
  )
  or
  exists(AssignExpr assign |
    node1.isResultValue(assign.getValue()) and
    step.value() and
    node2.isIncomingValue(assign.getTarget())
  )
  or
  // For compound assignments, the result of the expression represents the result of the operator.
  // Make it flow to the target of the assignment.
  exists(CompoundAssignExpr assign |
    node1.isResultValue(assign) and
    step.value() and
    node2.isIncomingValue(assign.getTarget())
  )
  or
  exists(LocalVariableAccess access |
    node1.isLocalVariableRead(access, access.getLocalVariable()) and
    step.value() and
    node2.isResultValue(access)
    or
    node1.isIncomingValue(access) and
    step.value() and
    node2.isLocalVariableWrite(access, access.getLocalVariable())
    or
    node1.isPostUpdate(access) and
    step.value() and
    node2.isLocalVariablePostUpdate(access, access.getLocalVariable())
  )
  or
  exists(UnqualifiedMemberAccess access | access.isInstanceAccess() |
    node1.isLocalVariableRead(access, access.getImplicitQualifierVariable()) and
    step.readName(access.getName()) and
    node2.isResultValue(access)
    or
    (node1.isIncomingValue(access) or node1.isPostUpdate(access)) and
    step.storeName(access.getName()) and
    node2.isLocalVariablePostUpdate(access, access.getImplicitQualifierVariable())
  )
  or
  exists(StringInterpolationExpr expr |
    node1.isResultValue(expr.getAnElement()) and
    step.taint() and
    node2.isResultValue(expr)
  )
  or
  exists(TupleExpr expr, int i |
    node1.isResultValue(expr.getElement(i).getValue()) and
    step.storeName(i.toString()) and
    node2.isResultValue(expr)
    or
    node1.isIncomingValue(expr) and
    step.readName(i.toString()) and
    node2.isIncomingValue(expr.getElement(i).getValue())
  )
  or
  exists(MemberAccessExpr expr |
    node1.isResultValue(expr.getBase()) and
    step.readName(expr.getMemberName()) and
    node2.isResultValue(expr)
    or
    (node1.isIncomingValue(expr) or node1.isPostUpdate(expr)) and
    step.storeName(expr.getMemberName()) and
    node2.isPostUpdate(expr.getBase())
  )
  or
  none() // Temporarily disable compilation errors from unsatisfiable types
}

/** Holds if `node` should be included in the debug view. */
private signature predicate relevantNodeSig(AstNode node);

module DebugGraph<relevantNodeSig/1 relevantNode> {
  private Node adjacent(Node n) {
    step(n, _, result)
    or
    step(result, _, n)
    or
    localSsaStep(n, result, _)
    or
    localSsaStep(result, n, _)
  }

  private predicate relevantDataFlowNode(Node node) {
    relevantNode(node.getWrappedAstNode())
    or
    not exists(node.getWrappedAstNode()) and
    relevantDataFlowNode(adjacent(node))
  }

  query predicate nodes(Node node, string key, string value) {
    relevantDataFlowNode(node) and
    key = "semmle.label" and
    value = node.toString()
  }

  query predicate edges(Node node1, Node node2, string key, string value) {
    key = "semmle.label" and
    relevantDataFlowNode(node1) and
    relevantDataFlowNode(node2) and
    (
      exists(Step step |
        step(node1, step, node2) and
        value = step.toString()
      )
      or
      exists(boolean isUseStep |
        localSsaStep(node1, node2, isUseStep) and
        if isUseStep = true then value = "use-use" else value = "def-use"
      )
      or
      node2 = getPostUpdateNode(node1) and
      value = "post-update"
    )
  }
}
