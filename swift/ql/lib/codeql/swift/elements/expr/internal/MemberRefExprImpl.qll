private import codeql.swift.generated.expr.MemberRefExpr

module Impl {
  class MemberRefExpr extends Generated::MemberRefExpr {
    override string toString() { result = "." + this.getMember().toString() }
  }
}
