private import Raw

class ConditionalExpr extends @ternary_expression, Expr {

  override SourceLocation getLocation() { ternary_expression_location(this, result) }

  Expr getCondition() { ternary_expression(this, result, _, _) }

  Expr getIfFalse() { ternary_expression(this, _, result, _) }

  Expr getIfTrue() { ternary_expression(this, _, _, result) }

  Expr getBranch(boolean value) {
    value = true and
    result = this.getIfTrue()
    or
    value = false and
    result = this.getIfFalse()
  }

  Expr getABranch() { result = this.getBranch(_) }

  final override Ast getChild(ChildIndex i) {
    i = CondExprCond() and
    result = this.getCondition()
    or
    i = CondExprTrue() and
    result = this.getIfTrue()
    or
    i = CondExprFalse() and
    result = this.getIfFalse()
  }
}
