import powershell

class ConvertExpr extends @convert_expression, Expr {
  override string toString() { result = "[...]..." }

  override SourceLocation getLocation() { convert_expression_location(this, result) }

  Expr getExpr() { convert_expression(this, _, result, _, _) }

  TypeConstraint getType() { convert_expression(this, _, _, result, _) }

  AttributeBase getAttribute() { convert_expression(this, result, _, _, _) }
}
