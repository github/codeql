private import codeql.rangeanalysis.RangeAnalysis
private import codeql.util.Location

module MakeUtils<LocationSig Location, Semantic<Location> Lang, DeltaSig D> {
  private import Lang

  /**
   * Gets an expression that equals `v - d`.
   */
  Expr ssaRead(SsaVariable v, D::Delta delta) {
    result = v.getAUse() and delta = D::fromInt(0)
    or
    exists(D::Delta d1, ConstantIntegerExpr c |
      result.(AddExpr).hasOperands(ssaRead(v, d1), c) and
      delta = D::fromFloat(D::toFloat(d1) - c.getIntValue()) and
      // In the scope of `x += ..`, which is SSA translated as `x2 = x1 + ..`,
      // the variable `x1` is shadowed by `x2`, so there's no need to view this
      // as a read of `x1`.
      not isAssignOp(result)
    )
    or
    exists(SubExpr sub, D::Delta d1, ConstantIntegerExpr c |
      result = sub and
      sub.getLeftOperand() = ssaRead(v, d1) and
      sub.getRightOperand() = c and
      delta = D::fromFloat(D::toFloat(d1) + c.getIntValue()) and
      not isAssignOp(result)
    )
    or
    result = v.(SsaExplicitUpdate).getDefiningExpr() and
    if result instanceof PostIncExpr
    then delta = D::fromFloat(1) // x++ === ++x - 1
    else
      if result instanceof PostDecExpr
      then delta = D::fromFloat(-1) // x-- === --x + 1
      else delta = D::fromFloat(0)
    or
    result.(CopyValueExpr).getOperand() = ssaRead(v, delta)
  }

  /**
   * Gets a condition that tests whether `v` equals `e + delta`.
   *
   * If the condition evaluates to `testIsTrue`:
   * - `isEq = true`  : `v == e + delta`
   * - `isEq = false` : `v != e + delta`
   */
  pragma[nomagic]
  Guard eqFlowCond(SsaVariable v, Expr e, D::Delta delta, boolean isEq, boolean testIsTrue) {
    exists(boolean eqpolarity |
      result.isEquality(ssaRead(v, delta), e, eqpolarity) and
      (testIsTrue = true or testIsTrue = false) and
      eqpolarity.booleanXor(testIsTrue).booleanNot() = isEq
    )
    or
    exists(boolean testIsTrue0 |
      implies_v2(result, testIsTrue, eqFlowCond(v, e, delta, isEq, testIsTrue0), testIsTrue0)
    )
  }

  /**
   * Holds if `v` is an `SsaExplicitUpdate` that equals `e + delta`.
   */
  predicate ssaUpdateStep(SsaExplicitUpdate v, Expr e, D::Delta delta) {
    exists(Expr defExpr | defExpr = v.getDefiningExpr() |
      defExpr.(CopyValueExpr).getOperand() = e and delta = D::fromFloat(0)
      or
      defExpr.(PostIncExpr).getOperand() = e and delta = D::fromFloat(1)
      or
      defExpr.(PreIncExpr).getOperand() = e and delta = D::fromFloat(1)
      or
      defExpr.(PostDecExpr).getOperand() = e and delta = D::fromFloat(-1)
      or
      defExpr.(PreDecExpr).getOperand() = e and delta = D::fromFloat(-1)
      or
      e = defExpr and
      not (
        defExpr instanceof CopyValueExpr or
        defExpr instanceof PostIncExpr or
        defExpr instanceof PreIncExpr or
        defExpr instanceof PostDecExpr or
        defExpr instanceof PreDecExpr
      ) and
      delta = D::fromFloat(0)
    )
  }

  /**
   * Holds if `e1 + delta` equals `e2`.
   */
  predicate valueFlowStep(Expr e2, Expr e1, D::Delta delta) {
    e2.(CopyValueExpr).getOperand() = e1 and delta = D::fromFloat(0)
    or
    e2.(PostIncExpr).getOperand() = e1 and delta = D::fromFloat(0)
    or
    e2.(PostDecExpr).getOperand() = e1 and delta = D::fromFloat(0)
    or
    e2.(PreIncExpr).getOperand() = e1 and delta = D::fromFloat(1)
    or
    e2.(PreDecExpr).getOperand() = e1 and delta = D::fromFloat(-1)
    or
    additionalValueFlowStep(e2, e1, D::toInt(delta))
    or
    exists(Expr x | e2.(AddExpr).hasOperands(e1, x) |
      D::fromInt(x.(ConstantIntegerExpr).getIntValue()) = delta
    )
    or
    exists(Expr x, SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    |
      D::fromInt(-x.(ConstantIntegerExpr).getIntValue()) = delta
    )
  }

  private newtype TSsaReadPosition =
    TSsaReadPositionBlock(BasicBlock bb) {
      exists(SsaVariable v | v.getAUse().getBasicBlock() = bb)
    } or
    TSsaReadPositionPhiInputEdge(BasicBlock bbOrig, BasicBlock bbPhi) {
      exists(SsaPhiNode phi | phi.hasInputFromBlock(_, bbOrig) and bbPhi = phi.getBasicBlock())
    }

