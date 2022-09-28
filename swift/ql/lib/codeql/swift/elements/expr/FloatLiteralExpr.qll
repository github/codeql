private import codeql.swift.generated.expr.FloatLiteralExpr

class FloatLiteralExpr extends FloatLiteralExprBase {
  override string toString() { result = this.getStringValue() }
}
