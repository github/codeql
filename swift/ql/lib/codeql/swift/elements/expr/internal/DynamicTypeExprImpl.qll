private import codeql.swift.generated.expr.DynamicTypeExpr

module Impl {
  class DynamicTypeExpr extends Generated::DynamicTypeExpr {
    override string toStringImpl() { result = "type(of: ...)" }
  }
}
