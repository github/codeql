private import codeql.swift.generated.expr.AssignExpr

class AssignExpr extends Generated::AssignExpr {
  override string toString() { result = " ... = ..." }
}
