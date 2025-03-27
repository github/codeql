private import AstImport

class ParenExpr extends Expr, TParenExpr {
  override string toString() { result = "(...)" }

  Expr getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, parenExprExpr(), result)
      or
      not synthChild(r, parenExprExpr(), _) and
      result = getResultAst(r.(Raw::ParenExpr).getBase())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = parenExprExpr() and
    result = this.getExpr()
  }
}
