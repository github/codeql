private import codeql.swift.generated.expr.OptionalTryExpr

class OptionalTryExpr extends OptionalTryExprBase {
  override string toString() { result = "try? ..." }
}
