import powershell

class ExpandableStringExpression extends @expandable_string_expression, Expr {
  override SourceLocation getLocation() { expandable_string_expression_location(this, result) }

  override string toString() {
    result = "ExpandableStringExpression at: " + this.getLocation().toString()
  }

  private int getKind() { expandable_string_expression(this, _, result, _) }

  int getNumExprs() { expandable_string_expression(this, _, _, result) }

  Expr getExpr(int i) { expandable_string_expression_nested_expression(this, i, result) }

  Expr getAnExpr() { result = this.getExpr(_) }
}
