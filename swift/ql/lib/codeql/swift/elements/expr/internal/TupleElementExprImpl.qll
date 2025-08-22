private import codeql.swift.generated.expr.TupleElementExpr

module Impl {
  class TupleElementExpr extends Generated::TupleElementExpr {
    override string toStringImpl() { result = "." + this.getIndex() }
  }
}
