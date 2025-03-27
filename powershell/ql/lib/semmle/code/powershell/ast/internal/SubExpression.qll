private import AstImport

class ExpandableSubExpr extends Expr, TExpandableSubExpr {
  StmtBlock getExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, expandableSubExprExpr(), result)
      or
      not synthChild(r, expandableSubExprExpr(), _) and
      result = getResultAst(r.(Raw::ExpandableSubExpr).getExpr())
    )
  }

  final override string toString() { result = "$(...)" }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = expandableSubExprExpr() and result = this.getExpr()
  }
}
