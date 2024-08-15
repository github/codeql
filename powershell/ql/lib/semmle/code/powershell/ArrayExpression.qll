import powershell

class ArrayExpression extends @array_expression, Expression {
  override SourceLocation getLocation() { array_expression_location(this, result) }

  StatementBlock getStatementBlock() { array_expression(this, result) }

  override string toString() { result = "ArrayExpression at: " + this.getLocation().toString() }
}
