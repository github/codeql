private import AstImport

class Redirection extends Ast, TRedirection {
  Expr getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, redirectionExpr(), result)
      or
      not synthChild(r, redirectionExpr(), _) and
      result = getResultAst(r.(Raw::Redirection).getExpr())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = redirectionExpr() and result = this.getExpr()
  }
}
