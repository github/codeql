private import AstImport

class UsingExpr extends Expr, TUsingExpr {
  override string toString() { result = "$using..." }

  Expr getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, usingExprExpr(), result)
      or
      not synthChild(r, usingExprExpr(), _) and
      result = getResultAst(r.(Raw::UsingExpr).getExpr())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = usingExprExpr() and
    result = this.getExpr()
  }
}
