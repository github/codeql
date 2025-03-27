private import Raw

// TODO: Should we remove this from the dbscheme?
class ExpandableSubExpr extends @sub_expression, Expr {
  final override Location getLocation() { sub_expression_location(this, result) }

  StmtBlock getExpr() { sub_expression(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = ExpandableSubExprExpr() and result = this.getExpr()
  }
}
