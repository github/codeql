private import AstImport

class AttributedExpr extends AttributedExprBase, TAttributedExpr {
  final override string toString() { result = "[...]" + this.getExpr().toString() }

  final override Expr getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, attributedExprExpr(), result)
      or
      not synthChild(r, attributedExprExpr(), _) and
      result = getResultAst(r.(Raw::AttributedExpr).getExpr())
    )
  }

  final override Attribute getAttribute() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, attributedExprAttr(), result)
      or
      not synthChild(r, attributedExprAttr(), _) and
      result = getResultAst(r.(Raw::AttributedExpr).getAttribute())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = attributedExprExpr() and result = this.getExpr()
    or
    i = attributedExprAttr() and
    result = this.getAttribute()
  }
}
