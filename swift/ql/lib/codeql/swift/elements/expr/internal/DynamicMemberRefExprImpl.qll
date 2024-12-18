private import codeql.swift.generated.expr.DynamicMemberRefExpr

module Impl {
  class DynamicMemberRefExpr extends Generated::DynamicMemberRefExpr {
    override string toString() { result = "." + this.getMember().toString() }
  }
}
