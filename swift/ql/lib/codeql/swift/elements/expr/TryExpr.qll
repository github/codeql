private import codeql.swift.generated.expr.TryExpr

class TryExpr extends TryExprBase {
  override string toString() { result = "try ..." }
}
