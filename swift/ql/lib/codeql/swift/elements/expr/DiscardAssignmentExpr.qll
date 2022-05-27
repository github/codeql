private import codeql.swift.generated.expr.DiscardAssignmentExpr

class DiscardAssignmentExpr extends DiscardAssignmentExprBase {
  override string toString() { result = "_" }
}