  /**
   * A position at which an SSA variable is read. This includes both ordinary
   * reads occurring in basic blocks and input to phi nodes occurring along an
   * edge between two basic blocks.
   */
  class SsaReadPosition extends TSsaReadPosition {
    /** Holds if `v` is read at this position. */
    abstract predicate hasReadOfVar(SsaVariable v);

    /** Gets a textual representation of this SSA read position. */
    abstract string toString();
  }

  /** A basic block in which an SSA variable is read. */
  class SsaReadPositionBlock extends SsaReadPosition, TSsaReadPositionBlock {
    /** Gets the basic block corresponding to this position. */
    BasicBlock getBlock() { this = TSsaReadPositionBlock(result) }

    override predicate hasReadOfVar(SsaVariable v) { exists(this.getAnSsaRead(v)) }

    pragma[nomagic]
    Expr getAnSsaRead(SsaVariable v) {
      v.getAUse() = result and result.getBasicBlock() = this.getBlock()
    }

    override string toString() { result = "block" }
  }

  /**
   * An edge between two basic blocks where the latter block has an SSA phi
   * definition. The edge therefore has a read of an SSA variable serving as the
   * input to the phi node.
   */
  class SsaReadPositionPhiInputEdge extends SsaReadPosition, TSsaReadPositionPhiInputEdge {
    /** Gets the source of the edge. */
    BasicBlock getOrigBlock() { this = TSsaReadPositionPhiInputEdge(result, _) }

    /** Gets the target of the edge. */
    BasicBlock getPhiBlock() { this = TSsaReadPositionPhiInputEdge(_, result) }

    override predicate hasReadOfVar(SsaVariable v) { this.phiInput(_, v) }

    /** Holds if `inp` is an input to `phi` along this edge. */
    predicate phiInput(SsaPhiNode phi, SsaVariable inp) {
      phi.hasInputFromBlock(inp, this.getOrigBlock()) and
      this.getPhiBlock() = phi.getBasicBlock()
    }

    override string toString() { result = "edge" }
  }

  /**
   * Holds if `guard` directly controls the position `controlled` with the
   * value `testIsTrue`.
   */
  pragma[nomagic]
  predicate guardDirectlyControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guard.directlyControls(controlled.(SsaReadPositionBlock).getBlock(), testIsTrue)
    or
    exists(SsaReadPositionPhiInputEdge controlledEdge | controlledEdge = controlled |
      guard.directlyControls(controlledEdge.getOrigBlock(), testIsTrue) or
      guard.hasBranchEdge(controlledEdge.getOrigBlock(), controlledEdge.getPhiBlock(), testIsTrue)
    )
  }

  /**
   * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
   */
  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guardDirectlyControlsSsaRead(guard, controlled, testIsTrue)
    or
    exists(Guard guard0, boolean testIsTrue0 |
      implies_v2(guard0, testIsTrue0, guard, testIsTrue) and
      guardControlsSsaRead(guard0, controlled, testIsTrue0)
    )
  }

  /**
   * Holds if `inp` is an input to `phi` along a back edge.
   */
  predicate backEdge(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge) {
    edge.phiInput(phi, inp) and
    (
      phi.getBasicBlock().bbDominates(edge.getOrigBlock()) or
      irreducibleSccEdge(edge.getOrigBlock(), phi.getBasicBlock())
    )
  }

  /**
   * Holds if the edge from b1 to b2 is part of a multiple-entry cycle in an irreducible control flow
   * graph. Or if the edge is part of a cycle in unreachable code.
   *
   * An irreducible control flow graph is one where the usual dominance-based back edge detection does
   * not work, because there is a cycle with multiple entry points, meaning there are
   * mutually-reachable basic blocks where neither dominates the other. For such a graph, we first
   * remove all detectable back-edges using the normal condition that the predecessor block is
   * dominated by the successor block, then mark all edges in a cycle in the resulting graph as back
   * edges.
   */
  private predicate irreducibleSccEdge(BasicBlock b1, BasicBlock b2) {
    trimmedEdge(b1, b2) and trimmedEdge+(b2, b1)
  }

  private predicate trimmedEdge(BasicBlock pred, BasicBlock succ) {
    getABasicBlockSuccessor(pred) = succ and
    not succ.bbDominates(pred)
  }

  /**
   * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
   * in an arbitrary 1-based numbering of the input edges to `phi`.
   */
  predicate rankedPhiInput(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, int r) {
    edge.phiInput(phi, inp) and
    edge =
      rank[r](SsaReadPositionPhiInputEdge e |
        e.phiInput(phi, _)
      |
        e order by getBlockId1(e.getOrigBlock()), getBlockId2(e.getOrigBlock())
      )
  }

  /**
   * Holds if `rix` is the number of input edges to `phi`.
   */
  predicate maxPhiInputRank(SsaPhiNode phi, int rix) {
    rix = max(int r | rankedPhiInput(phi, _, _, r))
  }
}
