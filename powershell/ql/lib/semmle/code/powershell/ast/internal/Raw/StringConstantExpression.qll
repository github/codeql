private import Raw

/** A string constant. */
class StringConstExpr extends @string_constant_expression, BaseConstExpr {
  override StringLiteral getValue() { string_constant_expression(this, result) }

  override string getType() { result = "String" }

  override SourceLocation getLocation() { string_constant_expression_location(this, result) }
}
