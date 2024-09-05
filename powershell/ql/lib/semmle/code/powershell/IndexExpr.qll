import powershell

class IndexExpr extends @index_expression, Expr {
  override string toString() { result = "...[...]" }

  override SourceLocation getLocation() { index_expression_location(this, result) }

  Expr getIndex() { index_expression(this, result, _, _) } // TODO: Change @ast to @expr in the dbscheme

  Expr getBase() { index_expression(this, _, result, _) } // TODO: Change @ast to @expr in the dbscheme

  predicate isNullConditional() { index_expression(this, _, _, true) }
}
