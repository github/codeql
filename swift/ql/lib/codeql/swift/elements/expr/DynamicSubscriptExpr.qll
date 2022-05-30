private import codeql.swift.generated.expr.DynamicSubscriptExpr

class DynamicSubscriptExpr extends DynamicSubscriptExprBase {
  override string toString() { result = this.getMember().toString() + "[...]" }
}
