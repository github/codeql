import powershell

class ParenExpression extends @paren_expression, Expression {
  PipelineBase getExpression() { paren_expression(this, result) }

  override SourceLocation getLocation() { paren_expression_location(this, result) }

  override string toString() { result = "(...)" }
}
