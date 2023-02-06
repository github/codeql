private import codeql.swift.generated.expr.DynamicMemberRefExpr

class DynamicMemberRefExpr extends Generated::DynamicMemberRefExpr {
  override string toString() { result = "." + this.getMember().toString() }
}
