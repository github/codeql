private import codeql.swift.generated.expr.StringLiteralExpr

class StringLiteralExpr extends Generated::StringLiteralExpr {
  override string toString() { result = this.getValue() }
}
