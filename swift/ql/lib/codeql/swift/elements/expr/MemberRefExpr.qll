private import codeql.swift.generated.expr.MemberRefExpr

class MemberRefExpr extends MemberRefExprBase {
  override string toString() { result = "." + this.getMember().toString() }
}
