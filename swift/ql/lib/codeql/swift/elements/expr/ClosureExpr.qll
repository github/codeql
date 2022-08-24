private import codeql.swift.generated.expr.ClosureExpr

class ClosureExpr extends ClosureExprBase {
  override string toString() { result = "{ ... }" }
}
