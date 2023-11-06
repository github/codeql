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
}
