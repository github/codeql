import powershell

class BinaryExpression extends @binary_expression, Expression {
  override string toString() {
    result = "...+..." // TODO
  }

  override SourceLocation getLocation() { binary_expression_location(this, result) }

  int getKind() { binary_expression(this, result, _, _) }

  Expression getLeftHandSide() { binary_expression(this, _, result, _) }

  Expression getRightHandSide() { binary_expression(this, _, _, result) }
}
