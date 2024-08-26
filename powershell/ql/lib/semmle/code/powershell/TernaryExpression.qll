import powershell

class ConditionalExpr extends @ternary_expression, Expr {
  override string toString() { result = "...?...:..." }

  override SourceLocation getLocation() { ternary_expression_location(this, result) }

  Expr getCondition() { ternary_expression(this, result, _, _) }

  Expr getIfFalse() { ternary_expression(this, _, result, _) }

  Expr getIfTrue() { ternary_expression(this, _, _, result) }
}
