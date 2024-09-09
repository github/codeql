import powershell

class ArrayExpr extends @array_expression, Expr {
  override SourceLocation getLocation() { array_expression_location(this, result) }

  StmtBlock getStmtBlock() { array_expression(this, result) }

  override string toString() { result = "@(...)" }
}
