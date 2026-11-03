private import unified
private import codeql.util.Unit

private module Plugins {
  private import ExprPositionsPluginSwift
}

class ExprPositionsPlugin extends Unit {
  predicate isInTypeContext(Expr e) { none() }
}
