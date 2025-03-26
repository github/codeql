private import Raw

class ArrayExpr extends @array_expression, Expr {
  override SourceLocation getLocation() { array_expression_location(this, result) }

  StmtBlock getStmtBlock() { array_expression(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = ArrayExprStmtBlock() and result = this.getStmtBlock()
  }
}
