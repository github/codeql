private import codeql.swift.generated.expr.DynamicSubscriptExpr

class DynamicSubscriptExpr extends Generated::DynamicSubscriptExpr {
  override string toString() { result = this.getMember().toString() + "[...]" }
}
