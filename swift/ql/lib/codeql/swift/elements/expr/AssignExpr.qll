private import codeql.swift.generated.expr.AssignExpr

class AssignExpr extends AssignExprBase {
  override string toString() { result = " ... = ..." }
}
