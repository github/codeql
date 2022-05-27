private import codeql.swift.generated.expr.DynamicMemberRefExpr

class DynamicMemberRefExpr extends DynamicMemberRefExprBase {
  override string toString() { result = "." + this.getMember().toString() }
}
