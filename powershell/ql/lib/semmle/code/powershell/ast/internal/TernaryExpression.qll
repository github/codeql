private import AstImport

class ConditionalExpr extends Expr, TConditionalExpr {
  override string toString() { result = "...?...:..." }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = condExprCond() and
    result = this.getCondition()
    or
    i = condExprTrue() and
    result = this.getIfTrue()
    or
    i = condExprFalse() and
    result = this.getIfFalse()
  }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, condExprCond(), result)
      or
      not synthChild(r, condExprCond(), _) and
      result = getResultAst(r.(Raw::ConditionalExpr).getCondition())
    )
  }

  Expr getIfFalse() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, condExprFalse(), result)
      or
      not synthChild(r, condExprCond(), _) and
      result = getResultAst(r.(Raw::ConditionalExpr).getIfFalse())
    )
  }

  Expr getIfTrue() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, condExprTrue(), result)
      or
      not synthChild(r, condExprTrue(), _) and
      result = getResultAst(r.(Raw::ConditionalExpr).getIfTrue())
    )
  }

  Expr getBranch(boolean value) {
    value = true and
    result = this.getIfTrue()
    or
    value = false and
    result = this.getIfFalse()
  }

  Expr getABranch() { result = this.getBranch(_) }
}
