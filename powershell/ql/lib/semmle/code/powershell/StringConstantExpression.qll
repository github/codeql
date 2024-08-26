import powershell

class StringConstExpression extends @string_constant_expression, BaseConstExpr {
  StringLiteral getValue() { string_constant_expression(this, result) }

  /** Get the full string literal with all its parts concatenated */
  override string toString() { result = getValue().toString() }

  override SourceLocation getLocation() { string_constant_expression_location(this, result) }
}
