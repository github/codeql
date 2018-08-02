import csharp

private cached module MiniSsa {
  private import ControlFlowGraph

  /**
   * Holds if the `i`th node of basic block `bb` is assignable definition `def`,
   * targeting local scope variable `v`.
   */
  private predicate defAt(BasicBlock bb, int i, AssignableDefinition def, LocalScopeVariable v) {
    bb.getNode(i) = def.getAControlFlowNode() and
    v = def.getTarget()
  }

  /**
   * Holds if basic block `bb` would need to start with a phi node for local scope
   * variable `v` in an SSA representation.
   */
  private predicate needsPhiNode(BasicBlock bb, LocalScopeVariable v) {
    exists(BasicBlock def |
      def.inDominanceFrontier(bb) |
      defAt(def, _, _, v) or
      needsPhiNode(def, v)
    )
  }

  private newtype SsaRefKind = SsaRead() or SsaDef()

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`,
   * either a read (when `k` is `SsaRead()`) or a write including phi nodes
   * (when `k` is `SsaDef()`).
   */
  private predicate ssaRef(BasicBlock bb, int i, LocalScopeVariable v, SsaRefKind k) {
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
  private int ssaRefRank(BasicBlock bb, int i, LocalScopeVariable v, SsaRefKind k) {
    i = rank[result](int j | ssaRef(bb, j, v, _)) and
    ssaRef(bb, i, v, k)
  }

  /**
   * Holds if definition `def` of local scope variable `v` inside basic block
   * `bb` reaches the reference at rank `rnk`, without passing through another
   * definition of `v`, including phi nodes.
   */
  private predicate defReachesRank(BasicBlock bb, AssignableDefinition def, LocalScopeVariable v, int rnk) {
    exists(int i |
      rnk = ssaRefRank(bb, i, v, SsaDef()) |
      defAt(bb, i, def, v)
    )
    or
    defReachesRank(bb, def, v, rnk - 1) and
    rnk = ssaRefRank(bb, _, v, SsaRead())
  }

  /**
   * Holds if definition `def` of local scope variable `v` reaches the end of
   * basic block `bb` without passing through another definition of `v`, including
   * phi nodes.
   */
  private predicate reachesEndOf(AssignableDefinition def, LocalScopeVariable v, BasicBlock bb) {
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
  cached AssignableRead getARead(AssignableDefinition def, LocalScopeVariable v) {
    exists(BasicBlock bb, int i, int rnk |
      result.getTarget() = v and
      result.getAControlFlowNode() = bb.getNode(i) and
      rnk = ssaRefRank(bb, i, v, SsaRead())
      |
      defReachesRank(bb, def, v, rnk)
      or
      reachesEndOf(def, v, bb.getAPredecessor()) and
      not ssaRefRank(bb, i, v, SsaDef()) < rnk
    )
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides functionality for performing simple data flow analysis.
 * This library is used by the dispatch library, which in turn is used by the
 * SSA library, so we cannot make use of the SSA library in this library.
 * Instead, this library relies on a self-contained, minimalistic SSA-like
 * implementation.
 */
module DataFlowInternal {
  /**
   * Gets a read that is guaranteed to read the value assigned at definition `def`.
   */
  private AssignableRead getARead(AssignableDefinition def) {
    result = MiniSsa::getARead(def, _)
    or
    exists(LocalScopeVariable v |
      def.getTarget() = v |
      result = v.getAnAccess() and
      strictcount(AssignableDefinition def0 | def0.getTarget() = v) = 1
    )
    or
    exists(Field f |
      def.getTarget() = f and
      result = f.getAnAccess() and
      strictcount(AssignableDefinition def0 | def0.getTarget() = f) = 1 |
      f.isReadOnly() or
      f.isConst() or
      isEffectivelyInternalOrPrivate(f)
    )
  }

  /**
   * Holds if callable `c` is effectively private or internal (either directly
   * or because one of `c`'s enclosing types is).
   */
  private predicate isEffectivelyInternalOrPrivateCallable(Callable c) {
    isEffectivelyInternalOrPrivate(c) or
    c instanceof LocalFunction
  }

  /**
   * Holds if modifiable `m` is effectively private or internal (either directly
   * or because one of `m`'s enclosing types is).
   */
  private predicate isEffectivelyInternalOrPrivate(Modifiable m) {
    m.isEffectivelyInternal() or
    m.isEffectivelyPrivate()
  }

  private predicate flowIn(Parameter p, Expr pred, AssignableRead succ) {
    exists(AssignableDefinitions::ImplicitParameterDefinition def, Call c |
      succ = getARead(def) |
      pred = getArgumentForOverridderParameter(c, p) and
      p.getSourceDeclaration() = def.getParameter()
    )
  }

  private Expr getArgumentForOverridderParameter(Call call, Parameter p) {
    exists(Parameter base, Callable callable |
      result = call.getArgumentForParameter(base) |
      base = callable.getAParameter() and
      isOverriderParameter(callable, p, base.getPosition())
    )
  }

  pragma [noinline]
  private predicate isOverriderParameter(Callable c, Parameter p, int i) {
    (
      p = c.getAParameter() or
      p = c.(Method).getAnOverrider+().getAParameter() or
      p = c.(Method).getAnUltimateImplementor().getAParameter()
    )
    and
    i = p.getPosition()
  }

  /**
   * Holds if there is data flow from `pred` to `succ`, under a closed-world
   * assumption. For example, there is flow from `0` on line 3 to `i` on line
   * 8 and from `1` on line 4 to `i` on line 12 in
   *
   * ```
   * public class C {
   *   public void A() {
   *     B(0);
   *     C(1);
   *   }
   *
   *   private void B(int i) {
   *     System.Console.WriteLine(i);
   *   }
   *
   *   public virtual void C(int i) {
   *     System.Console.WriteLine(i);
   *   }
   * }
   * ```
   */
  predicate stepClosed(Expr pred, Expr succ) {
    stepOpen(pred, succ) or
    flowIn(_, pred, succ)
  }

  /**
   * Holds if there is data flow from `pred` to `succ`, under an open-world
   * assumption. For example, there is flow from `0` on line 3 to `i` on line
   * 8 (but not from `1` on line 4 to `i` on line 12 because `C` is virtual)
   * in
   *
   * ```
   * public class C {
   *   public void A() {
   *     B(0);
   *     C(1);
   *   }
   *
   *   private void B(int i) {
   *     System.Console.WriteLine(i);
   *   }
   *
   *   public virtual void C(int i) {
   *     System.Console.WriteLine(i);
   *   }
   * }
   * ```
   */
  predicate stepOpen(Expr pred, Expr succ) {
    exists(AssignableDefinition def |
      succ = getARead(def) |
      pred = def.getSource()
    )
    or
    exists(Parameter p |
      flowIn(p, pred, succ) |
      isEffectivelyInternalOrPrivateCallable(p.getCallable())
    )
    or
    pred = succ.(CastExpr).getExpr()
  }
}
