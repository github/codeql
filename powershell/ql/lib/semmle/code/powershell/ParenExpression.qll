import powershell

class ParenExpr extends @paren_expression, Expr {
  PipelineBase getBase() { paren_expression(this, result) }

  override SourceLocation getLocation() { paren_expression_location(this, result) }

  override string toString() { result = "(...)" }
}
