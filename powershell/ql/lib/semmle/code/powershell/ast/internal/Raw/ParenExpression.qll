private import Raw

class ParenExpr extends @paren_expression, Expr {
  PipelineBase getBase() { paren_expression(this, result) }

  override SourceLocation getLocation() { paren_expression_location(this, result) }

  final override Ast getChild(ChildIndex i) { i = ParenExprExpr() and result = this.getBase() }
}
