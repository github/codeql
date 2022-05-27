private import codeql.swift.generated.expr.StringLiteralExpr

class StringLiteralExpr extends StringLiteralExprBase {
  override string toString() { result = this.getValue() }
}
