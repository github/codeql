private import codeql.swift.generated.expr.ParenExpr

class ParenExpr extends ParenExprBase {
  override string toString() { result = "(...)" }
}
