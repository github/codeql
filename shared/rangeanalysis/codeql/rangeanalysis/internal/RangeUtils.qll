private import codeql.rangeanalysis.RangeAnalysis

module MakeUtils<Semantic Lang, DeltaSig D> {
  /**
   * Gets an expression that equals `v - d`.
   */
  Lang::Expr ssaRead(Lang::SsaVariable v, D::Delta delta) {
    result = v.getAUse() and delta = D::fromInt(0)
    or
    exists(D::Delta d1, Lang::ConstantIntegerExpr c |
      result.(Lang::AddExpr).hasOperands(ssaRead(v, d1), c) and
      delta = D::fromFloat(D::toFloat(d1) - c.getIntValue()) and
      // In the scope of `x += ..`, which is SSA translated as `x2 = x1 + ..`,
      // the variable `x1` is shadowed by `x2`, so there's no need to view this
      // as a read of `x1`.
      not Lang::isAssignOp(result)
    )
    or
    exists(Lang::SubExpr sub, D::Delta d1, Lang::ConstantIntegerExpr c |
      result = sub and
      sub.getLeftOperand() = ssaRead(v, d1) and
      sub.getRightOperand() = c and
      delta = D::fromFloat(D::toFloat(d1) + c.getIntValue()) and
      not Lang::isAssignOp(result)
    )
    or
    result = v.(Lang::SsaExplicitUpdate).getDefiningExpr() and
    if result instanceof Lang::PostIncExpr
    then delta = D::fromFloat(1) // x++ === ++x - 1
    else
      if result instanceof Lang::PostDecExpr
      then delta = D::fromFloat(-1) // x-- === --x + 1
      else delta = D::fromFloat(0)
    or
    result.(Lang::CopyValueExpr).getOperand() = ssaRead(v, delta)
  }

  /**
   * Holds if `inp` is an input to `phi` along a back edge.
   */
  predicate backEdge(
    Lang::SsaPhiNode phi, Lang::SsaVariable inp, Lang::SsaReadPositionPhiInputEdge edge
  ) {
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
  private predicate irreducibleSccEdge(Lang::BasicBlock b1, Lang::BasicBlock b2) {
    trimmedEdge(b1, b2) and trimmedEdge+(b2, b1)
  }

  private predicate trimmedEdge(Lang::BasicBlock pred, Lang::BasicBlock succ) {
    Lang::getABasicBlockSuccessor(pred) = succ and
    not succ.bbDominates(pred)
  }
}
