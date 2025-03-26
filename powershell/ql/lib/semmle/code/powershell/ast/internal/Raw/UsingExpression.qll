private import Raw

class UsingExpr extends @using_expression, Expr {
  override SourceLocation getLocation() { using_expression_location(this, result) }

  Expr getExpr() { using_expression(this, result) }

  override Ast getChild(ChildIndex i) {
    i = UsingExprExpr() and
    result = this.getExpr()
  }
}
