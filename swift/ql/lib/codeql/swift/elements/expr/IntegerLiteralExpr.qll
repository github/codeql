private import codeql.swift.generated.expr.IntegerLiteralExpr

class IntegerLiteralExpr extends IntegerLiteralExprBase {
  override string toString() { result = this.getStringValue() }
}
