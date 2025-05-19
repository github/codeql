private import Raw

class UnaryExpr extends @unary_expression, Expr {
  override SourceLocation getLocation() { unary_expression_location(this, result) }

  int getKind() { unary_expression(this, _, result, _) }

  Expr getOperand() { unary_expression(this, result, _, _) }

  final override Ast getChild(ChildIndex i) { i = UnaryExprOp() and result = this.getOperand() }
}
