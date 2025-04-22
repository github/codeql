private import AstImport

class ArrayLiteral extends Expr, TArrayLiteral {
  Expr getExpr(int index) {
    exists(ChildIndex i, Raw::Ast r | i = arrayLiteralExpr(index) and r = getRawAst(this) |
      synthChild(r, i, result)
      or
      not synthChild(r, i, _) and
      result = getResultAst(r.(Raw::ArrayLiteral).getElement(index))
    )
  }

  Expr getAnExpr() { result = this.getExpr(_) }

  override string toString() { result = "...,..." }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = arrayLiteralExpr(index) and
      result = this.getExpr(index)
    )
  }
}
