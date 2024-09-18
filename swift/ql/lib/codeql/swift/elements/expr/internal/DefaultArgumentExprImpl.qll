private import codeql.swift.generated.expr.DefaultArgumentExpr

module Impl {
  class DefaultArgumentExpr extends Generated::DefaultArgumentExpr {
    override string toString() { result = "default " + this.getParamDecl().getName() }
  }
}
