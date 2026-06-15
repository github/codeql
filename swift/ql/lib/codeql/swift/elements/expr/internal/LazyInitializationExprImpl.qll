private import codeql.swift.generated.expr.LazyInitializationExpr

module Impl {
  class LazyInitializationExpr extends Generated::LazyInitializationExpr {
    override string toStringImpl() { result = this.getSubExpr().toStringImpl() }
  }
}
