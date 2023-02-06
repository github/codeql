private import codeql.swift.generated.expr.BooleanLiteralExpr

class BooleanLiteralExpr extends Generated::BooleanLiteralExpr {
  override string toString() { result = this.getValue().toString() }
}
