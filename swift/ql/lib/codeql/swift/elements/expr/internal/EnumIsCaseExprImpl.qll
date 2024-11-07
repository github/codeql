private import codeql.swift.generated.expr.EnumIsCaseExpr

module Impl {
  class EnumIsCaseExpr extends Generated::EnumIsCaseExpr {
    override string toString() { result = "... is " + this.getElement().toString() }
  }
}
