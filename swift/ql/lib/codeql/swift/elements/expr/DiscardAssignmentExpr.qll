private import codeql.swift.generated.expr.DiscardAssignmentExpr

class DiscardAssignmentExpr extends Generated::DiscardAssignmentExpr {
  override string toString() { result = "_" }
}
