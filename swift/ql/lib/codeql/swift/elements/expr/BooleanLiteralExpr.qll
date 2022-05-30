private import codeql.swift.generated.expr.BooleanLiteralExpr

class BooleanLiteralExpr extends BooleanLiteralExprBase {
  override string toString() { result = this.getValue().toString() }
}
