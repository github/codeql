private import unified
private import ExprPositionsPlugin

private class ExprPositionsPluginSwift extends ExprPositionsPlugin {
  override predicate isInTypeContextWithImplicitTypeArgs(Expr e) {
    e = any(GenericTypeExpr g).getBase()
  }
}
