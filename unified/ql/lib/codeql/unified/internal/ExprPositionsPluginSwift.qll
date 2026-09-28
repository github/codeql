private import unified
private import ExprPositionsPlugin

private class ExprPositionsPluginSwift extends ExprPositionsPlugin {
  override predicate isInTypeContext(Expr e) { e = any(GenericTypeExpr g).getBase() }
}
