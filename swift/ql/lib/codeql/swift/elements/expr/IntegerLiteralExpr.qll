private import codeql.swift.generated.expr.IntegerLiteralExpr

class IntegerLiteralExpr extends Generated::IntegerLiteralExpr {
  override string toString() { result = this.getStringValue() }
}
