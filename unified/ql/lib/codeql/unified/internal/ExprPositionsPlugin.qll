private import unified
private import codeql.util.Unit

private module Plugins {
  private import ExprPositionsPluginSwift
}

class ExprPositionsPlugin extends Unit {
  predicate isInSyntacticTypeContext(Expr e) { none() }

  predicate isReturnedExpr(Callable callable, Expr e) { none() }
}
