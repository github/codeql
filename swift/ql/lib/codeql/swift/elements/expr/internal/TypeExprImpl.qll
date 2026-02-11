private import codeql.swift.generated.expr.TypeExpr

module Impl {
  class TypeExpr extends Generated::TypeExpr {
    override string toStringImpl() { result = this.getType().toStringImpl() }
  }
}
