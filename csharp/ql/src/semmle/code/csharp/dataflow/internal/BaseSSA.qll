import csharp

/**
 * INTERNAL: Do not use.
 *
 * Provides a simple SSA implementation for local scope variables.
 */
module BaseSsa {
  private import ControlFlow
  private import AssignableDefinitions

  pragma[noinline]
  Callable getAnAssigningCallable(LocalScopeVariable v) {
    result = any(AssignableDefinition def | def.getTarget() = v).getEnclosingCallable()
  }

  private class SimpleLocalScopeVariable extends LocalScopeVariable {
    SimpleLocalScopeVariable() { not getAnAssigningCallable(this) != getAnAssigningCallable(this) }
  }

  /**
   * Holds if the `i`th node of basic block `bb` is assignable definition `def`,
   * targeting local scope variable `v`.
   */
  private predicate defAt(BasicBlock bb, int i, AssignableDefinition def, SimpleLocalScopeVariable v) {
    bb.getNode(i) = def.getAControlFlowNode() and
    v = def.getTarget() and
    // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
    not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
      second.getAssignment() = first.getAssignment() and
      second.getEvaluationOrder() > first.getEvaluationOrder() and
      second.getTarget() = v
    )
  }

  /**
   * Holds if basic block `bb` would need to start with a phi node for local scope
   * variable `v` in an SSA representation.
   */
  private predicate needsPhiNode(BasicBlock bb, SimpleLocalScopeVariable v) {
    exists(BasicBlock def | def.inDominanceFrontier(bb) |
      defAt(def, _, _, v) or
      needsPhiNode(def, v)
    )
  }

  private newtype SsaRefKind =
    SsaRead() or
    SsaDef()

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`,
   * either a read (when `k` is `SsaRead()`) or a write including phi nodes
   * (when `k` is `SsaDef()`).
   */
  private predicate ssaRef(BasicBlock bb, int i, SimpleLocalScopeVariable v, SsaRefKind k) {
    bb.getNode(i).getElement() = v.getAnAccess().(VariableRead) and
    k = SsaRead()
    or
    defAt(bb, i, _, v) and
    k = SsaDef()
    or
    needsPhiNode(bb, v) and
    i = -1 and
    k = SsaDef()
  }

  /**
   * Gets the (1-based) rank of the reference to `v` at the `i`th node of basic
   * block `bb`, which has the given reference kind `k`.
   */
  private int ssaRefRank(BasicBlock bb, int i, SimpleLocalScopeVariable v, SsaRefKind k) {
    i = rank[result](int j | ssaRef(bb, j, v, _)) and
    ssaRef(bb, i, v, k)
  }

  /**
   * Holds if definition `def` of local scope variable `v` inside basic block
   * `bb` reaches the reference at rank `rnk`, without passing through another
   * definition of `v`, including phi nodes.
   */
  private predicate defReachesRank(
    BasicBlock bb, AssignableDefinition def, SimpleLocalScopeVariable v, int rnk
  ) {
    exists(int i | rnk = ssaRefRank(bb, i, v, SsaDef()) | defAt(bb, i, def, v))
    or
    defReachesRank(bb, def, v, rnk - 1) and
    rnk = ssaRefRank(bb, _, v, SsaRead())
  }

  /**
   * Holds if definition `def` of local scope variable `v` reaches the end of
   * basic block `bb` without passing through another definition of `v`, including
   * phi nodes.
   */
  private predicate reachesEndOf(AssignableDefinition def, SimpleLocalScopeVariable v, BasicBlock bb) {
    exists(int rnk |
      defReachesRank(bb, def, v, rnk) and
      rnk = max(ssaRefRank(bb, _, v, _))
    )
    or
    exists(BasicBlock mid |
      reachesEndOf(def, v, mid) and
      not exists(ssaRefRank(mid, _, v, SsaDef())) and
      bb = mid.getASuccessor()
    )
  }

  /**
   * Gets a read of the SSA definition for variable `v` at definition `def`. That is,
   * a read that is guaranteed to read the value assigned at definition `def`.
   */
  cached
  AssignableRead getARead(AssignableDefinition def, SimpleLocalScopeVariable v) {
    exists(BasicBlock bb, int i, int rnk |
      result.getAControlFlowNode() = bb.getNode(i) and
      rnk = ssaRefRank(bb, i, v, SsaRead())
    |
      defReachesRank(bb, def, v, rnk)
      or
      reachesEndOf(def, v, bb.getAPredecessor()) and
      not ssaRefRank(bb, _, v, SsaDef()) < rnk
    )
  }
}
