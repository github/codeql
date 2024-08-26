import powershell

class ParenExpression extends @paren_expression, Expr {
  PipelineBase getExpression() { paren_expression(this, result) }

  override SourceLocation getLocation() { paren_expression_location(this, result) }

  override string toString() { result = "(...)" }
}
