private import Raw

class ConstExpr extends @constant_expression, BaseConstExpr {
  override SourceLocation getLocation() { constant_expression_location(this, result) }

  override string getType() { constant_expression(this, result) }

  override StringLiteral getValue() { constant_expression_value(this, result) }
}
