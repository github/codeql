private import AstImport

class ConvertExpr extends AttributedExprBase, TConvertExpr {
  override string toString() { result = "[...]..." }

  final override Expr getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, convertExprExpr(), result)
      or
      not synthChild(r, convertExprExpr(), _) and
      result = getResultAst(r.(Raw::ConvertExpr).getExpr())
    )
  }

  TypeConstraint getType() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, convertExprType(), result)
      or
      not synthChild(r, convertExprType(), _) and
      result = getResultAst(r.(Raw::ConvertExpr).getType())
    )
  }

  final override AttributeBase getAttribute() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, convertExprAttr(), result)
      or
      not synthChild(r, convertExprAttr(), _) and
      result = getResultAst(r.(Raw::ConvertExpr).getAttribute())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = convertExprExpr() and result = this.getExpr()
    or
    i = convertExprType() and result = this.getType()
    or
    i = convertExprAttr() and result = this.getAttribute()
  }
}
