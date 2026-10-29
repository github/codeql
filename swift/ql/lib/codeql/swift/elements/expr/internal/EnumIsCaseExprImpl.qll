private import codeql.swift.generated.expr.EnumIsCaseExpr

module Impl {
  class EnumIsCaseExpr extends Generated::EnumIsCaseExpr {
    override string toStringImpl() { result = "... is " + this.getElement().toStringImpl() }
  }
}
