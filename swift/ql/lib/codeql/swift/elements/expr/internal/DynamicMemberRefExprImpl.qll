private import codeql.swift.generated.expr.DynamicMemberRefExpr

module Impl {
  class DynamicMemberRefExpr extends Generated::DynamicMemberRefExpr {
    override string toStringImpl() { result = "." + this.getMember().toStringImpl() }
  }
}
