import powershell

class ConstantExpression extends @constant_expression, BaseConstantExpression {
  override SourceLocation getLocation() { constant_expression_location(this, result) }

  string getType() { constant_expression(this, result) }

  StringLiteral getValue() { constant_expression_value(this, result) }

  override string toString() { result = "ConstantExpression at: " + this.getLocation().toString() }
}
