import csharp
private import DataFlowPrivate
private import DataFlowPublic

private class ControlFlowScope extends ControlFlowElement {
  private boolean exactScope;

  ControlFlowScope() {
    exists(ControlFlowReachabilityConfiguration c |
      c.candidate(_, _, this, exactScope, _) or
      c.candidateDef(_, _, this, exactScope, _)
    )
  }

  predicate isExact() { exactScope = true }

  predicate isNonExact() { exactScope = false }
}

private ControlFlowElement getANonExactScopeChild(ControlFlowScope scope) {
  scope.isNonExact() and
  result = scope
  or
  result = getANonExactScopeChild(scope).getAChild()
}

pragma[noinline]
private ControlFlow::BasicBlock getABasicBlockInScope(ControlFlowScope scope, boolean exactScope) {
  result.getANode().getElement() = getANonExactScopeChild(scope) and
  exactScope = false
  or
  scope.isExact() and
  result.getANode().getElement() = scope and
  exactScope = true
}

/**
 * A helper class for determining control-flow reachability for pairs of
 * elements.
 *
 * This is useful when defining for example expression-based data-flow steps in
 * the presence of control-flow splitting, where a data-flow step should make
 * sure to stay in the same split.
 *
 * For example, in
 *
 * ```
 * if (b)
 *     ....
 * var x = "foo";
 * if (b)
 *     ....
 * ```
 *
 * there should only be steps from `[b = true] "foo"` to `[b = true] SSA def(x)`
 * and `[b = false] "foo"` to `[b = false] SSA def(x)`, and for example not from
 * `[b = true] "foo"` to `[b = false] SSA def(x)`
 */
abstract class ControlFlowReachabilityConfiguration extends string {
  bindingset[this]
  ControlFlowReachabilityConfiguration() { any() }

  /**
   * Holds if `e1` and `e2` are expressions for which we want to find a
   * control-flow path that follows control flow successors (resp.
   * predecessors, as specified by `isSuccesor`) inside the syntactic scope
   * `scope`. The Boolean `exactScope` indicates whether a transitive child
   * of `scope` is allowed (`exactScope = false`).
   */
  predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    none()
  }

  /**
   * Holds if `e` and `def` are elements for which we want to find a
   * control-flow path that follows control flow successors (resp.
   * predecessors, as specified by `isSuccesor`) inside the syntactic scope
   * `scope`. The Boolean `exactScope` indicates whether a transitive child
   * of `scope` is allowed (`exactScope = false`).
   */
  predicate candidateDef(
    Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
    boolean isSuccessor
  ) {
    none()
  }

  pragma[nomagic]
  private predicate reachesBasicBlockExprRec(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor,
    ControlFlow::Nodes::ElementNode cfn1, ControlFlow::BasicBlock bb
  ) {
    exists(ControlFlow::BasicBlock mid |
      this.reachesBasicBlockExpr(e1, e2, scope, exactScope, isSuccessor, cfn1, mid)
    |
      isSuccessor = true and
      bb = mid.getASuccessor()
      or
      isSuccessor = false and
      bb = mid.getAPredecessor()
    )
  }

  pragma[nomagic]
  private predicate reachesBasicBlockExpr(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor,
    ControlFlow::Nodes::ElementNode cfn1, ControlFlow::BasicBlock bb
  ) {
    this.candidate(e1, e2, scope, exactScope, isSuccessor) and
    cfn1 = e1.getAControlFlowNode() and
    bb = cfn1.getBasicBlock()
    or
    this.candidate(e1, e2, scope, exactScope, isSuccessor) and
    exists(ControlFlowElement scope0, boolean exactScope0 |
      this.reachesBasicBlockExprRec(e1, e2, scope0, exactScope0, isSuccessor, cfn1, bb)
    |
      bb = getABasicBlockInScope(scope0, exactScope0)
    )
  }

  pragma[nomagic]
  private predicate reachesBasicBlockDefinitionRec(
    Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
    boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn, ControlFlow::BasicBlock bb
  ) {
    exists(ControlFlow::BasicBlock mid |
      this.reachesBasicBlockDefinition(e, def, scope, exactScope, isSuccessor, cfn, mid)
    |
      isSuccessor = true and
      bb = mid.getASuccessor()
      or
      isSuccessor = false and
      bb = mid.getAPredecessor()
    )
  }

  pragma[nomagic]
  private predicate reachesBasicBlockDefinition(
    Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
    boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn, ControlFlow::BasicBlock bb
  ) {
    this.candidateDef(e, def, scope, exactScope, isSuccessor) and
    cfn = e.getAControlFlowNode() and
    bb = cfn.getBasicBlock()
    or
    this.candidateDef(e, def, scope, exactScope, isSuccessor) and
    exists(ControlFlowElement scope0, boolean exactScope0 |
      this.reachesBasicBlockDefinitionRec(e, def, scope0, exactScope0, isSuccessor, cfn, bb)
    |
      bb = getABasicBlockInScope(scope0, exactScope0)
    )
  }

  /**
   * Holds if there is a control-flow path from `cfn1` to `cfn2`, where `cfn1` is a
   * control-flow node for `e1` and `cfn2` is a control-flow node for `e2`.
   */
  predicate hasExprPath(Expr e1, ControlFlow::Node cfn1, Expr e2, ControlFlow::Node cfn2) {
    exists(ControlFlow::BasicBlock bb | this.reachesBasicBlockExpr(e1, e2, _, _, _, cfn1, bb) |
      cfn2 = bb.getANode() and
      cfn2 = e2.getAControlFlowNode()
    )
  }

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnDef`, where `cfn` is a
   * control-flow node for `e` and `cfnDef` is a control-flow node for `def`.
   */
  predicate hasDefPath(
    Expr e, ControlFlow::Node cfn, AssignableDefinition def, ControlFlow::Node cfnDef
  ) {
    exists(ControlFlow::BasicBlock bb | this.reachesBasicBlockDefinition(e, def, _, _, _, cfn, bb) |
      def.getAControlFlowNode() = cfnDef and
      cfnDef = bb.getANode()
    )
  }

  /**
   * Holds if there is a control-flow path from `n1` to `n2`. `n2` is either an
   * expression node or an SSA definition node.
   */
  predicate hasNodePath(ExprNode n1, Node n2) {
    exists(Expr e1, ControlFlow::Node cfn1, Expr e2, ControlFlow::Node cfn2 |
      this.hasExprPath(e1, cfn1, e2, cfn2)
    |
      cfn1 = n1.getControlFlowNode() and
      cfn2 = n2.(ExprNode).getControlFlowNode()
    )
    or
    exists(
      Expr e, ControlFlow::Node cfn, AssignableDefinition def, ControlFlow::Node cfnDef,
      Ssa::ExplicitDefinition ssaDef
    |
      this.hasDefPath(e, cfn, def, cfnDef)
    |
      cfn = n1.getControlFlowNode() and
      ssaDef.getADefinition() = def and
      ssaDef.getControlFlowNode() = cfnDef and
      n2.(SsaDefinitionNode).getDefinition() = ssaDef
    )
  }
}
