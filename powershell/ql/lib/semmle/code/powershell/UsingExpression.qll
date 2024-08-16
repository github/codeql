import powershell

class UsingExpr extends @using_expression, Expr {
  override string toString() { result = "$using..." }

  override SourceLocation getLocation() { using_expression_location(this, result) }
}
