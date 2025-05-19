private import Raw

class AttributedExpr extends AttributedExprBase, @attributed_expression {
  final override Expr getExpr() { attributed_expression(this, _, result) }

  final override Attribute getAttribute() { attributed_expression(this, result, _) }

  override Location getLocation() { attributed_expression_location(this, result) }

  override Ast getChild(ChildIndex i) {
    i = AttributedExprExpr() and
    result = this.getExpr()
    or
    i = AttributedExprAttr() and
    result = this.getAttribute()
  }
}
