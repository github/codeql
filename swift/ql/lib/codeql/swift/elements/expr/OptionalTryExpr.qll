private import codeql.swift.generated.expr.OptionalTryExpr

class OptionalTryExpr extends Generated::OptionalTryExpr {
  override string toString() { result = "try? ..." }
}
