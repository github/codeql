private import codeql.swift.generated.expr.InOutExpr

class InOutExpr extends InOutExprBase {
  override string toString() { result = "&..." }
}
