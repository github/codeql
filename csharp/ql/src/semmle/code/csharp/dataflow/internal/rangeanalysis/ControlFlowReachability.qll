import csharp

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
 * ```csharp
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
   * predecessors, as specified by `isSuccessor`) inside the syntactic scope
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
   * predecessors, as specified by `isSuccessor`) inside the syntactic scope
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
  private predicate reachesBasicBlockExprBase(
    Expr e1, Expr e2, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn1, int i,
    ControlFlow::BasicBlock bb
  ) {
    this.candidate(e1, e2, _, _, isSuccessor) and
    cfn1 = e1.getAControlFlowNode() and
    bb.getNode(i) = cfn1
  }

  pragma[nomagic]
  private predicate reachesBasicBlockExprRec(
    Expr e1, Expr e2, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn1,
    ControlFlow::BasicBlock bb
  ) {
    exists(ControlFlow::BasicBlock mid |
      this.reachesBasicBlockExpr(e1, e2, isSuccessor, cfn1, mid)
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
    Expr e1, Expr e2, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn1,
    ControlFlow::BasicBlock bb
  ) {
    this.reachesBasicBlockExprBase(e1, e2, isSuccessor, cfn1, _, bb)
    or
    exists(ControlFlowElement scope, boolean exactScope |
      this.candidate(e1, e2, scope, exactScope, isSuccessor) and
      this.reachesBasicBlockExprRec(e1, e2, isSuccessor, cfn1, bb) and
      bb = getABasicBlockInScope(scope, exactScope)
    )
  }

  pragma[nomagic]
  private predicate reachesBasicBlockDefinitionBase(
    Expr e, AssignableDefinition def, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn,
    int i, ControlFlow::BasicBlock bb
  ) {
    this.candidateDef(e, def, _, _, isSuccessor) and
    cfn = e.getAControlFlowNode() and
    bb.getNode(i) = cfn
  }

  pragma[nomagic]
  private predicate reachesBasicBlockDefinitionRec(
    Expr e, AssignableDefinition def, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn,
    ControlFlow::BasicBlock bb
  ) {
    exists(ControlFlow::BasicBlock mid |
      this.reachesBasicBlockDefinition(e, def, isSuccessor, cfn, mid)
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
    Expr e, AssignableDefinition def, boolean isSuccessor, ControlFlow::Nodes::ElementNode cfn,
    ControlFlow::BasicBlock bb
  ) {
    this.reachesBasicBlockDefinitionBase(e, def, isSuccessor, cfn, _, bb)
    or
    exists(ControlFlowElement scope, boolean exactScope |
      this.candidateDef(e, def, scope, exactScope, isSuccessor) and
      this.reachesBasicBlockDefinitionRec(e, def, isSuccessor, cfn, bb) and
      bb = getABasicBlockInScope(scope, exactScope)
    )
  }

  /**
   * Holds if there is a control-flow path from `cfn1` to `cfn2`, where `cfn1` is a
   * control-flow node for `e1` and `cfn2` is a control-flow node for `e2`.
   */
  pragma[nomagic]
  predicate hasExprPath(Expr e1, ControlFlow::Node cfn1, Expr e2, ControlFlow::Node cfn2) {
    exists(ControlFlow::BasicBlock bb, boolean isSuccessor, int i, int j |
      this.reachesBasicBlockExprBase(e1, e2, isSuccessor, cfn1, i, bb) and
      cfn2 = bb.getNode(j) and
      cfn2 = e2.getAControlFlowNode()
    |
      isSuccessor = true and j >= i
      or
      isSuccessor = false and i >= j
    )
    or
    exists(ControlFlow::BasicBlock bb |
      this.reachesBasicBlockExprRec(e1, e2, _, cfn1, bb) and
      cfn2 = bb.getANode() and
      cfn2 = e2.getAControlFlowNode()
    )
  }

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnDef`, where `cfn` is a
   * control-flow node for `e` and `cfnDef` is a control-flow node for `def`.
   */
  pragma[nomagic]
  predicate hasDefPath(
    Expr e, ControlFlow::Node cfn, AssignableDefinition def, ControlFlow::Node cfnDef
  ) {
    exists(ControlFlow::BasicBlock bb, boolean isSuccessor, int i, int j |
      this.reachesBasicBlockDefinitionBase(e, def, isSuccessor, cfn, i, bb) and
      cfnDef = bb.getNode(j) and
      def.getAControlFlowNode() = cfnDef
    |
      isSuccessor = true and j >= i
      or
      isSuccessor = false and i >= j
    )
    or
    exists(ControlFlow::BasicBlock bb |
      this.reachesBasicBlockDefinitionRec(e, def, _, cfn, bb) and
      def.getAControlFlowNode() = cfnDef and
      cfnDef = bb.getANode()
    )
  }
}
