private import Raw

class ConvertExpr extends @convert_expression, AttributedExprBase {
  override SourceLocation getLocation() { convert_expression_location(this, result) }

  final override Expr getExpr() { convert_expression(this, _, result, _, _) }

  TypeConstraint getType() { convert_expression(this, _, _, result, _) }

  final override AttributeBase getAttribute() { convert_expression(this, result, _, _, _) }

  final override Ast getChild(ChildIndex i) {
    i = ConvertExprExpr() and
    result = this.getExpr()
    or
    i = ConvertExprType() and
    result = this.getType()
    or
    i = ConvertExprAttr() and
    result = this.getAttribute()
  }
}
