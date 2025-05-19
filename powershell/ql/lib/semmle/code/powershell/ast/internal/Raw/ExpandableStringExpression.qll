private import Raw

class ExpandableStringExpr extends @expandable_string_expression, Expr {
  override SourceLocation getLocation() { expandable_string_expression_location(this, result) }

  StringLiteral getUnexpandedValue() { expandable_string_expression(this, result, _, _) }

  int getNumExprs() { result = count(this.getAnExpr()) }

  Expr getExpr(int i) { expandable_string_expression_nested_expression(this, i, result) }

  Expr getAnExpr() { result = this.getExpr(_) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = ExpandableStringExprExpr(index) and
      result = this.getExpr(index)
    )
  }
}
