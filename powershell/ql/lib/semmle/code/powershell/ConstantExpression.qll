import powershell

class ConstExpr extends @constant_expression, BaseConstExpr {
  override SourceLocation getLocation() { constant_expression_location(this, result) }

  string getType() { constant_expression(this, result) }

  StringLiteral getValue() { constant_expression_value(this, result) }

  override string toString() { result = this.getValue().toString() }
}
