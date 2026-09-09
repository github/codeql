private import unified
private import AllDataFlow

predicate step(Node node1, Step step, Node node2) {
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
  // dummy implementation: make all writes and post-updates flow to all reads
  step.value() and
  exists(LocalVariable v |
    (
      node1.isLocalVariableWrite(_, v)
      or
      node1.isLocalVariablePostUpdate(_, v)
    ) and
    node2.isLocalVariableRead(_, v)
  )
  or
  exists(BinaryExpr expr |
    expr.getOperator().getValue() = "+" and
    node1.isResultValue([expr.getLeft(), expr.getRight()]) and
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
      node2 = getPostUpdateNode(node1) and
      value = "post-update"
    )
  }
}
