import powershell

class ExpandableStringExpr extends @expandable_string_expression, Expr {
  override SourceLocation getLocation() { expandable_string_expression_location(this, result) }

  override string toString() { result = this.getUnexpandedValue().toString() }

  StringLiteral getUnexpandedValue() { expandable_string_expression(this, result, _, _) }

  private int getKind() { expandable_string_expression(this, _, result, _) }

  int getNumExprs() { result = count(this.getAnExpr()) }

  Expr getExpr(int i) { expandable_string_expression_nested_expression(this, i, result) }

  Expr getAnExpr() { result = this.getExpr(_) }
}
