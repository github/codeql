private import codeql.swift.generated.expr.DefaultArgumentExpr

module Impl {
  class DefaultArgumentExpr extends Generated::DefaultArgumentExpr {
    override string toStringImpl() { result = "default " + this.getParamDecl().getName() }
  }
}
