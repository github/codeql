private import codeql.swift.generated.expr.FloatLiteralExpr

class FloatLiteralExpr extends Generated::FloatLiteralExpr {
  override string toString() { result = this.getStringValue() }
}
