private import AstImport

class ExpandableStringExpr extends Expr, TExpandableStringExpr {
  string getUnexpandedValue() {
    result = getRawAst(this).(Raw::ExpandableStringExpr).getUnexpandedValue().getValue()
  }

  override string toString() { result = this.getUnexpandedValue() }

  Expr getExpr(int i) {
    exists(ChildIndex index, Raw::Ast r |
      index = expandableStringExprExpr(i) and r = getRawAst(this)
    |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::ExpandableStringExpr).getExpr(i))
    )
  }

  Expr getAnExpr() { result = this.getExpr(_) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = expandableStringExprExpr(index) and
      result = this.getExpr(index)
    )
  }
}
