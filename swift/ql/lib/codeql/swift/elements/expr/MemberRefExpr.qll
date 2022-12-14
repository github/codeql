private import codeql.swift.generated.expr.MemberRefExpr

class MemberRefExpr extends Generated::MemberRefExpr {
  override string toString() { result = "." + this.getMember().toString() }
}
